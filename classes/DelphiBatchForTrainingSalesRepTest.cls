@isTest
public class DelphiBatchForTrainingSalesRepTest {
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
        insert oppToInsert;
    }
    
    @isTest
    static void testCaseOne(){
        Delphi_Configuration__c delphi=new Delphi_Configuration__c(Name='Delphi',Configuration_Type__c='Manual',RFE_Fields__c='Name,StageName,AccountId,NextStep,TotalOpportunityQuantity',Selected_Field_Account__c='Name,Industry',Selected_Field_User__c='Name,UserName');
        insert delphi;
        DelphiCalloutBatchForTrainingSalesRep d=new DelphiCalloutBatchForTrainingSalesRep('www.mockcallout.com');
        Database.executeBatch(d,1000);
    }
    
    @isTest
    static void testCaseTwo(){
        Delphi_Configuration__c delphi=new Delphi_Configuration__c(Name='Delphi',Configuration_Type__c='Automatic',RFE_Fields__c='Name,StageName,AccountId,NextStep,TotalOpportunityQuantity');
        insert delphi;
        DelphiCalloutBatchForTrainingSalesRep d=new DelphiCalloutBatchForTrainingSalesRep('www.mockcallout.com');
        Database.executeBatch(d,1000);
    }
}