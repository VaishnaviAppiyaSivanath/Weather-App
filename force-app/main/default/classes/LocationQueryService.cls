public inherited sharing class LocationQueryService {
    public static Location__c getGeolocation(Id recordId) {
        // Get the location record for the provided Id
        return [SELECT Id, Name, Coordinates__Latitude__s, Coordinates__Longitude__s FROM Location__c WHERE Id =: recordId WITH USER_MODE];
    }
}