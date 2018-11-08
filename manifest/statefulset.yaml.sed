apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  namespace: {{.namespace}} 
  name: {{.name}} 
spec:
  serviceName: "{{.name}}"
  podManagementPolicy: Parallel
  replicas: 1
  template:
    metadata:
      labels:
        component: {{.name}}
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: {{.name}}
          image: {{.image}} 
          imagePullPolicy: {{.image.pull.policy}} 
          env:
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - containerPort: 8080 
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: pics 
              mountPath: {{.mount.path}} 
      volumes:
        - name: host-time
          hostPath:
            path: /etc/localtime
        - name: pics 
          persistentVolumeClaim:
            claimName: {{.pvc.name}} 

