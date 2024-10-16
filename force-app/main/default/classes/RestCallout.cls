public with sharing class RestCallout {
    
    public enum HttpMethod {
        GET
    }

    public static HttpResponse makeCallout(String endpoint, HTTPMethod method) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method.name());
        HttpResponse response = http.send(request);
        return response;
    }
}