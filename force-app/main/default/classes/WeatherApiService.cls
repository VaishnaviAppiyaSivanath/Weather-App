public inherited sharing class WeatherApiService {
   
    
    public static WeatherModel fetchWeather(Id recordId) {
        
        Location__c location = LocationQueryService.getGeolocation(recordId);
        if(location == null) {
            throw new WeatherApiException('Couldn\'t retrieve the location of this record.');
        }
        String endpoint = constructEndpoint(location);
        try {
            return makeWeatherApiCallout(endpoint);
        } catch (Exception e) {
            //TODO : Log the errors
            throw new WeatherApiException(e.getMessage());
        }
    }

    public static String constructEndpoint(Location__c location) {
        Decimal latitude = location.Coordinates__Latitude__s;
        Decimal longitude = location.Coordinates__Longitude__s;
        // Get the API endpoint from the custom setting
        WeatherApiSetting__c setting = getWeatherApiSetting();
        String endpoint = setting.Endpoint__c+'lat=' + latitude + '&lon=' + longitude + '&appid=' + setting.API_Key__c + '&units=metric';
        return endpoint;
    }

    public static WeatherApiSetting__c getWeatherApiSetting() {
        // Query the WeatherApiSetting__c custom setting to get the API key and endpoint
        WeatherApiSetting__c setting = WeatherApiSetting__c.getOrgDefaults();
        if (String.isNotBlank(setting.API_Key__c ) && String.isNotBlank(setting.Endpoint__c)) {
            return setting;
        } else {
            throw new WeatherApiException('Weather API setting not found');
        }
    }

    public static WeatherModel makeWeatherApiCallout(String endpoint) {
        HttpResponse response = RestCallout.makeCallout(endpoint, RestCallout.HttpMethod.GET);
        Integer statusCode = response.getStatusCode();
        // Check if the status code is in the 2xx range (success)
        if(statusCode >= 200 && statusCode < 300) {
            return WeatherModel.parse(response.getBody());
        } else if(statusCode == 500) {
            // TODO: Retry API call
            throw new WeatherApiException('Error retrieving weather information: API Server issue');
        }
        else {
            //TODO: To handle different status code and throw custom exceptions
            throw new WeatherApiException('Error retrieving weather information: Error '+response.getStatusCode());
        }
    }

    public class WeatherApiException extends Exception{}
    
}

