@isTest
public class DelphiDashboardControllerTest {
    @Testsetup
    public static void setupTestDataforDelphiDashboard(){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0;i<20;i++){
     		oppList.add(new Opportunity(Name='Test Opportunity',Opportunity_Conversion_Probability__c=93.2,StageName='Prospecting',CloseDate=System.today().addDays(2)));
        }
        insert oppList;
    }
    @isTest
    public static void testCaseOne(){
        List<String> selectedFields=new List<String>{'Name','StageName','NextStep','TotalOpportunityQuantity'};
        String query='SELECT Id,Name,StageName,Probability,NextStep,TotalOpportunityQuantity FROM Opportunity';
        DelphiDashboardController.getPredictedOpportunities();
    }
}