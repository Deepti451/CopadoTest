@isTest
public class DelphiCalloutBatchForScoringTest {
    @testSetup
    public static void setupTestDataforScoring(){
        List<Opportunity> oppList= new List<Opportunity>();
        for(Integer i=0;i<10;i++){
            oppList.add(new Opportunity(Name='Vernika',StageName='Prospecting',CloseDate=System.today().addDays(2))); 
                        }
        insert oppList;
    }
    @isTest
    public static void testcaseone(){
        List<String> selectedFields=new List<String>{'Name','StageName','NextStep','TotalOpportunityQuantity'};
        String query='SELECT Id,Name,StageName,Probability,NextStep,TotalOpportunityQuantity FROM Opportunity';
        DelphiCalloutBatchForScoring d=new DelphiCalloutBatchForScoring(query,selectedFields,'www.mockcallout.com');
        Database.executeBatch(d,1000);
    }

}