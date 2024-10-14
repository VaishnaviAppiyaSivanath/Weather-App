public inherited sharing class WeatherApiService {
   
    
    public static WeatherModel fetchWeather(Id recordId) {
        
        Location__c location = getGeolocation(recordId);
        Decimal latitude = location.Coordinates__Latitude__s;
        Decimal longitude = location.Coordinates__Longitude__s;
        // Get the API endpoint from the custom setting
        WeatherApiSetting__c setting = getWeatherApiSetting();
        // Construct the endpoint using the geolocation coordinates
        String endpoint = setting.Endpoint__c+'lat=' + latitude + '&lon=' + longitude + '&appid=' + setting.API_Key__c + '&units=metric';
        // Make the callout to the API and parse the response
        HttpResponse response = makeCallout(endpoint);
        WeatherModel result = WeatherModel.parse(response.getBody());
        System.debug(result);
        return result;
    }

    public static Location__c getGeolocation(Id recordId) {
        // Get the location record for the provided Id
        return [SELECT Id, Name, Coordinates__Latitude__s, Coordinates__Longitude__s FROM Location__c WHERE Id =: recordId WITH USER_MODE];
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

