apiVersion: v1
kind: Service
metadata:
  namespace: {{.namespace}}
  labels:
    component: {{.name}} 
  name: {{.name}}
spec:
  type: ClusterIP 
  selector:
    component: {{.name}}
  ports:
    - port: 8080
      targetPort: 8080 
      name: http 
