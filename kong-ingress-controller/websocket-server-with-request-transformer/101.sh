# Create the websocketd deployment
kubectl apply -f websocketd.yaml

# Create the websocketd service
kubectl apply -f service.yaml

# Create the Ingress
kubectl apply -f simple-ingress.yaml

# Test the connection to the Websocket pod (outside of Kong)
curl -v -i -N -H "Sec-WebSocket-Key: XTYA" -H "Sec-Websocket-Version:13" -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Origin: http://localhost" http://10.106.92.107:9998

# Test through the Gateway
 curl -v -i -N -H "Sec-WebSocket-Key: XTYA" -H "Sec-Websocket-Version:13" -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Origin: http://localhost" http://10.99.75.49:9999/version10

# Apply the request transformer plugin
kubectl apply -f request-transformer.yaml

# Test again
curl -v -i -N -H "Sec-WebSocket-Key: XTYA" -H "Sec-Websocket-Version:13" -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Origin: http://localhost" http://10.99.75.49:9999/version10

# Check the logs for the Websocket pod to confirm the path appends a /, ie url:'http://10.99.75.49:9999/version10/' 
kubectl logs websocketd-deployment-c768c8c9c-gzbph -f

# Dumping the Kong logs will also show the URI re-write
# access.lua:505 [request-transformer] 8[request-transformer] template `/$(uri_captures['version'])/` rendered to `/version10/`


