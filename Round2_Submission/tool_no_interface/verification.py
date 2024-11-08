import os
import google.generativeai as genai

# Configure the Generative AI model with the API key
genai.configure(api_key="AIzaSyDMV1cDxHTXsaEDMVmxR7UzRrzNqTMdbTc")      # kislay.cse   

# Directory containing the .v files
err_directory = './error_state'
ver_directory = './ver'
src_directory = './src'

# Get system instruction file path from environment variable
sys_inst_file = os.getenv("SYS_INST_FILE")
if not sys_inst_file:
    print("System instruction file path not set. Please specify SYS_INST_FILE.")

# Read the contents of the specified system instruction file
with open(sys_inst_file, 'r', encoding='utf-8') as file:
    system_instruction = file.read()

# Create the model configuration
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    "gemini-1.5-flash-002",
    generation_config=generation_config,
    system_instruction=[system_instruction],
)

# Initialize the chat session with an empty history
chat = model.start_chat(history=[])

# Function to load Gemini Pro model and get responses
def get_gemini_response(question):
    try:
        response = chat.send_message(question, stream=True)
        return response
    except Exception as e:
        print(f"Failed to get response: {str(e)}")
        return None

# Function to send file contents to chat and save responses
def send_file_contents_to_chat(file_path1,file_path2, chat_history, err_directory):
    with open(file_path1, 'r') as file:
        content1 = file.read()
        
        with open(file_path2, 'r') as file:
            content2 = file.read()

            content = "Original Verilog Code -> " + content1 + "Modified verilog Code ->" + content2

            # Send the user's message
            chat_history.append({'role': 'user', 'content': content})
            response = chat.send_message(content)
            
            # Append the model's response to the chat history
            chat_history.append({'role': 'assistant', 'content': response.text})
            
            # Print and save the response
            print(response.text)
            print(f"========================== Sent contents of {file_path1} ==============================")
            
            # Define the response file name
            response_file_name = f"{os.path.basename(file_path1)[:-2]}_state.txt"
            
            # Ensure output directory exists
            if not os.path.exists(err_directory):
                os.makedirs(err_directory)
            
            # Write the response to the output file
            with open(os.path.join(err_directory, response_file_name), 'w') as response_file:
                response_file.write(response.text)
            
            print(f"Response saved to {response_file_name}")

# Iterate through all .v files in the specified directory
chat_history = []
for filename in os.listdir(ver_directory):
    if filename.endswith('.v'):
        file_path1 = os.path.join(ver_directory, filename)
        for filename in os.listdir(src_directory):
            if filename.endswith('.v'):
                file_path2 = os.path.join(src_directory, filename)
                send_file_contents_to_chat(file_path1,file_path2, chat_history, err_directory)
