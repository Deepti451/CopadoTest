/******************************Mirkeat INC.*****************************************************/
/****************         
    Updated date        Developer name     Description
    2/2/2016            Gyanender Singh    This is class is used to to open the login page on the basis of the credential.
*******************/    
/**********************************************************************************/

public class UserLoginFinalcls {

    public string username{get;set;}
    public string password{get;set;}
    public Useer__c usr{get;set;}
    public string password1;
    public string password2;
    public UserLoginFinalcls() {
        
    }
    /*
        This method is used to call the login button.
    */
    public pagereference loginpage(){
        try{
            usr = [select id,name,IsActive__c,Password__c,User_Email__c,User_Name__c from Useer__c where User_Name__c =: username and Password__c =: password and Password__c != null and User_Name__c != null and IsActive__c =: true];
            
            password1 = usr.Password__c;
            password2 = password;
            if(password1.equals(password2)){
                pagereference pg = new pagereference('/apex/NewTimeSheetFinal?uid='+usr.id);
                pg.setredirect(true);
            return pg;  
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Password is case sesitive.Please fill the correct password.')); 
                return null;
            }  
        }
        catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please fill the correct credential'));            
            return null;
            
        }        
    }
}