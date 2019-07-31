@IsTest
public class submittimesheetclsTest{
    public static testmethod void test1(){
        Useer__c usr = new Useer__c();
        usr.name = 'test';
        usr.IsActive__c = true;
        usr.User_Name__c = 'test';
        usr.Password__c = 'password';
        insert usr;
        apexpages.currentpage().getparameters().put('viewuserid' , usr.id);
        
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
        ts.Date__c = date.today().tostartofweek().adddays(+1);
        ts.Ticket_Number__c = 'test 4';
        ts.Time_Spend__c = 42;
        insert ts; 
        
        submittimesheetcls vs = new submittimesheetcls ();
        
        vs.alldata();
        
        vs.editrecord();
        vs.sum = 41;
        vs.enddate = date.today();
        vs.submittimesheet();
        vs.timesheetmenu();
        vs.logoutpage();
    }
    
    public static testmethod void test2(){
        date enddate;
        Useer__c usr1 = new Useer__c();
        usr1.name = 'test';
        usr1.IsActive__c = true;
        usr1.User_Name__c = 'test';
        usr1.Password__c = 'password';
        insert usr1;
        apexpages.currentpage().getparameters().put('viewuserid' , usr1.id);
        
        Project__c  po1 = new Project__c();
        po1.name = 'test';
        insert po1;
        
        TimeSheet__c ts1 = new TimeSheet__c();
        ts1.Description__c = 'test';
        ts1.Epic__c = 'test 1';
        ts1.Organisation__c = 'Developer';  
        ts1.Project__c = po1.id;
        ts1.Status__c = 'In Progress';
        ts1.Task__c = 'test 2';
        ts1.Useer__c = usr1.id;
        ts1.Date__c = date.today().tostartofweek().adddays(-2);
        ts1.Ticket_Number__c = 'test 4';
        ts1.Time_Spend__c = 99;
        insert ts1; 
        
        TimeSheet__c ts2 = new TimeSheet__c();
        ts2.Description__c = 'test';
        ts2.Epic__c = 'test 1';
        ts2.Organisation__c = 'Developer';  
        ts2.Project__c = po1.id;
        ts2.Status__c = 'In Progress';
        ts2.Task__c = 'test 2';
        ts2.Useer__c = usr1.id;
        ts2.Date__c =date.today();// enddate;
        ts2.Ticket_Number__c = 'test 4';
        ts2.Time_Spend__c = 99;
        insert ts2; 
        
        submittimesheetcls vs1 = new submittimesheetcls ();
        vs1.sum = 99;
        vs1.enddate = date.today();
        vs1.submittimesheet();
        
        
    }
    
     public static testmethod void test3(){
        date enddate;
        Useer__c usr1 = new Useer__c();
        usr1.name = 'test';
        usr1.IsActive__c = true;
        usr1.User_Name__c = 'test';
        usr1.Password__c = 'password';
        insert usr1;
        apexpages.currentpage().getparameters().put('viewuserid' , usr1.id);
        
        Project__c  po1 = new Project__c();
        po1.name = 'test';
        insert po1;     
        
        submittimesheetcls vs1 = new submittimesheetcls ();
        vs1.sum = 99;
        vs1.enddate = date.today();
        vs1.submittimesheet();                
    }
    public static testmethod void test4(){
        date enddate;
        Useer__c usr1 = new Useer__c();
        usr1.name = 'test';
        usr1.IsActive__c = true;
        usr1.User_Name__c = 'test';
        usr1.Password__c = 'password';
        insert usr1;
        apexpages.currentpage().getparameters().put('viewuserid' , usr1.id);
        
        Project__c  po1 = new Project__c();
        po1.name = 'test';
        insert po1;
        
        TimeSheet__c ts1 = new TimeSheet__c();
        ts1.Description__c = 'test';
        ts1.Epic__c = 'test 1';
        ts1.Organisation__c = 'Developer';  
        ts1.Project__c = po1.id;
        ts1.Status__c = 'In Progress';
        ts1.Task__c = 'test 2';
        ts1.Useer__c = usr1.id;
        ts1.Date__c = date.today().tostartofweek().adddays(-2);
        ts1.Ticket_Number__c = 'test 4';
        ts1.Time_Spend__c = 39;
        insert ts1; 
        
        TimeSheet__c ts2 = new TimeSheet__c();
        ts2.Description__c = 'test';
        ts2.Epic__c = 'test 1';
        ts2.Organisation__c = 'Developer';  
        ts2.Project__c = po1.id;
        ts2.Status__c = 'In Progress';
        ts2.Task__c = 'test 2';
        ts2.Useer__c = usr1.id;
        ts2.Date__c =date.today();// enddate;
        ts2.Ticket_Number__c = 'test 4';
        ts2.Time_Spend__c = 42;
        insert ts2; 
        
        opportunity opp = new opportunity();
        opp.closedate = date.today();
        opp.stagename = 'test';
        opp.Name = 'test';
        insert opp;
        
        submittimesheetcls vs1 = new submittimesheetcls ();
        vs1.enddatepicker = opp;
        vs1.sum = 99;
        vs1.enddate = date.today().tostartofweek().adddays(+3);
        system.debug('*******vs1.enddate******'+vs1.enddate);
        vs1.submittimesheet();
        
        
    }


}