# CSAW_SEAL
=============================

This repo contains all the files and codes which we are submitting in the CSAW'24 AI-based Hardware Attack Challenge.

###  Using LLMs via API in Python

To use Large Language Models (LLMs) like ChatGPT and Gemini in Python, you need to install their respective API libraries and set up API keys. Follow the steps below to get started.

**1. Setup**

The makefile in the main repo helps to setup the virtual environment and install the required libraries. All three must be followed.

To install supported python version (3.9) and virtual environment.(Required only during initial setup)

    $ make env

To activate the virtual env.

    $ source my_env/bin/activate
    
To install all the libraries. (Must be done after activating the virtual env.)(Required only during initial setup)

    $ make install

**2. Generating LLM responses**


Everytime we have to activate the virtual env to run the LLM script, so always run the second command before starting the session.

Our Tool is mainly organised in two folders i.e. `tool_CLI` and `tool_UI`.
`tool_CLI` - Operated from the Command Line
`tool_UI` - Operated through a web based application

Inside both these folders, we have 2 tools i.e. Vulnerability Identifier and Trojan Injector.
Before we do something with the tool, we have to put our design code in the src folder and make sure the folder has only one `.v` file at a time.

**for Tool_CLI **
To use the tools in `1_vulnerability_Identifier`, we have to go to `1_vulnerability_Identifier` and do `make`. then it will generate the DAG and exploitable trojans.

To use the tools in `2_trojan_injector`, we have to go to `2_trojan_injector` and do `make gpt` or `make gemini`. then it will generate the trojan inserted code.

**for Tool_UI **
To use the tools in `1_vulnerability_Identifier`, we have to go to `1_vulnerability_Identifier` and do `make`. then it will open a web page and then click on `generate`

To use the tools in `2_trojan_injector`, we have to go to `2_trojan_injector` and do `make`. then it will open a web page and then click on `generate`

