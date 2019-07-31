@IsTest
public class NewTimeSheetFinalClsTest{
    public static testmethod void test1(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        insert usr;
        apexpages.currentpage().getparameters().put('uid' , usr.id);

        NewTimeSheetFinalCls ns = new NewTimeSheetFinalCls();
        ns.viewtimesheetrecord();
        ns.opennewtimesheetrecord();
        ns.submittimesheet();
        ns.logoutpage();
        ns.timesheetmenu();
    }
}