# Running on Kubernetes

Edit the `kubernetes.yaml` file and set:

- Deployment: `.spec.template.spec.containers[0].image` 
- Ingress: `.spec.rules[0].host`

Start using

```
cd contrib/kubernetes
./nap-compiler-k8s.sh start
```

Stop using

```
cd contrib/kubernetes
./nap-compiler-k8s.sh stop
```
