import pathlib
import uvicorn
import subprocess
import json
import uuid
import base64

from typing import Any, Dict, AnyStr, List, Union

from fastapi import FastAPI, Request
from fastapi.responses import PlainTextResponse, Response, JSONResponse

app = FastAPI(
    title="NGINX App Protect WAF Compiler REST API",
    version="1.0.0",
    contact={"name": "GitHub", "url": "https://github.com/TBD"}
)

JSONObject = Dict[AnyStr, Any]
JSONArray = List[Any]
JSONStructure = Union[JSONArray, JSONObject]

@app.post("/v1/compile/policy", status_code=200, response_class=JSONResponse)
def post_devportal(response: Response, request: JSONStructure = None):
    if request:
        try:
            sessionUUID = uuid.uuid4()
            napPolicy = json.dumps(request)
            tmpFileBase = f"/tmp/{sessionUUID}"
            tmpFilePolicy = f"{tmpFileBase}.policy.json"
            tmpFileBundle = f"{tmpFileBase}.tgz"
            tmpFile = open(tmpFilePolicy,"w")
            tmpFile.write(napPolicy)
            tmpFile.close()

            output = subprocess.check_output(f"/opt/app_protect/bin/apcompile --global /compiler/etc/global_settings.json -p '{tmpFilePolicy}' -o '{tmpFileBundle}'", shell=True)

            with open(tmpFileBundle, 'rb') as file:
                napBundle = base64.b64encode(file.read())

            #return JSONResponse (content={'status': 'success','message': f'{json.loads(output.decode())}', 'policy': f'{request}','bundle': f'{napBundle.decode()}'}, status_code=200)
            return JSONResponse (content={'status': 'success','message': json.loads(output.decode()), 'policy': request,'bundle': f'{napBundle.decode()}'}, status_code=200)
        except subprocess.CalledProcessError as e:
            return JSONResponse (content={'status': str(e)}, status_code=400)
        finally:
            policyFile = pathlib.Path(tmpFilePolicy)
            if policyFile.is_file():
                policyFile.unlink()

            bundleFile = pathlib.Path(tmpFileBundle)
            if bundleFile.is_file():
                bundleFile.unlink()
    else:
        return JSONResponse (content={'status': 'invalid body'}, status_code=400)

if __name__ == '__main__':
    uvicorn.run("server:app", host='0.0.0.0', port=5000)
