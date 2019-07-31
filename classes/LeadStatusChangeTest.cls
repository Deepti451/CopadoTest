@isTest
public class LeadStatusChangeTest{
    static testMethod void LeadStatusChange() {
        Lead objLead = new lead();
        objLead.LastName = 'test';
        objLead.Company = 'mirketa';
        objLead.LeadSource = 'Web';
        objLead.Status = 'open';
        objLead.Profile_Link__c = 'Test Link';
        insert objLead;
        objLead.Status = 'Qualified';
        update objLead;
        
        LeadStatusChange objLeadStat = new LeadStatusChange();
        objLeadStat.statuschange();
    }

}