public inherited sharing class WeatherApiService {
   
    
    public static WeatherModel fetchWeather(Id recordId) {
        
        Location__c location = LocationQueryService.getGeolocation(recordId);
        if(location == null) {
            throw new WeatherApiException('Couldn\'t retrieve the location of this record.');
        }
        
        Decimal latitude = location.Coordinates__Latitude__s;
        Decimal longitude = location.Coordinates__Longitude__s;
        // Get the API endpoint from the custom setting
        WeatherApiSetting__c setting = getWeatherApiSetting();
        // Construct the endpoint using the geolocation coordinates
        String endpoint = setting.Endpoint__c+'lat=' + latitude + '&lon=' + longitude + '&appid=' + setting.API_Key__c + '&units=metric';
        // Make the callout to the API and parse the response
        WeatherModel result;
        try {
            HttpResponse response = makeCallout(endpoint);
            result = WeatherModel.parse(response.getBody());
        } catch (Exception e) {
            //TODO : Logging Framework
            throw new WeatherApiException('Couldn\'t retrieve the weather information from the weather API');
        }
        
        
        return result;
    }

    public static WeatherApiSetting__c getWeatherApiSetting() {
        // Query the WeatherApiSetting__c custom setting to get the API key and endpoint
        WeatherApiSetting__c setting = WeatherApiSetting__c.getOrgDefaults();
        if (setting!= null) {
            return setting;
        } else {
            throw new WeatherApiException('Weather API setting not found');
        }
    }

    public static HttpResponse makeCallout(String endpoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }

    public class WeatherApiException extends Exception{}
    
}

