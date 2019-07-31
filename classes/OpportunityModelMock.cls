@isTest
global class OpportunityModelMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('Delphi-Mock');
        res.setStatusCode(200);
        return res;
    }
}