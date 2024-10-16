@isTest
public class LocationQueryServiceTest {
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
        Location__c result = LocationQueryService.getGeolocation(testLocation.Id);
        Test.stopTest();

        // Verify the result
        Assert.areEqual('Test Location', testLocation.Name);
        Assert.isTrue(result != null, 'Location is null');
        Assert.areEqual(37.7749, result.Coordinates__Latitude__s, 'Latitude is expected to be the same');
        
    }
}