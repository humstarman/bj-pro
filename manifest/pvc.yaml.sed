kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{.name}}-pvc 
  annotations:
    volume.beta.kubernetes.io/storage-class: "managed-nfs-storage"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
