/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016            Gyanender Singh      This is class is used to show password page for the change password.
*******************/    
/**********************************************************************************/

public class ChangePasswordPageCls {
    public Useer__c usr {set;get;}
    public id uid =  ApexPages.CurrentPage().getparameters().get('userid');
    public list<Useer__c> userlist{get;set;}
    public static string password {set;get;}
    public pagereference pg;
    public string useremail{get;set;}
    public ChangePasswordPageCls() {
        
        userlist = [SELECT id, User_Email__c,Password__c,User_Name__c FROM Useer__c where User_Email__c != null and id =: uid];                
        if(userlist.size()>0){            
            usr = userlist[0]; 
        }
        useremail = usr.User_Email__c;                   
    }
    
    public pagereference changepassword(){
        
        if(usr.Password__c == null || usr.Password__c == '' ){            
            usr.Password__c = password;  
            upsert usr;
        } 
        pg = new pagereference('/apex/NewTimeSheetFinal?uid='+usr.id);
        pg.setredirect(true);      
        return pg;  
    }
    //Already PWD exist redirect it to login page
    public pagereference checkPw(){
         
        if(usr.Password__c == null || usr.Password__c == ''){             
            return null;                                           
        }else{
              pg = new pagereference('/apex/UserLoginFinal2');             
                pg.setredirect(true);      
                return pg;  
             }   
    }
}