import os
import openai

# Configure the OpenAI API with your API key
openai.api_key = "your API key"

# Directory containing the .v files
directory = '.'

# Function to send file contents to chat and keep track of responses
def send_file_contents_to_chat(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        user_message = """ 
        just follow the instructions only and nothing else
        Instructions-
        (1. I am giving you verilog code of a circuit you have to convert it to a Directed Acyclic graph (DAG) and understand it properly.) 
        (1A. Print the DAG as understandable as possible as Adjacency list)
        (2. Based on the DAG, check if we can add a hardware trojan in this design and if possible then generate the verilog code for the same trojan based on the given code and Enclose the trojan inserted entire verilog code with  "//=====START======" and "//=====END======")   
        (3. Explain about the trojan and how it can be triggered) verilog code ->""" + content
        
        
        # Send the user's message to OpenAI's API
        response = openai.ChatCompletion.create(
            model="gpt-4",  # or "gpt-4" if you have access
            messages=[
                {"role": "user", "content": user_message}
            ]
        )
        
        # Extract the assistant's response
        assistant_response = response['choices'][0]['message']['content']
        
        print(assistant_response)
        print(f"==========================Sent contents of {file_path} ==============================")
        
        
        # Create a text file with the name format gpt_{file_name}.v.txt
        file_name = os.path.splitext(os.path.basename(file_path))[0]  # Get the base name without extension
        response_file_name = f"gpt_{file_name}.v.txt"

        # Write the assistant's response to the output file
        with open(response_file_name, 'w') as response_file:
            response_file.write(assistant_response)
        
        print(f"Response saved to {response_file_name}")

# Iterate through all .v files in the specified directory
for filename in os.listdir(directory):
    if filename.endswith('880.v'):
        file_path = os.path.join(directory, filename)
        send_file_contents_to_chat(file_path)


