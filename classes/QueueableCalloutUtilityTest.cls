@isTest
public class QueueableCalloutUtilityTest {
	@isTest
    static void testCaseOne(){
        Test.setMock(HttpCalloutMock.class,new OpportunityModelMock());
        System.enqueueJob(new QueueableCalloutUtility('hi','https://delphi-mirketa.herokuapp.com/FitModel'));
        CalloutUtility.processCalloutToPython('hi','https://delphi-mirketa.herokuapp.com/FitModel');
    }
}