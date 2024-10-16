public with sharing class WeatherApiController{
    
    @AuraEnabled(cacheable=true)
    public static WeatherModel fetchWeather(Id recordId){
        return WeatherApiService.fetchWeather(recordId);
    }
}