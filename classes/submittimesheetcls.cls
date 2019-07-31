/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016            Gyanender Singh      This is class is used to submit the timesheet.
*******************/    
/**********************************************************************************/

public class submittimesheetcls {
    
    public date startdate{get;set;}
    public date enddate{get;set;}
    public opportunity startdatepicker{get;set;}
    public opportunity enddatepicker{get;set;}
    public list<TimeSheet__c> TimeSheetList{get;set;} 
    public string username{get;set;}
    public id viewusrid = ApexPages.CurrentPage().getparameters().get('viewuserid');
    public id id= ApexPages.CurrentPage().getparameters().get('id');
    public TimeSheet__c ts{get;set;}
    public list<TimeSheet__c> SubmitTimeSheetList{get;set;} 
    public boolean flag{get;set;}
    public boolean sendtimesheet{get;set;}
    public decimal sum;
    
    public submittimesheetcls(){
         sendtimesheet = false;
         SubmitTimeSheetList = new list<TimeSheet__c>();
         ts = new TimeSheet__c();
         startdatepicker = new opportunity();
         enddatepicker = new opportunity();
         startdatepicker.closedate = date.today().tostartofweek().adddays(+1);
         enddatepicker.closedate = startdatepicker.closedate.adddays(+4);
         startdate = startdatepicker.closedate;
         enddate = enddatepicker.closedate;
         
         TimeSheetList = new list<TimeSheet__c>();
         
         TimeSheetList = [select Submit_Record__c,Useer__r.name,Project__r.name,id,Name,Date__c,Description__c,Epic__c,Organisation__c,Project__c,Status__c,Task__c,Ticket_Number__c,Time_Spend__c,
                         Useer__c from TimeSheet__c where Useer__c =:viewusrid and Date__c>=:startdate and Date__c<=:enddate ]; 
         if(TimeSheetlist.size()>0){
            ts = TimeSheetlist[0];           
            username = TimeSheetlist[0].Useer__r.name;
        }
        else if(TimeSheetlist.size() == 0){
            Useer__c us = [select id,name from Useer__c where id =: viewusrid limit 1];                        
            username = us.name;                                           
        }                  
    }
    
