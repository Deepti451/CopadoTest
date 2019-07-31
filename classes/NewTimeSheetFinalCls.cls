/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016            Gyanender Singh      This is class is used to show the menu in the page.
*******************/    
/**********************************************************************************/

public class NewTimeSheetFinalCls {

    //public list<TimeSheet__c> TimeSheetList{get;set;}   
    //public string selecttimesheetId{get;set;}
    public id userid = ApexPages.CurrentPage().getparameters().get('uid');
    //public list<TimeSheet__c> SubmitTimeSheetList{get;set;} 
    public date startdate{get;set;}
    public date enddate{get;set;}
    public useer__c usrname{get;set;}
    public id viewusrid = ApexPages.CurrentPage().getparameters().get('viewuserid');
    
    public NewTimeSheetFinalCls(){
        usrname = new useer__c();
        usrname = [select id,name from useer__c where id =: userid limit 1];        
        startdate = date.today().tostartofweek().adddays(+1);        
        enddate = startdate.adddays(+4);        
    }
    
    /*
        This method is used to call the viewtimesheet button and used to call the view page.
    */
    public pagereference viewtimesheetrecord(){        
        pagereference pg = new pagereference('/apex/ViewTimeSheetPage?viewuserid='+userid);
        pg.setredirect(true);
        return pg;        
    }
    
    /*
        This method is used to call the createtimesheet button and used to call create page.
    */
    public pagereference opennewtimesheetrecord(){
        pagereference pg = new pagereference('/apex/CreateNewTimeSheetRecordFinal2?lookupuserid='+userid);
        pg.setredirect(true);
        return pg;
    }
    
    /*
        This method is used to call the submit page.
    */
    public pagereference submittimesheet(){
        pagereference pg = new pagereference('/apex/SubmitTimesheetPage?viewuserid='+userid);
        pg.setredirect(true);
        return pg;
    }
    /*
        This method is used to call the logout page.
    */
    public pagereference logoutpage(){
        pagereference pg = new pagereference('/apex/UserLoginFinal2'); 
        pg.setredirect(true);
        return pg;
    }
    
    public pagereference timesheetmenu(){
        pagereference pg = new pagereference('/apex/NewTimeSheetFinal?uid='+viewusrid);
        pg.setredirect(true); 
        return pg;        
    }
    
}