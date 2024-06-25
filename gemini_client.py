import os
from dotenv import load_dotenv
import google.generativeai as genai

# Load the environment variables from .env file
load_dotenv()

# Initialize the Google Generative AI API with the API key
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))

model = genai.GenerativeModel('gemini-1.5-flash')

def get_gemini_response(chat_history):
    """
    Get response from Gemini API based on the chat history.
    
    :param chat_history: List of chat messages, each message is a list [user_message, gemini_response]
    :return: Updated chat history with Gemini's response added
    """
    user_message = chat_history[-1][0]
    formatted_history = [{"role": "user", "content": msg[0]} if msg[1] is None else {"role": "assistant", "content": msg[1]} for msg in chat_history[:-1]]
    
    prompt = "\n".join([f"{msg['role']}: {msg['content']}" for msg in formatted_history] + [f"user: {user_message}"])
    
    response = model.generate_content(prompt)
    gemini_response = response.text.strip()
    chat_history[-1][1] = gemini_response
    return chat_history
