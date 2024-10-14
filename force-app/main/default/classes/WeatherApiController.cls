public with sharing class WeatherApiController{
    
    @AuraEnabled
    public static WeatherModel fetchWeather(Id recordId){
        return WeatherApiService.fetchWeather(recordId);
    }
}