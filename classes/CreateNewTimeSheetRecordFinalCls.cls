/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016          Gyanender Singh      This is class is used to create the record in the timesheet.
*******************/    
/**********************************************************************************/

public class CreateNewTimeSheetRecordFinalCls {
        
    list<TimeSheet__c> TimeSheetlist{get;set;} 
    public TimeSheet__c ts{get;set;}
    public id lookuserid = ApexPages.CurrentPage().getparameters().get('lookupuserid');      
    public id viewuserid = ApexPages.CurrentPage().getparameters().get('viewuserid');    
    public id timesheetid = ApexPages.CurrentPage().getparameters().get('id');
    public string username{get;set;}
    public Useer__c us{get;set;}
    
    /*
        constructor is used to fetch the all timesheet record at the load time.
    */
    public CreateNewTimeSheetRecordFinalCls(){        
        us = new Useer__c();
        ts = new TimeSheet__c();
        TimeSheetlist = new list<TimeSheet__c>();
        
        TimeSheetlist = [select Useer__r.name,project__r.id,Project__r.name,id,Date__c,Description__c,Epic__c,Organisation__c,Project__c,Status__c,
                                            Task__c,Ticket_Number__c,Time_Spend__c,Useer__c from TimeSheet__c where id =: timesheetid]; // 
           
        if(TimeSheetlist.size()>0){
            ts = TimeSheetlist[0];           
            username = TimeSheetlist[0].Useer__r.name;
        }
        
        else if(TimeSheetlist.size() == 0){
            Useer__c us;
            list<Useer__c> userlist = new list<Useer__c>();
            userlist = [select id,name from Useer__c where id =: lookuserid limit 1];
            if(userlist.size()>0){
                us = userlist[0];
            }
            //Useer__c us = [select id,name from Useer__c where id =: lookuserid limit 1];
            
            username = us.name;            
            ts.Useer__c = us.id; 
            ts.Date__c = null;
            ts.Task__c = null;  
            ts.Project__c = null;
            ts.Ticket_Number__c = null;
            ts.Epic__c = null;
            ts.Organisation__c = null;
            ts.Time_Spend__c = null; 
            ts.Description__c = null;
                   
        }
    }
    
    /*
        This is used to call on the cancel button and after call this method to go to the menu page.
    */
    public pagereference cancelRecord(){        
        pagereference cancelpage = new pagereference('/apex/NewTimeSheetFinal?uid='+lookuserid);        
        cancelpage.setredirect(true);       
        return cancelpage;
    }
    
    /*
        This is used to call on the save button and after call this method to go to the main page.
    */
    public pagereference saverecord(){
        try{           
            upsert ts;
            pagereference page = new pagereference('/apex/ViewTimeSheetPage?viewuserid='+lookuserid);          
            page.setredirect(true);
            return page;
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
            System.debug('==============================' + ex.getMessage());
            return null;
        }
        
    }
    /*
        This is used to call on the save and new button and after call this method record save and remain in the same page.
    */
    public pagereference saveandnew(){
        upsert ts;
        system.debug('*****ts44444*****'+ts);
        pagereference pg = new pagereference('/apex/CreateNewTimeSheetRecordFinal2?lookupuserid='+lookuserid);
        pg.setredirect(true);
        return pg;
    }
    /*
        This is used to call on the log out button and after call this method to go to the login page.
    */
    public pagereference logoutpage(){
        pagereference pg = new pagereference('/apex/UserLoginFinal2'); 
        pg.setredirect(true);
        return pg;
    }            
}