@isTest
 public class PartnerPortalWelcomeController1Test{
   static testmethod void myTest(){
   
   
   
 /*  User us=new User();
   us.LMS_User__c='test';
   us.ORGCUSTOM4_DB__c=true;
   us.ORGCUSTOM4_OLD_FIRST_NAME__c='test';
   us.ORGCUSTOM4_OLD_LAST_NAME__c='test';
   us.Username='sameertyagi@mirketa.com';
   us.LastName='test';
   us.Email='test@abc.com';
   us.Alias='test';
   us.CommunityNickname='test1';
   us.TimeZoneSidKey='America/Los_Angeles';
   us.LocaleSidKey='en_US';
   us.EmailEncodingKey='ISO-8859-1';
   us.ProfileId='00ed000000181Nq';
   us.LanguageLocaleKey='en_US';
   insert us;
   
   Lead ld= new Lead();
   ld.LastName='test';
   ld.Company='test';
   ld.CurrencyIsoCode='USD';
   ld.LeadSource='test';
   ld.Status='test';
   ld.Profile_Link__c='test'; 
   insert ld;*/
   
    PartnerPortalWelcomeController  ppc = new  PartnerPortalWelcomeController ();
    ppc.getPartnerUser();
    ppc.getExpiringDealRegs();
    ppc.getActiveLeads();
    //ppc.AcceptLead();
    
   
   
   }
   }