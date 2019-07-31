@RestResource(urlMapping='/predictionService/*')
global class PredictionService{
    @HttpPost
    global static void postValue(String predStatus){
        DelphiCalloutBatchForPredictionSalesRep d=new DelphiCalloutBatchForPredictionSalesRep('https://delphi-testing.herokuapp.com/predictSalesRep');
        Database.executeBatch(d);
    }
}