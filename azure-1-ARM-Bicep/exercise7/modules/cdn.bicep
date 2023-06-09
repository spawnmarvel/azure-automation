@description('The hostname address of the origin server')
param originHostName string

@description('The name of CND profile')
param profileName string = 'cnd-${uniqueString(resourceGroup().id)}'

@description('The name of the CND enpoint')
param endpointName string = 'endpoint-${uniqueString(resourceGroup().id)}'

@description('Indicates wheter the CDN endpoint requires HTTPS connections')
param httpsOnly bool

var originName = 'my-origin'

resource cdnProfile 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: profileName
  location: 'global'
  sku: {
    name:'Standard_Microsoft'
  }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2022-11-01-preview' = {
  parent:cdnProfile
  name:endpointName
  location:'global'
  properties: {
    originHostHeader:originHostName
    isHttpAllowed:!httpsOnly
    isHttpsAllowed:true
    queryStringCachingBehavior:'IgnoreQueryString'
    contentTypesToCompress:[
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
    ]
    isCompressionEnabled:true
    origins:[
      {
        name:originName
        properties:{
          hostName:originHostName
        }
      }
    ]
  }
}

@description('The host name of the CND endpoint')
output endpointHostName string = endpoint.properties.hostName
