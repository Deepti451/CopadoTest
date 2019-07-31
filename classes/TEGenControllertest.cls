@IsTest
public class TEGenControllertest{
     public static testmethod void test1(){
         account acc = new account();
             acc.name = 'test';
             acc.AccountNumber = 'test';
         insert acc;
         
         opportunity opp = new opportunity();
             opp.name = 'testopp';
             opp.Accountid = acc.id;
             opp.CloseDate = date.today();
             opp.StageName = 'Prospecting';         
         insert opp;
         
         Contact con = new Contact();
             con.Accountid = acc.id;
             con.lastname = 'con';
         insert con;
         
         Lead le = new lead();
             le.lastname = 'tedst';
             le.company = 'testle';
             le.LeadSource = 'Linkedin';
             le.Profile_Link__c = 'testpr';
         insert le;
         
         case ca = new case();
             ca.Status = 'New';
             ca.Origin = 'Email';
         insert ca;
         
         TEGenController te = new TEGenController();
         
         te.init();
         te.save();
         te.clearAll();
         te.getEs();
         te.getTs();
         
     }
     
     
}