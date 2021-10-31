param invest_amount string
param invest_symbol string
param order_threshold string
param gemini_api_key string
param order_schedule string
@secure()
param gemini_api_secret string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01'={
  name: uniqueString(resourceGroup().id)
  location: resourceGroup().location
  kind: 'StorageV2'
  sku:{
    name: 'Standard_LRS'
  }
}

resource functionApp 'Microsoft.Web/sites@2021-02-01'={
  name: '${invest_symbol}-${uniqueString(resourceGroup().id)}-function'
  location: resourceGroup().location
  kind: 'functionapp,linux'
  properties:{
    httpsOnly: true
    reserved: true
    siteConfig:{
      appSettings:[
        {
          'name': 'AMOUNT'
          'value': invest_amount
        }
        {
          'name': 'API_KEY'
          'value': gemini_api_key
        }
        {
          'name': 'API_SECRET'
          'value': gemini_api_secret
        }
        {
          'name': 'PERCENT'
          'value': order_threshold
        }
        {
          'name': 'SYMBOL'
          'value': invest_symbol
        }
        {
          'name': 'TIMER_SCHEDULE'
          'value': order_schedule
        }
        {
          'name': 'WEBSITE_RUN_FROM_PACKAGE'
          'value': 'https://storageaccountperso8f5b.blob.core.windows.net/code/timer.zip'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'python'
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'AzureWebJobsStorage'
          'value': 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id,storageAccount.apiVersion).keys[0].value}'
        }
      ]
    }
  }
}
