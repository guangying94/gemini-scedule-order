import datetime
import logging
import requests
import json
import base64
import hmac
import hashlib
import datetime, time
import os

import azure.functions as func


def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)

    ## user input
    symbol = os.environ["SYMBOL"]
    amount = float(os.environ["AMOUNT"])
    percent = float(os.environ["PERCENT"])
    gemini_api_key = os.environ["API_KEY"]
    gemini_api_secret = os.environ["API_SECRET"].encode()

    logging.info('Accessed environment variables')

    ## Define URL
    base_url = "https://api.gemini.com"
    endpoint = "/v1/order/new"
    url = base_url + endpoint
    quote_endpoint = "/v2/ticker/" + symbol

    ## Get current quote and amount
    current_ticker = requests.get(base_url + quote_endpoint).json()
    current_price = float(current_ticker['ask'])

    ## Set order amount
    order_price = current_price * percent
    order_unit = amount/order_price

    logging.info('Order Price: %f and Order Unit: %f' % (order_price, order_unit))

    t = datetime.datetime.now()
    payload_nonce =  str(int(time.mktime(t.timetuple())*1000))

    payload = {
    "request": "/v1/order/new",
        "nonce": payload_nonce,
        "symbol": symbol,
        "amount": str(round(order_unit,8)),
        "price": str(round(order_price,2)),
        "side": "buy",
        "type": "exchange limit"
    }

    logging.info(payload)

    encoded_payload = json.dumps(payload).encode()
    b64 = base64.b64encode(encoded_payload)
    signature = hmac.new(gemini_api_secret, b64, hashlib.sha384).hexdigest()

    logging.info('encoded')

    request_headers = { 'Content-Type': "text/plain",
                        'Content-Length': "0",
                        'X-GEMINI-APIKEY': gemini_api_key,
                        'X-GEMINI-PAYLOAD': b64,
                        'X-GEMINI-SIGNATURE': signature,
                        'Cache-Control': "no-cache" }

    response = requests.post(url,
                            data=None,
                            headers=request_headers)

    new_order = response.json()
    logging.info(new_order)

    logging.info('Function completed at %s', utc_timestamp)

