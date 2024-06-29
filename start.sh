#!/bin/bash
source venv/bin/activate
uvicorn gradio_ui:app --host 0.0.0.0 --port $PORT
