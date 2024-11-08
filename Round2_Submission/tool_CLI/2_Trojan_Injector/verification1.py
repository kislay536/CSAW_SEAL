import os
import openai

# Configure OpenAI with the API key from environment variable
openai.api_key = os.getenv("OPENAI_API_KEY")

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

# Function to send a prompt to GPT-4 model and get a response
def get_gpt4_response(prompt):
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[{"role": "system", "content": system_instruction}, {"role": "user", "content": prompt}],
            max_tokens=1000,
            temperature=1,
            top_p=0.95
        )
        return response['choices'][0]['message']['content']
    except Exception as e:
        print(f"Failed to get response: {str(e)}")
        return None

# Function to send file contents to chat and save responses
def send_file_contents_to_chat(file_path1, file_path2, chat_history, err_directory):
    with open(file_path1, 'r') as file:
        content1 = file.read()
        
    with open(file_path2, 'r') as file:
        content2 = file.read()

    prompt_content = f"Original Verilog Code -> {content1} Modified Verilog Code -> {content2}"
    response = get_gpt4_response(prompt_content)
    if response:
        print(response)
        response_file_name = f"{os.path.basename(file_path1)[:-2]}_state.txt"
        if not os.path.exists(err_directory):
            os.makedirs(err_directory)
        with open(os.path.join(err_directory, response_file_name), 'w') as response_file:
            response_file.write(response)
        print(f"Response saved to {response_file_name}")
    else:
        print(f"No valid response for {file_path1}")

chat_history = []
for filename in os.listdir(ver_directory):
    if filename.endswith('.v'):
        file_path1 = os.path.join(ver_directory, filename)
        for filename in os.listdir(src_directory):
            if filename.endswith('.v'):
                file_path2 = os.path.join(src_directory, filename)
                send_file_contents_to_chat(file_path1, file_path2, chat_history, err_directory)