public class CalloutUtility{
    //performs the callout in future
    @future(callout=true)
    public static void processCalloutToPython(String requestBody,String endPointUrl){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
    }    
}