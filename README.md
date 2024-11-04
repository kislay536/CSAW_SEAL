# CSAW_SEAL
=============================

This repo contains all the files and codes which we are submitting in the CSAW'24 AI-based Hardware Attack Challenge.

###  Using LLMs via API in Python

To use Large Language Models (LLMs) like ChatGPT and Gemini in Python, you need to install their respective API libraries and set up API keys. Follow the steps below to get started.

**1. Setup**

The makefile in the main repo helps to setup the virtual environment, install the required libraries and activate the virtual environment.

To install supported python version (3.9) and virtual environment.

    $ make env

To activate the virtual env.

    $ source my_env/bin/activate
    
To install all the libraries. (Must be done after activating the virtual env.)

    $ make install

**2. Generating LLM responses**

The `LLM_scripts` folder contains pyhton scripts for ChatGPT and Gemini. We can change the query by just changing the `user_response` variable. Upon running the script, it will generate the `.txt` file which will have the responses of the LLM. 

For this round, we have demonstrated trojan insertion in c17 benchmark circuit, ISCAS'85 and we intend to do the same with AES in the next round. For this purpose, we will be feeding all the submodules of the AES to the LLM and our script is designed to read all the `.v` or `verilog` files one by one and then produce the responses.
