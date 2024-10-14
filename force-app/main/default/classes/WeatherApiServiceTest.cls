@IsTest
public class WeatherApiServiceTest {
    @IsTest
    static void testFetchWeather() {
        // Create a test Location__c record
        Location__c testLocation = new Location__c(
            Name = 'Test Location',
            Coordinates__Latitude__s = 37.7749,
            Coordinates__Longitude__s = -122.4194
        );
        insert testLocation;

        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Call the fetchWeather method
        Test.startTest();
        WeatherModel result = WeatherApiService.fetchWeather(testLocation.Id);
        Test.stopTest();

        // Verify the result
        Assert.areEqual('San Francisco', result.name, 'Expected San Francisco but received'+result.name);
        Assert.areEqual('clear sky', result.weather[0].description);
        Assert.areEqual('01d', result.weather[0].icon);
        Assert.areEqual(280.32, result.main.temp);
    }

    @IsTest
    static void testGetGeolocation() {
        // Create a test Location__c record
        Location__c testLocation = new Location__c(
            Name = 'Test Location',
            Coordinates__Latitude__s = 37.7749,
            Coordinates__Longitude__s = -122.4194
        );
        insert testLocation;

        // Call the getGeolocation method
        Test.startTest();
        Location__c result = WeatherApiService.getGeolocation(testLocation.Id);
        Test.stopTest();

        // Verify the result
        Assert.areEqual(testLocation.Id, result.Id);
        Assert.areEqual(testLocation.Name, result.Name);
        Assert.areEqual(testLocation.Coordinates__Latitude__s, result.Coordinates__Latitude__s);
        Assert.areEqual(testLocation.Coordinates__Longitude__s, result.Coordinates__Longitude__s);
    }

    @IsTest
    static void testGetWeatherApiSetting() {
        // Create a test WeatherApiSetting__c custom setting record
        WeatherApiSetting__c testSetting = new WeatherApiSetting__c(
            Name = 'Test Setting',
            Endpoint__c = 'http://api.example.com',
            API_Key__c = 'TEST_API_KEY'
        );
        insert testSetting;

        // Call the getWeatherApiSetting method
        Test.startTest();
        WeatherApiSetting__c result = WeatherApiService.getWeatherApiSetting();
        Test.stopTest();

        // Verify the result
        Assert.areEqual(testSetting.Name, result.Name);
        Assert.areEqual(testSetting.Endpoint__c, result.Endpoint__c);
        Assert.areEqual(testSetting.API_Key__c, result.API_Key__c);
    }

    public class MockHttpResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"name":"San Francisco","weather":[{"description":"clear sky","icon":"01d"}],"main":{"temp":280.32}}');
            response.setStatusCode(200);
            return response;
        }
    }
}
