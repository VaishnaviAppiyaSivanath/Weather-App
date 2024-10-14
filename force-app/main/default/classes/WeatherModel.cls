public with sharing class WeatherModel {
    
    public WeatherModel() {}

    @AuraEnabled public list<weather> weather{get;set;}
    @AuraEnabled public main main{get;set;}
    @AuraEnabled public String name{get;set;}
    public class weather{
		@AuraEnabled public String description{get;set;}
		@AuraEnabled public String main{get;set;}
		@AuraEnabled public String icon{get;set;}
		@AuraEnabled public Integer id{get;set;}
	}
    public class main{
		@AuraEnabled public Integer sea_level{get;set;}
		@AuraEnabled public Decimal temp_max{get;set;}
		@AuraEnabled public Integer pressure{get;set;}
		@AuraEnabled public Decimal temp_min{get;set;}
		@AuraEnabled public Integer humidity{get;set;}
		@AuraEnabled public Decimal feels_like{get;set;}
		@AuraEnabled public Integer grnd_level{get;set;}
		@AuraEnabled public Decimal temp{get;set;}
	}

    public static WeatherModel parse(String json) {
        return (WeatherModel) System.JSON.deserialize(json, WeatherModel.class);
    }
}