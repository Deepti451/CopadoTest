@isTest
public class DelphiServicesTest{
	@testSetup
    static void setupTestData(){
        Delphi_Configuration__c delphi=new Delphi_Configuration__c(Name='Delphi',Configuration_Type__c='Manual',Prediction_Status__c='Failure',RFE_Fields__c='Name,StageName,AccountId,NextStep,TotalOpportunityQuantity',Selected_Field_Account__c='Name,Industry',Selected_Field_User__c='Name,UserName');
        insert delphi;
    }
    
    @isTest
    static void testCaseOne(){
        ModelService.postValue('Success', 'Name,StageName');
        Delphi_Configuration__c delphi=[SELECT RFE_Fields__c FROM Delphi_Configuration__c LIMIT 1];
    	System.assertEquals('Name,StageName',delphi.RFE_Fields__c);
    }
    
    @isTest
    static void testCaseTwo(){
        ModelServiceSalesRep.postValue('Success');
        Delphi_Configuration__c delphi=[SELECT Model_Status__c FROM Delphi_Configuration__c LIMIT 1];
        System.assertEquals('Success',delphi.Model_Status__c);
    }
    
    @isTest
    static void testCaseThree(){
        PredictionService.postValue('Success');
    	Delphi_Configuration__c delphi=[SELECT Prediction_Status__c FROM Delphi_Configuration__c LIMIT 1];
        System.assertEquals('Failure',delphi.Prediction_Status__c);
    }
    
    @isTest
    static void testCaseFour(){
        PredictionServiceSalesRep.postValue('Success');
        Delphi_Configuration__c delphi=[SELECT Prediction_Status__c FROM Delphi_Configuration__c LIMIT 1];
        System.assertEquals('Success',delphi.Prediction_Status__c);
    }
}