    /*
        This method is used to fetch the all record and if we select the invalid date then its show the error.
    */
    public void alldata(){
            flag = false;
       
            startdate = startdatepicker.closedate;
            enddate = enddatepicker.closedate;
            
            TimeSheetList = new list<TimeSheet__c>();
            
            if(startdatepicker.closedate <= enddatepicker.closedate){
                TimeSheetList = [select Submit_Record__c,Useer__r.name,createddate,Project__r.name,id,Name,Date__c,Description__c,Epic__c,Organisation__c,Project__c,Status__c,Task__c,Ticket_Number__c,Time_Spend__c,
                                 Useer__c from TimeSheet__c where Useer__c =:viewusrid and Date__c>=:startdate and Date__c<=:enddate and Submit_Record__c = false and Useer__r.name =: username];                 
             }
             else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid date range'));
             }
               
    }
   
    
   /*
       This method is used to edit the records.       
   */
    public pagereference editrecord(){
        pagereference pg = new pagereference('/apex/CreateNewTimeSheetRecordFinal2?lookupuserid='+viewusrid+'&id='+ts.id);
        pg.setredirect(true);
        return pg;
    }
    /*
        This method is used to send the email if the number of hours is more than 40 for a week else show the error.
    */
    public void submittimesheet(){
    
        startdate = startdatepicker.closedate;
        enddate = enddatepicker.closedate;
    
        SubmitTimeSheetList = [select Submit_Record__c,Useer__r.name,Project__r.name,id,Name,Date__c,Description__c,Epic__c,Organisation__c,Project__c,
                               Status__c,Task__c,Ticket_Number__c,Time_Spend__c,
                               Useer__c from TimeSheet__c where Useer__c =:viewusrid and Date__c>=:startdate and Date__c<=:enddate  ORDER BY Date__c ASC];
        sum = 0;
        if(SubmitTimeSheetList.size()>0){
            for(TimeSheet__c tssum : SubmitTimeSheetList){
                if(tssum.Time_Spend__c != null){
                    sum += tssum.Time_Spend__c;                    
                }
            }
        }
        
        if(sum >=40 &&  (enddate == date.today() || enddate == date.today().tostartofweek().adddays(+5) || enddate == date.today().tostartofweek().adddays(+6) || enddate == date.today().tostartofweek().adddays(+0) || enddate == date.today().tostartofweek().adddays(-1)|| enddate == date.today().tostartofweek().adddays(-2))){
                
                string header = 'Date,Epic,Ticket,Task,Description,Hours,Organisation \n';
                string finalstr = header;
                for(TimeSheet__c ts: SubmitTimeSheetList){
                    string tickernumber = '';
                    string epic = '';
                    string timespend = '';
                    string Project = '';
                    string projectdate = ''; 
                    string task =''; 
                    string description = '';
                    string Organisation= '';
                    
                    if(ts.Organisation__c != null){
                        Organisation= ts.Organisation__c.replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    
                     if(ts.Description__c != null){
                        description = ts.Description__c.replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    
                    if(ts.Task__c != null){
                        task = ts.Task__c.replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    
                    if(ts.Ticket_Number__c != null){
                        tickernumber = ts.Ticket_Number__c.replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    if(ts.Epic__c != null){
                        epic = ts.Epic__c.replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    if(ts.Time_Spend__c != null){
                        timespend = string.valueof(ts.Time_Spend__c).replace(',' , ' ').replaceall('\r\n', ' '); 
                    }
                    if(ts.Project__r.name != null){
                        Project = ts.Project__r.name.replace(',' , ' ').replaceall('\r\n', ' ');   
                    }
                    if(ts.Date__c != null){
                        projectdate = string.valueof(ts.Date__c).replaceall('\r\n', ' ');    
                    }
                   
                    string recordstring = projectdate + ',' + epic + ' ,' +  tickernumber + ',' + task + ',' + description + ',' + timespend + ',' + Organisation +'\n';
                    finalstr = finalstr + recordstring;
                }
                
                
                    string htmlbody = ''; 
                    Datetime dt = datetime.newInstance(enddate.year(), enddate.month(),enddate.day());

                    string  weekenddate = dt.format('MM/dd/yyyy') ;

                   
                    htmlbody = ' Hi Sir'+ '<br/>' + '<br/>' +' Please find timesheet attached for '+ weekenddate + ' for ' + username +'<br/>' + '<br/>' + ' Thanks ' + '<br/>' + username ;
                
                    list<string> toadddress = (system.label.toaddress).split(';');
                    
                    
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                     
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    blob csvBlob = Blob.valueOf(finalstr);
                    string csvname = username + ' ' + weekenddate + ' ' + ' TimeSheet.csv ';
                    
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String subject ='Weekly TimeSheet';
                    mail.setSubject(subject);
                    mail.setToAddresses(toadddress);
                    mail.sethtmlBody(htmlbody);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                    mails.add(mail); 
                    if(mails.size()>0) {
                        
                            if(TimeSheetList.size()>0 && sendtimesheet == false){
                                Messaging.SendEmail(mails); 
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Your timesheet has been submitted successfully'));
                                for(TimeSheet__c te : TimeSheetList){
                                    if(te.Submit_Record__c == false){
                                        te.Submit_Record__c = true;
                                    }
                                }
                                update TimeSheetList;
                                TimeSheetList = new list<TimeSheet__c>();
                            } 
                            else if(TimeSheetList.size()>0 && sendtimesheet == true){
                                system.debug('******sendtimesheet222222********'+sendtimesheet);
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Timesheet for this duration has already been submitted.'));
                            } 
                            
                    }
                }
                
                else if((sum <40 || enddate != date.today()) &&  TimeSheetList.size()>0 ){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Total submitted hours are less than 40 or today date is not equal to or greater than the weekend date.'));    
                    system.debug('*************');
                }
                
                else if(TimeSheetList.size()==0){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'There is no Records.'));    
                }
           
    }
    
    public pagereference timesheetmenu(){
        pagereference pg = new pagereference('/apex/NewTimeSheetFinal?uid='+viewusrid);
        pg.setredirect(true); 
        return pg;
        
    }
    
    public pagereference logoutpage(){
        pagereference pg = new pagereference('/apex/UserLoginPage'); 
        pg.setredirect(true);
        return pg;
    }
}