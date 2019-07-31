@IsTest
public class ChangePasswordPageClsTest{
    public static testmethod void test1(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        usr.User_Email__c = 'test@test.com';
        insert usr;
        apexpages.currentpage().getparameters().put('userid' , usr.id);
        ChangePasswordPageCls cc = new ChangePasswordPageCls();
        cc.changepassword();
        cc.checkPw();
        ChangePasswordPageCls.password = 'pass';
    }
    public static testmethod void test2(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = '';
        usr.User_Email__c = 'test@test.com';
        insert usr;
        apexpages.currentpage().getparameters().put('userid' , usr.id);
        ChangePasswordPageCls cc = new ChangePasswordPageCls();
        cc.changepassword();
        cc.checkPw();
        ChangePasswordPageCls.password = '';
    }
}