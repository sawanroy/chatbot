import gradio as gr
from fastapi import FastAPI
from gemini_client import get_gemini_response

def handle_user_query(chat_history, user_message):
    """
    Handle user query by appending it to the chat history.
    
    :param chat_history: List of chat messages
    :param user_message: The message sent by the user
    :return: Updated chat history
    """
    chat_history.append([user_message, None])
    return chat_history

def create_app():
    """
    Create the FastAPI app and Gradio interface.
    
    :return: The FastAPI app instance
    """
    with gr.Blocks() as demo:
        chatbot = gr.Chatbot()
        msg = gr.Textbox(placeholder="Type your message here...")
        clear = gr.Button("Clear")

        msg.submit(handle_user_query, [chatbot, msg], chatbot).then(
            get_gemini_response, chatbot, chatbot
        )
        clear.click(lambda: [], None, chatbot)

    app = FastAPI()
    app = gr.mount_gradio_app(app, demo, path="/gradio")
    return app

app = create_app()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)