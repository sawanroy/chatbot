import requests
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv('GEMINI_API_KEY')
url = 'https://api.gemini.com/v1/pubticker/btcusd'
headers = {'X-GEMINI-APIKEY': api_key}

try:
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    print('API key is valid.')
except requests.exceptions.RequestException as e:
    print(f'Error occurred during API key check: {e}')
except Exception as e:
    print(f'API key is invalid: {e}')
