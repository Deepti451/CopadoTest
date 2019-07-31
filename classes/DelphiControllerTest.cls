@isTest
public class DelphiControllerTest{
    @testSetup
    static void setupTestData(){
        List<Account> accToInsert=new List<Account>();
        accToInsert.add(new Account(name='Global Account'));
        accToInsert.add(new Account(name='Local Account'));
        insert accToInsert;
        List<Opportunity> oppToInsert=new List<Opportunity>();
        for(Integer i=1;i<=10;i++){
            if(Math.mod(i,2)==0)
                oppToInsert.add(new Opportunity(Name='Global Closed Opp',AccountId=accToInsert[0].Id,StageName='Closed Won',CloseDate=System.today()));
            else
                oppToInsert.add(new Opportunity(Name='Local Closed Opp',AccountId=accToInsert[1].Id,StageName='Closed Won',CloseDate=System.today()));
        }
        for(Integer i=1;i<=6;i++){
            if(Math.mod(i,2)==0)
                oppToInsert.add(new Opportunity(Name='Global Open Opp',AccountId=accToInsert[0].Id,StageName='Prospecting',CloseDate=System.today().addDays(2)));
            else
                oppToInsert.add(new Opportunity(Name='Local Open Opp',AccountId=accToInsert[1].Id,StageName='Prospecting',CloseDate=System.today().addDays(2)));
        }
        insert oppToInsert;
    }
    
    @isTest
    static void testCaseOne(){
        DelphiController.getWrapperConfigData();
        Delphi_Configuration__c config=[SELECT Id,Configuration_Type__c,Last_Model_Run__c,Last_Prediction_Run__c,Model_Status__c,Prediction_Status__c,Selected_Fields__c,Selected_Field_Account__c,Selected_Field_User__c FROM Delphi_Configuration__c];
        config.Model_Status__c='Running';
        config.RFE_Fields__c='Name,StageName';
        DelphiController.initiateModelLearning(false,new List<String>(),config);
        config.Model_Status__c='Success';
        config.Prediction_Status__c='Running';
        DelphiController.initiateOpportunityPrediction();
    }
    
    @isTest
    static void testCaseTwo(){
        DelphiController.getWrapperConfigData();
        Delphi_Configuration__c config=[SELECT Id,Configuration_Type__c,Last_Model_Run__c,Last_Prediction_Run__c,Model_Status__c,Prediction_Status__c,Selected_Fields__c,Selected_Field_Account__c,Selected_Field_User__c FROM Delphi_Configuration__c];
        config.Model_Status__c='Running';
        config.RFE_Fields__c='Name,StageName';
        config.Configuration_Type__c='Manual';
        config.Selected_Fields__c='Name,StageName';
        List<String> selFields=String.valueOf(config.Selected_Fields__c).split(',');
        DelphiController.initiateModelLearning(false,selFields,config);
        config.Model_Status__c='Success';
        config.Prediction_Status__c='Running';
        DelphiController.initiateOpportunityPrediction();
    }
}