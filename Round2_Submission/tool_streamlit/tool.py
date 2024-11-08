from PIL import Image
import streamlit as st
import os
import google.generativeai as genai
import subprocess


# Define the paths to your files
file1_path = './sys_inst_src/inst.txt'
file2_path = './sys_inst_ver/inst.txt'
file3_path = './sys_inst_mod/inst.txt'

# Read each file and load its contents
file_contents = {}

for file_path in [file1_path, file2_path, file3_path]:
    with open(file_path, 'r') as file:
        file_contents[file_path] = file.read()

# Create the model configuration
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

# Configure the Generative AI model with the API key
genai.configure(api_key="AIzaSyDH_cpqO4fMMmitR4bbBKtl64qsnHgOF24")    #kislayarya536

model1 = genai.GenerativeModel(
    "gemini-1.5-flash-002",
    generation_config=generation_config,
    system_instruction=[file_contents[file1_path]],
)

# Configure the Generative AI model with the API key
genai.configure(api_key="AIzaSyDMV1cDxHTXsaEDMVmxR7UzRrzNqTMdbTc")      # kislay.cse   

model2 = genai.GenerativeModel(
    "gemini-1.5-flash-002",
    generation_config=generation_config,
    system_instruction=[file_contents[file2_path]],
)

# Configure the Generative AI model with the API key
genai.configure(api_key="AIzaSyBA-cJecyea2iFZnwlBTpky3vopeRA8434")      # kislay.seal  

model3 = genai.GenerativeModel(
    "gemini-1.5-flash-002",
    generation_config=generation_config,
    system_instruction=[file_contents[file3_path]],
)

# Initialize the chat session with an empty history
chat1 = model1.start_chat(history=[])
chat2 = model2.start_chat(history=[])
chat3 = model3.start_chat(history=[])

# Define directory paths
err_directory = './error_state'
ver_directory = './ver'
src_directory = './src'
mod_directory = './mod'

# List of directories to check
directories = [err_directory, ver_directory, src_directory]

# Create each directory if it does not exist
for directory in directories:
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"Created directory: {directory}")
    else:
        print(f"Directory already exists: {directory}")




# Function to send file contents to chat and save responses
def send_file_contents_to_chat_src(file_path, chat_history, ver_directory):
    with open(file_path, 'r') as file:
        content = file.read()
        
        # Send the user's message
        chat_history.append({'role': 'user', 'content': content})
        response = chat1.send_message(content)
        
        # Append the model's response to the chat history
        chat_history.append({'role': 'assistant', 'content': response.text})
        
        # Print and save the response
        #print(response.text)
        #print(f"========================== Sent contents of {file_path} ==============================")
        
        # Define the response file name
        response_file_name = f"{os.path.basename(file_path)[:-2]}_gen.v"
        
        # Ensure output directory exists
        if not os.path.exists(ver_directory):
            os.makedirs(ver_directory)
        
        # Write the response to the output file
        with open(os.path.join(ver_directory, response_file_name), 'w') as response_file:
            response_file.write(response.text)
        
        #print(f"Response saved to {response_file_name}")
        return content,response.text

# Function to send file contents to chat and save responses
def send_file_contents_to_chat_ver(file_path1,file_path2, chat_history, err_directory):
    with open(file_path1, 'r') as file:
        content1 = file.read()
        
        with open(file_path2, 'r') as file:
            content2 = file.read()

            content = "Original Verilog Code -> " + content1 + "Modified verilog Code ->" + content2

            # Send the user's message
            chat_history.append({'role': 'user', 'content': content})
            response = chat2.send_message(content)
            
            # Append the model's response to the chat history
            chat_history.append({'role': 'assistant', 'content': response.text})
            
            # Print and save the response
            #print(response.text)
            #print(f"========================== Sent contents of {file_path1} ==============================")
            
            # Define the response file name
            response_file_name = f"{os.path.basename(file_path1)[:-2]}_state.txt"
            
            # Ensure output directory exists
            if not os.path.exists(err_directory):
                os.makedirs(err_directory)
            
            # Write the response to the output file
            with open(os.path.join(err_directory, response_file_name), 'w') as response_file:
                response_file.write(response.text)
            return response.text
            
            #print(f"Response saved to {response_file_name}")

# Function to send file contents to chat and save responses
def send_file_contents_to_chat_mod(file_path1,file_path2,file_path3, chat_history, mod_directory):
    with open(file_path1, 'r') as file:
        content1 = file.read()
        
        with open(file_path2, 'r') as file:
            content2 = file.read()

            with open(file_path3, 'r') as file:
                content3 = file.read()
                txt=""
                if "3" in content3:
                    # Define the response file name
                    response_file_name = f"{os.path.basename(file_path2)[:-2]}_mod.v"
                    
                    # Ensure output directory exists
                    if not os.path.exists(mod_directory):
                        os.makedirs(mod_directory)
                    
                    # Write the response to the output file
                    with open(os.path.join(mod_directory, response_file_name), 'w') as response_file:
                        response_file.write(content1)
                    #print("There is no error!")
                    #print(f"Response saved to {response_file_name}")
                    return
                elif "1" in content3:
                    #print("There are some syntax errors!")
                    txt= "There is some syntax error in the modified code, just fix the syntax error and don't change the logic"
                elif "2" in content3:
                    #print("There are some issue with the trojan!")
                    txt= "The trojan implementation in the modified code is wrong, just modfify the code so that the trojan works"
                elif "0" in content3:
                    # Send the user's message
                    chat_history.append({'role': 'user', 'content': content2})
                    response = chat1.send_message(content2)
                    chat_history.append({'role': 'assistant', 'content': response.text})
                    response_file_name = f"{os.path.basename(file_path2)[:-2]}_mod.v"
                
                    # Ensure output directory exists
                    if not os.path.exists(mod_directory):
                        os.makedirs(mod_directory)
                    
                    # Write the response to the output file
                    with open(os.path.join(mod_directory, response_file_name), 'w') as response_file:
                        response_file.write(response.text)
                    
                    return response.text, content3

                content = "Original Verilog Code -> " + content1 + "Modified verilog Code ->" + content2 + "Issue: " + txt

                # Send the user's message
                chat_history.append({'role': 'user', 'content': content})
                response = chat3.send_message(content)
                
                # Append the model's response to the chat history
                chat_history.append({'role': 'assistant', 'content': response.text})
                
                # Print and save the response
                #print(response.text)
                #print(f"========================== Sent contents of {file_path1} ==============================")
                
                # Define the response file name
                response_file_name = f"{os.path.basename(file_path2)[:-2]}_mod.v"
                
                # Ensure output directory exists
                if not os.path.exists(mod_directory):
                    os.makedirs(mod_directory)
                
                # Write the response to the output file
                with open(os.path.join(mod_directory, response_file_name), 'w') as response_file:
                    response_file.write(response.text)
                
                return response.text, content
                #print(f"Response saved to {response_file_name}")

