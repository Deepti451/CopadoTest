@IsTest
public class UserLoginFinalclsTest{
    
    public static testmethod void test1(){
        
        string username = 'testusername';
        string password = 'pass';
        
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = username;
        usr.Password__c = password;
        insert usr;
        UserLoginFinalcls us = new UserLoginFinalcls();
        us.username = 'testusername';
        us.password = 'pass';
        us.loginpage();
    }
    public static testmethod void test2(){
        
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        insert usr;
        UserLoginFinalcls us = new UserLoginFinalcls();
        
        us.loginpage();
    }
}