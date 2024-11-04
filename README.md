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
`api_all` folder will instanciate 23 different windows each for different Trojans and the `api_single` will instanciate single window.
To run the tool, we need to move to the above directories and pass the command

    $ make