# Initialize Streamlit app
st.set_page_config(page_title="LLM Tool", layout="wide")

# Load custom CSS
with open("style.css") as f:
    st.markdown(f"<style>{f.read()}</style>", unsafe_allow_html=True)

# Load images
left_image_path = "csaw1.png"
right_image_path = "kgp.png"

# Display images and header in full-width columns
col1, col2, col3 = st.columns([1, 7, 1])

with col1:
    left_image = Image.open(left_image_path)
    # Set custom dimensions for images
    image_width = 250  # Adjust width as needed
    image_height = 250  # Adjust height as needed
    st.image(left_image, width=image_width, use_container_width=False)

with col2:
    st.markdown("<h1 style='text-align: center;'>SEAL's Hardware Trojan Insertion Tool</h1>", unsafe_allow_html=True)

with col3:
    right_image = Image.open(right_image_path)
    # Set custom dimensions for images
    image_width = 150  # Adjust width as needed
    image_height = 150  # Adjust height as needed
    st.image(right_image, width=image_width, use_container_width=False)

# Initialize session state for chat history if it doesn't exist
if 'chat_history' not in st.session_state:
    st.session_state['chat_history'] = []

# Iterate through all .v files in the specified directory
chat_history = []

# Chat box taking 75% of the width
chat_container = st.container()
with chat_container:
    # Get user input and submit response
    #user_input = st.text_area("Input: ", key="input", height=100) 
    submit = st.button("Generate")
    clear = st.button("Clear")
    # Execute `make clean` if "Clear" button is clicked
    if clear:
        subprocess.run(["make", "clean"])
    
    if submit:
        for filename in os.listdir(src_directory):
            if filename.endswith('.v'):
                file_path1 = os.path.join(src_directory, filename)
        content,response = send_file_contents_to_chat_src(file_path1, chat_history, ver_directory)
        for filename in os.listdir(ver_directory):
            if filename.endswith('.v'):
                file_path2 = os.path.join(ver_directory, filename)
        response_state =  send_file_contents_to_chat_ver(file_path1,file_path2, chat_history, err_directory)
        if response:
            # Add user query and response to session state chat history
            st.session_state['chat_history'].append(("Original Code", content))
            st.subheader("LLM Response")
            # Convert response text to a single string if it's in chunks
            #response_text = "".join([chunk.text for chunk in response])
            
            # Displaying the response in a styled code box with syntax highlighting
            st.code(response, language='verilog')  # Change 'verilog' to the appropriate language if needed
            st.session_state['chat_history'].append(("Trojan Inserted Intermediate Code", response))
            res,cont="",""
            # Displaying the response in a styled code box with syntax highlighting
            if "3" in response_state:
                state_txt="No Errors found in the generated response!"
            elif "1" in response_state:
                state_txt="There are some syntax error in the generated response!"
                for filename in os.listdir(err_directory):
                    if filename.endswith('.txt'):
                        file_path3 = os.path.join(err_directory, filename)
                res,cont = send_file_contents_to_chat_mod(file_path1,file_path2,file_path3, chat_history, mod_directory)
            elif "2" in response_state:
                state_txt="There are some issues with the trojan in the generated response!"
                for filename in os.listdir(err_directory):
                    if filename.endswith('.txt'):
                        file_path3 = os.path.join(err_directory, filename)
                res,cont = send_file_contents_to_chat_mod(file_path1,file_path2,file_path3, chat_history, mod_directory)
            elif "0" in response_state:
                state_txt="Have to generate the response again!"
                for filename in os.listdir(err_directory):
                    if filename.endswith('.txt'):
                        file_path3 = os.path.join(err_directory, filename)
                res,cont = send_file_contents_to_chat_mod(file_path1,file_path2,file_path3, chat_history, mod_directory)

            st.session_state['chat_history'].append(("Issue in the generated code", state_txt))
            if "3" in response_state:
                st.session_state['chat_history'].append(("Final trojan Inserted Code is ", response))
            else:
                st.session_state['chat_history'].append(("Final trojan Inserted Code is ", res))
    
    # Display chat history with syntax-highlighted code boxes
    st.subheader("Chat History")
    for role, text in st.session_state['chat_history']:
        st.markdown(f"**{role}:**")  # Display the role as bold text
        st.code(text, language='verilog')  # Display the message in a syntax-highlighted code box

    
    # Close chat container div
    st.markdown("</div>", unsafe_allow_html=True)

