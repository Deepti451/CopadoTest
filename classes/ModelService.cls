@RestResource(urlMapping='/modelService/*')
global class ModelService{
    @HttpPost
    global static void postValue(String modelStatus,String oppFieldsAfterRfe){
        System.debug(modelStatus);
        Delphi_Configuration__c configRecord=[SELECT Id,Model_Status__c,RFE_Fields__c,Last_Model_Run__c FROM Delphi_Configuration__c  LIMIT 1];
        configRecord.RFE_Fields__c=oppFieldsAfterRfe;
        update configRecord;
        System.debug(oppFieldsAfterRfe);
        DelphiCalloutBatchForTrainingSalesRep dcObj=new DelphiCalloutBatchForTrainingSalesRep('https://delphi-testing.herokuapp.com/FitModelSalesRep');
        Database.executeBatch(dcObj,1000);
    }
}