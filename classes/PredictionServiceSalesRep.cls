@RestResource(urlMapping='/predictionServiceSalesRep/*')
global class PredictionServiceSalesRep{
    @HttpPost
    global static void postValue(String predStatus){
        System.debug(predStatus);
        Delphi_Configuration__c configRecord=[SELECT Id,Prediction_Status__c,Last_Prediction_Run__c FROM Delphi_Configuration__c  LIMIT 1];
        configRecord.Prediction_Status__c=predStatus.trim();
        configRecord.Last_Prediction_Run__c =System.now();
        configRecord.Time_Prediction_Status__c='Running';
        update configRecord;  
        TimePredictionTrainingBatch t=new TimePredictionTrainingBatch();
        Database.executeBatch(t,1000);
        //DelphiEmailUtility.PostPredictionEmail();
    }
}