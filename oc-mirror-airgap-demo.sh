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
mkdir -p ./bin
PATH=$PATH:$PWD/bin
git clone https://github.com/openshift/oc-mirror.git && \
cd oc-mirror
./hack/build.sh &>/dev/null || exit 1; echo "oc-mirror build failed"
cd -
mv ./oc-mirror/bin/oc-mirror ./bin/


GOBIN=$PWD/bin go install github.com/google/go-containerregistry/cmd/registry@latest

registry -port 5010 &
PID_5001=$!
registry -port 5011 &
PID_5002=$!



########################
# include the magic
########################
. ./demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
#DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# text color
# DEMO_CMD_COLOR=$BLACK

# hide the evidence
clear

# Intro
DEMO_PROMPT=""
PROMPT_TIMEOUT=1
p "Title: oc-mirror airgap demo"
p "This demo meets the following objectives:"
p "1. Discover content with oc-mirror"
p "2. Create an imageset"
p "3. Publish an imageset"
p "4. Create an update imageset"
p "5. Publish an update imageset\n"
p "Let's get started!\n"
clear

# Operator Discovery
PROMPT_TIMEOUT=3
p "1. Discover content with oc-mirror\n"
p "Find the available catalogs for the target version:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror list operators --catalogs --version=4.9\n"
#wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find the available packages within the selected catalog:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9\n"
#wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find channels for the selected package:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9 --package=nfd\n"
#wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find package versions within the selected channel:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei ".oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9 --package=nfd --channel=stable\n"
#wait

# Release discovery
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find OCP releases by major/minor version:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror list releases --version=4.9 \n"
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "\n"
clear

# View config
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "2. Create an imageset\n"
p "Compose the imageset-config"
p "Here is an example config that we will be using:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "cat imageset-config.yaml"
DEMO_PROMPT=""
PROMPT_TIMEOUT=2
p "\n"
wait

# Create the imageset
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Create artifact output directory:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "mkdir -p output-dir"
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p ""
p "Create the imageset"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror --config imageset-config.yaml file://output-dir --skip-missing \n"

# Transfer the imageset to the target env
PROMPT_TIMEOUT=3
DEMO_PROMPT=""
p "Once the imageset is created, transfer it to the disconnected environment."
p "\n"

# Publish the imageset
clear
p "3. Publish an imageset\n"
p "Publish the imageset to the disconnected registry:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror --from ./output-dir/mirror_seq1_000000.tar docker://localhost:5002\n"
DEMO_PROMPT=""
PROMPT_TIMEOUT=2
p "\n"

# Create an update
clear
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "4. Create an update imageset"
p "We will use this example imageset-config to download additional content:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "cat update-imageset-config.yaml"
DEMO_PROMPT=""
PROMPT_TIMEOUT=2
p "\n"
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Transfer the imageset to the disconnected environment."
p "\n"

# Publish the imageset
clear
p "5. Publish an update imageset\n"
p "Publish the imageset to the disconnected registry:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
#pei "oc-mirror --from ./output-dir/mirror_seq2_000000.tar docker://localhost:5002\n"
p "\n"


# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""


# Cleanup workspace
kill $PID_5001
kill $PID_5002
rm -Rf ./bin ./output-dir ./oc-mirror-workspace ./oc-mirror
