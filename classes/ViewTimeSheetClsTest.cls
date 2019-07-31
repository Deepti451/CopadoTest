@IsTest
public class ViewTimeSheetClsTest{
    public static testmethod void test1(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        insert usr;
        apexpages.currentpage().getparameters().put('viewuserid' , usr.id);
        ViewTimeSheetCls vs = new ViewTimeSheetCls();
        vs.alldata();
        vs.timesheetmenu();
        vs.logoutpage();
        vs.createnewrecord();
    }
}