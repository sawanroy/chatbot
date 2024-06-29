import gradio as gr
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

def main():
    """
    Main function to create the Gradio interface and handle the chat interactions.
    """
    with gr.Blocks() as demo:
        chatbot = gr.Chatbot()
        msg = gr.Textbox(placeholder="Type your message here...")
        clear = gr.Button("Clear")

        msg.submit(handle_user_query, [chatbot, msg], chatbot).then(
            get_gemini_response, chatbot, chatbot
        )
        clear.click(lambda: [], None, chatbot)

    demo.queue().launch()
    app = gr.mount_gradio_app(app, demo, path="/gradio")
if __name__ == "__main__":
    main()
