#!/usr/bin/env bash

########################
# Demo prep
########################
if ! which go &>/dev/null
then
  printf "Golang binary not found.\nThis demo needs go to setup the environment"
  exit 1 
fi
if ! which podman &>/dev/null
then
  printf "Podman binary not found.\nThis demo needs podman to setup the environment"
  exit 1 
fi
if ! which git &>/dev/null
then
  printf "Git not found.\nThis demo needs git to setup the environment"
  exit 1 
fi
if ! which pv &>/dev/null
then
  printf "pv not found.\nThis demo uses pv"
  exit 1 
fi
if ! which asciinema &>/dev/null
then
  printf "asciinema not found.\nThis demo uses asciinema for recording "
  exit 1 
fi
mkdir -p ./bin
rm -Rf oc-mirror
PATH=$PATH:$PWD/bin
git clone https://github.com/openshift/oc-mirror.git && \
cd oc-mirror

if ! ./hack/build.sh
then 
  echo "oc-mirror build failed"
  exit 1
fi

cd -
mv ./oc-mirror/bin/oc-mirror ./bin/


GOBIN=$PWD/bin go install github.com/google/go-containerregistry/cmd/registry@latest

registry -port 5010 &
PID_5001=$!
registry -port 5011 &
PID_5002=$!

#Launch the recording
asciinema rec -c "./oc-mirror-airgap-demo.sh" oc-mirror-recording-$(date +%s)

 # Cleanup workspace
kill $PID_5001 &>/dev/null
kill $PID_5002 &>/dev/null
rm -Rf ./bin ./output-dir ./oc-mirror-workspace ./oc-mirror