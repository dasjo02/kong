# Ingress = Route
# Kubernetes Service = Service + Upstream
# Pods = Target
# The below assumes you Kong running on Kubernetes and have created a namespace "cre"

# Create some sample deployments and services, echo and httpbin
kubectl apply -f https://bit.ly/sample-echo-service -n cre
kubectl apply -f https://bit.ly/sample-httpbin-service -n cre


# You can confirm these are created/running with the below
kubectl get deploy,svc echo -n cre
kubectl get deploy,svc httpbin -n cre


# Create a Kubernetes Ingress Object. This will create an Ingress named "demo", which KIC will use to create a route
# with a path of /echo, pointing to the Kubernetes echo service
kubectl apply -f Ingress/simple-ingress.yaml -n cre


# Create some KongIngress Objects to extend the Kubernetes Ingress Object. This allows deeper customization like
# hash on ip or stripping the path before routing
kubectl apply -f KongIngress/kong-ingress-strip-path.yaml -n cre
kubectl apply -f KongIngress/kong-ingress-hash-on-ip.yaml -n cre


# Patch the existing Kubernetes Ingress Object to use the KongIngress annoation (associating the KongIngress with the Kubernetes Ingress)
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/override":"strip-path"}}}' -n cre
kubectl patch service echo -p '{"metadata":{"annotations":{"configuration.konghq.com":"hash-on-ip"}}}' -n cre



# *************************** PLUGINS ***************************
# IP RESTRICTION
kubectl apply -f Plugins/ip-restriction/ip-restriction.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"ip-route-plugin"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"ip-route-plugin"}}}' -n cre




# CORS
kubectl apply -f Plugins/cors/cors.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"cors-plugin"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"cors-plugin"}}}' -n cre

# *************************** /PLUGINS ***************************




# FILE LOG
kubectl apply -f Plugins/file-log/file-log.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"file-log"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"file-log"}}}' -n cre

# *************************** /PLUGINS ***************************




# RATE LIMITING
kubectl apply -f Plugins/rate-limiting/rate-limiting.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"kong-rl-basic"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"kong-rl-basic"}}}' -n cre

# *************************** /PLUGINS ***************************




# REQUEST TERMINATION
kubectl apply -f Plugins/request-termination/request-termination.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"req-term"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"req-term"}}}' -n cre

# *************************** /PLUGINS ***************************




# REQUEST TRANSFORMER
kubectl apply -f Plugins/request-transformer/request-transformer.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"req-transformer"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"req-transformer"}}}' -n cre

# Test ot
curl --data body-param1=test  10.99.75.49:9999/echo -v
# *************************** /PLUGINS ***************************




# SERVERLESS - PRE-PLUGIN
kubectl apply -f Plugins/serverless/pre-plugin.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"pre-plugin"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"pre-plugin"}}}' -n cre
# *************************** /PLUGINS ***************************




# SERVERLESS - POST-PLUGIN
kubectl apply -f Plugins/serverless/post-plugin.yaml -n cre

# Apply the pluging to either the service or the route
# Service
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"post-plugin"}}}' -n cre

# Route
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/plugins":"post-plugin"}}}' -n cre
# *************************** /PLUGINS ***************************



# Create a secret to store the CA cert
kubectl apply -f Plugins/mTLS/ca-secret.yaml -n cre

# Create the mTLS plugin
kubectl apply -f Plugins/mTLS/mtls.yaml -n cre

# Patch the Ingress
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/plugins":"mtls-auth"}}}' -n cre
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/snis":"foo.example.com, bar.example.com"}}}' -n cre

