@isTest
public with sharing class WeatherApiControllerTest {
    @IsTest
    static void testFetchWeather() {
        // Create a test Location__c record
        Location__c testLocation = new Location__c(
            Name = 'Test Location',
            Coordinates__Latitude__s = 37.7749,
            Coordinates__Longitude__s = -122.4194
        );
        insert testLocation;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Call the fetchWeather method
        Test.startTest();
        WeatherModel result = WeatherApiController.fetchWeather(testLocation.Id);
        Test.stopTest();

        // Verify the result
        Assert.areEqual('San Francisco', result.name, 'Expected San Francisco but received'+result.name);
        Assert.isTrue(result.weather.size() > 0, 'No weather data was returned');
        Assert.areEqual('clear sky', result.weather[0].description);
        Assert.areEqual('01d', result.weather[0].icon);
        Assert.areEqual(280.32, result.main.temp);
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