#!/usr/bin/env bash


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
pei "oc-mirror list operators --catalogs --version=4.9"
wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find the available packages within the selected catalog:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9"
wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find channels for the selected package:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9 --package=nfd"
wait
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find package versions within the selected channel:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror list operators --catalog=registry.redhat.io/redhat/redhat-operator-index:v4.9 --package=nfd --channel=stable"
wait

# Release discovery
DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "Find OCP releases by major/minor version:\n"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror list releases --version=4.9"
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
pei "oc-mirror --config imageset-config.yaml file://output-dir"

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
pei "oc-mirror --from ./output-dir/mirror_seq1_000000.tar docker://localhost:5011 --dest-skip-tls"
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
PROMPT_TIMEOUT=3
p "\n"
p "Create the update imageset:"
DEMO_PROMPT="$ "
PROMPT_TIMEOUT=2
pei "oc-mirror --config update-imageset-config.yaml file://output-dir"
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
pei "oc-mirror --from ./output-dir/mirror_seq2_000000.tar docker://localhost:5011 --dest-skip-tls"

DEMO_PROMPT=""
PROMPT_TIMEOUT=3
p "\n"
p "That concludes this demo"


# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""

