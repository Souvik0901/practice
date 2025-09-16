public with sharing class MyHttpCalloutClass {

    public static String makeCallout() {
        Http http = new Http();                              // http instance
        HttpRequest request = new HttpRequest();                 // request instance
        request.setEndpoint('https://thirdpartyapi.com/data');  //endpoint define
        request.setMethod('GET');                              // method define
        
        HttpResponse response = http.send(request);        // we got the response here
        
        return response.getBody();                    //we will return the reponse body.
    }
}


//Actual Callout Class
-----------------------------------------------------------

//Incase of writing test class for any third party’s HTTP API callouts, creates a mock response with annotation @isTest and use
//test.SetMock() method in your test class. Example of a Mock response-

@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake HTTP Response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success","message":"Mock response received"}');
        res.setStatusCode(200);
        return res;
    }
}



------------------------------------------------------------

Now, before calling the actual class the test class use Test.setMock method as shown below in the same test class as shown below-
@isTest
private class MyCalloutTest {
    @isTest static void testCallout() {
        // Set the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Start test context
        Test.startTest();
        
        // Call the method that makes the HTTP callout
        String response = MyHttpCalloutClass.makeCallout();
        
        // Stop test context
        Test.stopTest();

        // Verify the response is what you mocked
        System.assert(response.contains('Mock response received'));
    }
}
----------------------------------------------------------------------


