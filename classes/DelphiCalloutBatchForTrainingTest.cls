@isTest
public class DelphiCalloutBatchForTrainingTest {
	@testSetup
    static void setupTestData(){
        List<Opportunity> oppToInsert=new List<Opportunity>();
        for(Integer i=0;i<20;i++){
            oppToInsert.add(new Opportunity(Name='Test Opportunity',StageName='Closed Won',CloseDate=System.today().addDays(2)));
        }
        insert oppToInsert;
    }
    
    @isTest
    static void testCaseOne(){
        List<String> selectedFields=new List<String>{'Name','StageName','NextStep','TotalOpportunityQuantity'};
        String query='SELECT Id,Name,StageName,Probability,NextStep,TotalOpportunityQuantity FROM Opportunity';
        DelphiCalloutBatchForTraining d=new DelphiCalloutBatchForTraining(query,selectedFields,'www.mockcallout.com');
        Database.executeBatch(d,1000);
    }    
}