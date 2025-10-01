# NVIDIA GPU Operator

Based on https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html#procedure

## Installation

### 1. Add NVIDIA Helm Repository

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update
```

### 2. Install GPU Operator

#### Basic Installation (Default Configuration)

```bash
helm install --wait --generate-name \
    -n gpu-operator --create-namespace \
    nvidia/gpu-operator \
    --version=v25.3.4
```

### 4. Container Runtime Specific Configuration

#### For containerd

```bash
helm install gpu-operator -n gpu-operator --create-namespace \
  nvidia/gpu-operator \
    --version=v25.3.4 \
    --set toolkit.env[0].name=CONTAINERD_CONFIG \
    --set toolkit.env[0].value=/etc/containerd/config.toml \
    --set toolkit.env[1].name=CONTAINERD_SOCKET \
    --set toolkit.env[1].value=/run/containerd/containerd.sock \
    --set toolkit.env[2].name=CONTAINERD_RUNTIME_CLASS \
    --set toolkit.env[2].value=nvidia \
    --set toolkit.env[3].name=CONTAINERD_SET_AS_DEFAULT \
    --set-string toolkit.env[3].value=true
```

## Verification

### Check Installation Status

```bash
# Check if all GPU Operator components are running
kubectl get pods -n gpu-operator

# Check node labels for GPU resources
kubectl get nodes -o json | jq '.items[].metadata.labels | select(."nvidia.com/gpu.present")'
```

### Test GPU Access

#### CUDA VectorAdd Test

Create a test pod to verify GPU access:

```yaml
# cuda-vectoradd.yaml
apiVersion: v1
kind: Pod
metadata:
  name: cuda-vectoradd
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-vectoradd
    image: "nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda11.7.1-ubuntu20.04"
    resources:
      limits:
        nvidia.com/gpu: 1
```

```bash
# Apply and run the test
kubectl apply -f cuda-vectoradd.yaml

# Check logs for successful execution
kubectl logs pod/cuda-vectoradd

# Clean up
kubectl delete -f cuda-vectoradd.yaml
```

Expected output:
```
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

## GPU Sharing for Multiple Pods

When you have a single GPU node and need to run multiple pods requiring GPU resources, you can configure GPU sharing using time-slicing or memory fractioning.

### GPU Time-Slicing (Recommended)

Time-slicing allows multiple pods to share a single GPU by dividing GPU time among them. This is ideal for compute-intensive workloads.

#### Configuration

Apply the time-slicing configuration:

```bash
# Apply the time-slicing configuration
kubectl apply -f gpu-time-slicing-config.yaml

# Restart the device plugin to pick up the new configuration
kubectl rollout restart daemonset/nvidia-device-plugin-daemonset -n gpu-operator
```

The configuration file `gpu-time-slicing-config.yaml` sets up 4 replicas, allowing 4 pods to share 1 GPU:

```yaml
# gpu-time-slicing-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: device-plugin-config
  namespace: gpu-operator
data:
  config.yaml: |
    version: v1
    sharing:
      timeSlicing:
        resources:
        - name: nvidia.com/gpu
          replicas: 4  # This allows 4 pods to share 1 GPU
```

#### Deploy Multiple GPU Pods

```bash
# Deploy multiple pods that will share the same GPU
kubectl apply -f multiple-gpu-pods.yaml
```

The `multiple-gpu-pods.yaml` file contains 4 pods, each requesting 1 GPU resource but sharing the same physical GPU through time-slicing.

### GPU Memory Fractioning

For memory-intensive workloads, you can use GPU memory fractioning:

```bash
# Apply memory fractioning configuration
kubectl apply -f gpu-memory-fractioning-config.yaml

# Restart the device plugin
kubectl rollout restart daemonset/nvidia-device-plugin-daemonset -n gpu-operator
```

The `gpu-memory-fractioning-config.yaml` allows 2 pods to share GPU memory:

```yaml
# gpu-memory-fractioning-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: device-plugin-config
  namespace: gpu-operator
data:
  config.yaml: |
    version: v1
    sharing:
      mps:
        resources:
        - name: nvidia.com/gpu
          replicas: 2  # This allows 2 pods to share GPU memory
```

### Mixed Approach

For diverse workload types, you can combine both time-slicing and memory fractioning:

```bash
# Apply mixed sharing configuration
kubectl apply -f gpu-mixed-sharing-config.yaml

# Restart the device plugin
kubectl rollout restart daemonset/nvidia-device-plugin-daemonset -n gpu-operator
```

### Verification

Use the verification script to check GPU sharing setup:

```bash
# Make the script executable
chmod +x verify-gpu-sharing.sh

# Run verification
./verify-gpu-sharing.sh
```

The script checks:
- GPU resources on nodes
- Pod status
- GPU device plugin status
- Node GPU capacity
- Pod events

### Monitoring GPU Usage

Monitor GPU usage across your pods:

```bash
# Check GPU utilization
kubectl exec -it <pod-name> -- nvidia-smi

# Check GPU memory usage
kubectl exec -it <pod-name> -- nvidia-smi --query-gpu=memory.used,memory.total --format=csv
```

### Available YAML Files

This directory contains the following configuration files:

- `cuda-vectoradd.yaml` - Single GPU test pod
- `gpu-time-slicing-config.yaml` - Time-slicing configuration (4 replicas)
- `gpu-memory-fractioning-config.yaml` - Memory fractioning configuration (2 replicas)
- `gpu-mixed-sharing-config.yaml` - Mixed sharing configuration
- `multiple-gpu-pods.yaml` - Example multiple GPU pods for testing
- `verify-gpu-sharing.sh` - Verification script for GPU sharing setup

### Important Notes

- **Time-slicing**: Pods share GPU compute time but each gets exclusive access during their time slice
- **Memory fractioning**: Pods share GPU memory but may have reduced performance
- **Resource limits**: Each pod still requests `nvidia.com/gpu: 1`, but the device plugin schedules them on the same physical GPU
- **Performance**: There will be some performance overhead due to context switching between pods
- **Replicas**: Adjust the `replicas` value in the configuration based on your workload requirements

## Uninstallation

To remove the NVIDIA GPU Operator:

```bash
# List installed releases
helm list -n gpu-operator

# Uninstall the operator (replace <release-name> with actual name)
helm uninstall <release-name> -n gpu-operator

# Remove the namespace (optional)
kubectl delete namespace gpu-operator
```