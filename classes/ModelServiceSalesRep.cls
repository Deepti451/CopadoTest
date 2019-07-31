@RestResource(urlMapping='/modelServiceSalesRep/*')
global class ModelServiceSalesRep {
	@HttpPost
    global static void postValue(String modelStatus){
        Delphi_Configuration__c configRecord=[SELECT Id,Model_Status__c,RFE_Fields__c,Last_Model_Run__c FROM Delphi_Configuration__c  LIMIT 1];
        configRecord.Model_Status__c=modelStatus.trim();
        configRecord.Last_Model_Run__c =System.now();
        update configRecord;
        System.debug(modelStatus);
        DelphiEmailUtility.PostModelCreationEmail();
    }
}