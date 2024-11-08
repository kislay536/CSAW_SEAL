from PIL import Image
import streamlit as st
import os
import google.generativeai as genai

# Configure the Generative AI model with the API key
genai.configure(api_key="AIzaSyDH_cpqO4fMMmitR4bbBKtl64qsnHgOF24")

# Create the model configuration
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

# Get system instruction file path from environment variable
sys_inst_file = os.getenv("SYS_INST_FILE")

if not sys_inst_file:
    st.error("System instruction file path not set. Please specify SYS_INST_FILE.")
    st.stop()

# Read the contents of the specified system instruction file
with open(sys_inst_file, 'r', encoding='utf-8') as file:
    system_instruction = file.read()


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
        st.error(f"Failed to get response: {str(e)}")
        return None

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

# Chat box taking 75% of the width
chat_container = st.container()
with chat_container:
    # Get user input and submit response
    user_input = st.text_area("Input: ", key="input", height=100) 
    submit = st.button("Ask the question")
    
    if submit and user_input:
        response = get_gemini_response(user_input)
        if response:
            # Add user query and response to session state chat history
            st.session_state['chat_history'].append(("You", user_input))
            st.subheader("The Response is")
            # Convert response text to a single string if it's in chunks
            response_text = "".join([chunk.text for chunk in response])
            
            # Displaying the response in a styled code box with syntax highlighting
            st.code(response_text, language='verilog')  # Change 'verilog' to the appropriate language if needed
            st.session_state['chat_history'].append(("Bot", response_text))
    
    # Display chat history with syntax-highlighted code boxes
    st.subheader("The Chat History is")
    for role, text in st.session_state['chat_history']:
        st.markdown(f"**{role}:**")  # Display the role as bold text
        st.code(text, language='verilog')  # Display the message in a syntax-highlighted code box

    
    # Close chat container div
    st.markdown("</div>", unsafe_allow_html=True)
