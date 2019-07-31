@isTest
public class CreateNewTimeSheetRecordFinalTest{
    public static testmethod void test1(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        insert usr;
        apexpages.currentpage().getparameters().put('lookupuserid' , usr.id);
        
        Project__c  po = new Project__c();
        po.name = 'test';
        insert po;
        
        TimeSheet__c ts = new TimeSheet__c();
        ts.Description__c = 'test';
        ts.Epic__c = 'test 1';
        ts.Organisation__c = 'Developer';  
        ts.Project__c = po.id;
        ts.Status__c = 'In Progress';
        ts.Task__c = 'test 2';
        ts.Useer__c = usr.id;
        ts.Date__c = date.today();
        ts.Ticket_Number__c = 'test 4';
        ts.Time_Spend__c = 4;
        insert ts; 
        
           
          
        CreateNewTimeSheetRecordFinalCls cn = new CreateNewTimeSheetRecordFinalCls();
        cn.cancelRecord();
        cn.saverecord();
        cn.logoutpage();
        
        //cn.saveandnew();
    }
}