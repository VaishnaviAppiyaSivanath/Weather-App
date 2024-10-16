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

        // Create a test WeatherApiSetting__c custom setting record
        WeatherApiSetting__c testSetting = new WeatherApiSetting__c(
            Name = 'Test Setting',
            Endpoint__c = 'http://api.example.com',
            API_Key__c = 'TEST_API_KEY'
        );
        insert testSetting;

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

    @IsTest
    static void testNoWeatherApiSetting() {

        // Call the getWeatherApiSetting method
    
        try {
            Test.startTest();
            WeatherApiSetting__c result = WeatherApiService.getWeatherApiSetting();
            Test.stopTest();
        } catch (Exception e) {
            //TODO : Log the errors
            Assert.isTrue(e.getMessage().contains('Weather API setting not found'));
        }
    }

    @IsTest
    static void testInternalServerError() {
        // Create a test Location__c record
        Location__c testLocation = new Location__c(
            Name = 'Test Location',
            Coordinates__Latitude__s = 37.7749,
            Coordinates__Longitude__s = -122.4194
        );
        insert testLocation;

        // Create a test WeatherApiSetting__c custom setting record
        WeatherApiSetting__c testSetting = new WeatherApiSetting__c(
            Name = 'Test Setting',
            Endpoint__c = 'http://api.example.com',
            API_Key__c = 'TEST_API_KEY'
        );
        insert testSetting;

        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse500());

        // Call the fetchWeather method
        
        try {
            Test.startTest();
            WeatherModel result = WeatherApiService.fetchWeather(testLocation.Id);
            Test.stopTest();
        } catch (Exception e) {
            //TODO : Log the errors
            Assert.isTrue(e.getMessage().contains('Error retrieving weather information: API Server issue'));
        }
        
    }

    @IsTest
    static void testBadRequest() {
        // Create a test Location__c record
        Location__c testLocation = new Location__c(
            Name = 'Test Location',
            Coordinates__Latitude__s = 37.7749,
            Coordinates__Longitude__s = -122.4194
        );
        insert testLocation;

        // Create a test WeatherApiSetting__c custom setting record
        WeatherApiSetting__c testSetting = new WeatherApiSetting__c(
            Name = 'Test Setting',
            Endpoint__c = 'http://api.example.com',
            API_Key__c = 'TEST_API_KEY'
        );
        insert testSetting;

        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse400());

        // Call the fetchWeather method
        
        try {
            Test.startTest();
            WeatherModel result = WeatherApiService.fetchWeather(testLocation.Id);
            Test.stopTest();
        } catch (Exception e) {
            //TODO : Log the errors
            Assert.isTrue(e.getMessage().contains('Error retrieving weather information: Error 400'));
        }
            
    }

    @isTest
    static void testWithNoLocation() {
        try {
            Test.startTest();
            WeatherModel result = WeatherApiService.fetchWeather('001000000FAKEID');
            Test.stopTest();
        }catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Couldn\'t retrieve the location of this record.'));
        }
        
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

    // Implementing HttpCalloutMock to mock a 400 response
    public class MockHttpResponse400 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('{"error": "Bad Request"}');
            return res;
        }
    }

    // Implementing HttpCalloutMock to mock a 500 response
    public class MockHttpResponse500 implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
            return res;
        }
    }
}
