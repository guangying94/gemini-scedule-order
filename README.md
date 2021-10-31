# Scehdule Order - Gemini API
This repository uses Gemini API and Azure Functions to periodically place order on crypto currency.

The code is meant to be deployed in [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview), a serverless cloud computing service provided by [Azure](https://azure.microsoft.com/en-us/).

The code is implemented based on [Gemini API](https://docs.gemini.com/rest-api/).

## How to deploy
1. Obtain an Azure Account. You can either use existing valid Azure account, or get a free [Azure Account](https://azure.microsoft.com/en-us/free/).

| :point_up:    | We are deploying Azure Functions, which is covered under "Always Free" tier within 1 million transactions. |
|---------------|:------------------------|

| :memo:    | An Azure Storage Account is needed to store state, the cost should be minimal (< $0.05 a month). |
|---------------|:------------------------|

2. Prepare the following information.
- Gemini API Key (Create this in Gemini, select **Account** instead of master)
- Gemini API Secret
- Desired frequency under cron format (including seconds, example: * */5 * * * *). Tools: [Crontabkit](https://crontabkit.com/)

3. Deploy Azure Resource Manager Template

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fguangying94%2Fgemini-scedule-order%2Fmain%2Fazure-infra-code%2Fmain.json)

Parameters required:
- resource_group: Azure Resource Group Name
- location: Azure Resource Group Location
- invest_amount: order amount, currency follows indicated symbol. Example: 10, Symbol is btcusd, which means this order is 10USD to purchase BTC.
- invest_symbol: Order pair, see Gemini for supported pair. Example: btcusd, this is to purchase BTC using USD.
- order_threshold: Multiplier for order amount. Example: 0.99, means placing a order at 0.99 * current price
- gemini_api_key: Gemini API Key created above
- gemini_api_secret: Gemini secret created above
- order_schedule: Cron representation created above

4. Deposit Fiat money in Gemini and let Azure Functions do the work for you!

## Why do I create this?
Gemini allows user to place order using their web portal, but the charges is very high - details [here](https://www.gemini.com/fees/web-fee-schedule), compare to either using "ActiveTrader" mode, or using API, which brings down the fees to 0.35% - details [here](https://www.gemini.com/fees/api-fee-schedule#section-api-fee-schedule).

Gemini supports regular purchase as well, but it applies Web Fees ( > $0.99 per order), hence I created this automation, which brings down the fees significantly.

If you haven't open a Gemini account, you can consider to use my [referral](https://www.gemini.com/share/keq5wgeur) to open an account.

Or, you can [buy me a coffee](buymeacoffee.com/marcustee) if the instruction above helps!

## References
[Azure Functions - Python Developer Guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python?tabs=azurecli-linux%2Capplication-level)