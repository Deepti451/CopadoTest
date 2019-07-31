/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016            Gyanender Singh      This is class is used to view the timesheet.
*******************/    
/**********************************************************************************/

public class ViewTimeSheetCls {
    
    public date startdate{get;set;}
    public date enddate{get;set;}
    public opportunity startdatepicker{get;set;}
    public opportunity enddatepicker{get;set;}
    public list<TimeSheet__c> TimeSheetList{get;set;} 
    public string username{get;set;}
    public id viewusrid = ApexPages.CurrentPage().getparameters().get('viewuserid');
    public id id= ApexPages.CurrentPage().getparameters().get('id');
    public TimeSheet__c ts{get;set;}
    //public list<TimeSheet__c> SubmitTimeSheetList{get;set;} 
    //public string selecttimesheetId{get;set;}
    
    public ViewTimeSheetCls(){
         
         //SubmitTimeSheetList = new list<TimeSheet__c>();
         ts = new TimeSheet__c();
         startdatepicker = new opportunity();
         enddatepicker = new opportunity();
         startdatepicker.closedate = date.today().tostartofweek().adddays(+1);
         enddatepicker.closedate = startdatepicker.closedate.adddays(+4);
         startdate = startdatepicker.closedate;
         enddate = enddatepicker.closedate;
         
         TimeSheetList = new list<TimeSheet__c>();
         
         TimeSheetList = [select Useer__r.name,Project__r.name,id,Name,Date__c,Description__c,Epic__c,Organisation__c,Project__c,Status__c,Task__c,Ticket_Number__c,Time_Spend__c,
                         Useer__c from TimeSheet__c where Useer__c =:viewusrid and Date__c>=:startdate and Date__c<=:enddate ]; 
         system.debug('******TimeSheetList111111*********'+TimeSheetList);
         system.debug('******TimeSheetList111111.size()*********'+TimeSheetList.size());
         //system.debug('*****Useer__r.name*******'+Useer__r.name);
         system.debug('*****username111111*******'+username);
         if(TimeSheetlist.size()>0){
            ts = TimeSheetlist[0];           
            username = TimeSheetlist[0].Useer__r.name;
        }
        else if(TimeSheetlist.size() == 0){
            Useer__c us = [select id,name from Useer__c where id =: viewusrid limit 1];                        
            username = us.name;                                           
        }                  
    }
    
    public void alldata(){           
         startdate = startdatepicker.closedate;
         enddate = enddatepicker.closedate;
            
            TimeSheetList = new list<TimeSheet__c>();
            
            if(startdatepicker.closedate <= enddatepicker.closedate){
                TimeSheetList = [select Useer__r.name,createddate,Project__r.name,id,Name,Date__c,Description__c,Epic__c,Organisation__c,Project__c,Status__c,Task__c,Ticket_Number__c,Time_Spend__c,
                                 Useer__c from TimeSheet__c where Date__c>=:startdate and Date__c<=:enddate and Useer__r.name =: username];    
             system.debug('*****username22222222*******'+username);
             }
             else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid date range'));
             }
         
        
    }
    
    
    public pagereference timesheetmenu(){
        pagereference pg = new pagereference('/apex/NewTimeSheetFinal?uid='+viewusrid);
        pg.setredirect(true); 
        return pg;
        
    }
    
    public pagereference createnewrecord(){
        pagereference pg = new pagereference('/apex/CreateNewTimeSheetRecordFinal2?lookupuserid='+viewusrid);
        pg.setredirect(true); 
        return pg;
        
    }
    
    public pagereference logoutpage(){
        pagereference pg = new pagereference('/apex/UserLoginPage'); 
        pg.setredirect(true);
        return pg;
    }
}