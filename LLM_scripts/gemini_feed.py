import os
import google.generativeai as genai

# Configure the Generative AI model with the API key
genai.configure(api_key="Your API key")

# Directory containing the .v files
directory = '.'

# Create the model configuration
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

# Initialize the generative model
model = genai.GenerativeModel(
    model_name="gemini-1.5-pro-002",
    generation_config=generation_config,
)

# Initialize the chat session with an empty history
chat_session = model.start_chat(history=[])

# Function to send file contents to chat and keep track of responses
def send_file_contents_to_chat(file_path, chat_history):
    with open(file_path, 'r') as file:
        content = file.read()
        user_message = """ 
        just follow the instructions only and nothing else
        Instructions-
        (1. I am giving you verilog code of a circuit you have to convert it to a Directed Acyclic graph (DAG) and understand it properly.) 
        (1A. Print the DAG as understandable as possible as Adjacency list)
        (2. Based on the DAG, check if we can add a hardware trojan in this design and if possible then generate the verilog code for the same trojan based on the given code and Enclose the trojan inserted entire verilog code with  "//=====START======" and "//=====END======")   
        (3. Explain about the trojan and how it can be triggered) verilog code ->""" + content
        
        # Send the user's message
        chat_history.append({'role': 'user', 'content': user_message})
        response = chat_session.send_message(user_message)
        
        # Append the model's response to the chat history
        chat_history.append({'role': 'assistant', 'content': response.text})
        
        print(response.text)
        print(f"==========================Sent contents of {file_path} ==============================")
        
        # Create a text file with the same name as the Verilog file but with a .txt extension and add the "gemini" prefix
        response_file_name = f"gemini_{os.path.basename(file_path)}.txt"
        
        # Ensure the directory exists
        output_dir = os.path.dirname(file_path)  # Get the directory of the input file
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)  # Create the directory if it does not exist
        
        # Write the response to the output file
        with open(os.path.join(output_dir, response_file_name), 'w') as response_file:
            response_file.write(response.text)
        
        print(f"Response saved to {response_file_name}")

# Iterate through all .v files in the specified directory
chat_history = []  # Initialize chat history
for filename in os.listdir(directory):
    if filename.endswith('880.v'):
        file_path = os.path.join(directory, filename)
        send_file_contents_to_chat(file_path, chat_history)

