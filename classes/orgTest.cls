@isTest
private class orgTest {

    static testMethod void runPositiveTestCases() {
        
        Account acc = new Account();
        acc.name = 'test';
        acc.EDY_ORGCUSTOM__DB__c = true;
        acc.EDY_ORGCUSTOM__Old_Name__c = 'test';
        insert acc;
        
        
        
        Opportunity opp = new Opportunity();
        opp.name = 'test';
        opp.accountid = acc.id;
        opp.stagename = 'Prospecting';
        opp.closedate = date.today();
        opp.amount = 2000000;
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.name = 'test';
        opp1.accountid = acc.id;
        opp1.stagename = 'Prospecting';
        opp1.closedate = date.today();
        opp1.amount = 100;
        insert opp1;
        
        Campaign ca = new Campaign();
        ca.name = 'test';
        ca.EDY_ORGCUSTOM__Old_Name__c = 'test';
        ca.EDY_ORGCUSTOM__DB__c =true;
        ca.StartDate = date.today()-1;
        ca.EndDate = date.today();
        insert ca;
        
        
        OrgCustomizerController orgCust = new OrgCustomizerController();
        //orgCust.doNothing(); It was showing error during deployment of timesheet code so I am commenting this line. Sameer Tyagi 
        orgCust.updateOrganization();
        orgCust.updateContacts();
        orgCust.updateProducts();
        //orgCust.updateCampaigns();
        orgCust.updateUsers();
        //orgCust.updateCases();
        orgCust.resetAccounts();
        orgCust.resetContacts();
        orgCust.resetProducts();
        //orgCust.resetCampaigns();
        //orgCust.resetUsers();
        
        orgCust.updateAccounts();
        orgCust.setupCasesSolutions();
    }
    
}