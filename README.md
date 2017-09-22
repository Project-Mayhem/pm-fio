# Project-mayhem-fio

Note of help:  If using Minikube, run the following to gain access to the docker daemon which is running in the Virtualbox-provided env.  Use this for Docker build:

eval $(minikube docker-env)

FIO is typically for testing storage IO performance, despite how the storage is attached.  For the purpose of 
testing within Kubernetes, we wanted to make sure that when testing transient storage or persistent block storage 
that we had resident the means to copy the resulting data files from test runs out of the container and / or storage
back to a location where we could analyze it.

Consider this Docker Image a hack.  There are better ways to address file movement, for instance mounting the storage at a future time with a data movement container, or retrieving the data with a sidecar container like LogStash.

The goal with this image is to introduce various scripts that execute the FIO job and then move the results out.  

# Usage -

## Results Movement
Mount in your own job.fio, replacing /config/job.fio.
Mount in your own script which is executed by the entry.sh, replacing /home/fio/script.sh

### SCP
The first means of this is via scp.

Set the JOB_NAME - the name of the output file will be $JOB_NAME-

Set the environment variables for the Target host to move the data results to:
SCP_PASSWORD_FILE - path and name of password file - mount a file in with a secret and specify in this env var
SCP_TARGET_USERNAME_FILE- Username to log into target host
SCP_TARGET_HOST   - Target hostname or IP
SCP_TARGET_PATH   - Path to place file on target host

Example container config for kubernetes:
-----
apiVersion: v1
kind: Pod
metadata:
  name: "pm-fio-pod"
spec:
  containers:
  - name: mypod
    image: "redis"
     volumeMounts:
     - name: foo
       mountPath: "/etc/baz"
       readOnly: true
  volumes:
  - name: foo
    secret:
    secretName: "scp-secret"

Example secret
echo -n 'username' | base64 => this is the base64-encoded username
do the same for a password.  Populate the variables below and create your secret.

example secret.yaml
------
apiVersion: v1
kind: Secret
metadata: 
  name: scp-secret
  type: Opaque
  data: 
    username: <base64 encoded username>
    password: <base64 encoded password>



