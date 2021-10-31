param resource_group string
param location string
param invest_amount string
param invest_symbol string
param order_threshold string
param gemini_api_key string
param order_schedule string
@secure()
param gemini_api_secret string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resource_group}-RG'
  location: location
}

module function 'modules/functions.bicep'={
  name: 'azurefunctions'
  scope: rg
  params:{
    invest_symbol: invest_symbol
    invest_amount: invest_amount
    order_threshold: order_threshold
    order_schedule: order_schedule
    gemini_api_key: gemini_api_key
    gemini_api_secret: gemini_api_secret
  }
}
