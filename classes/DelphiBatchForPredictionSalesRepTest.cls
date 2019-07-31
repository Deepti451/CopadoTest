@isTest
public class DelphiBatchForPredictionSalesRepTest {
    @TestSetup
    public static void setuptestDataforSalesRepPred(){
        List<Account> accList = new List<Account>();
        accList.add(new Account (Name='Test1'));
        accList.add(new Account(Name='Test2'));
        insert accList;
        List<Opportunity> oppToInsert=new List<Opportunity>();
        for(Integer i=1;i<=10;i++){
            if(Math.mod(i,2)==0)
                oppToInsert.add(new Opportunity(Name='Global Closed Opp',AccountId=accList[0].Id,StageName='Prospecting',CloseDate=System.today()));
            else
                oppToInsert.add(new Opportunity(Name='Local Closed Opp',AccountId=accList[1].Id,StageName='Prospecting',CloseDate=System.today()));
        }
        insert oppToInsert;
        
    }
    @isTest
    public static void TestOne(){
        Delphi_Configuration__c delphi=new Delphi_Configuration__c(Name='Delphi',Configuration_Type__c='Manual',RFE_Fields__c='Name,StageName,AccountId,NextStep,TotalOpportunityQuantity,OwnerId',Selected_Field_Account__c='Name,Industry',Selected_Field_User__c='Name,UserName');
        insert delphi;
        DelphiCalloutBatchForPredictionSalesRep d=new DelphiCalloutBatchForPredictionSalesRep('www.mockcallout.com');
        Database.executeBatch(d,1000);
    }
    
    @isTest
    public static void TestTwo(){
        Delphi_Configuration__c delphi=new Delphi_Configuration__c(Name='Delphi SalesRep',Configuration_Type__c='Automatic',RFE_Fields__c='Name,StageName,AccountId,NextStep,TotalOpportunityQuantity,OwnerId');
        insert delphi;
        DelphiCalloutBatchForPredictionSalesRep d=new DelphiCalloutBatchForPredictionSalesRep('www.mockcallout.com');
        Database.executeBatch(d,1000);
    }
   
    
}