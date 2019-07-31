public class DelphiEmailUtility {
    
    public static void PostModelCreationEmail(){
        
        Delphi_Configuration__c checkStatus = [select base_url__c,Model_Status__c from Delphi_Configuration__c];
        
        EmailTemplate userEmail = new EmailTemplate();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        
        if(checkStatus.Model_Status__c=='Success'){
        
        userEmail = [Select Id from EmailTemplate where developername = 'Model_Complete'];
                
        } 
        else
        {
        
        userEmail = [Select Id from EmailTemplate where developername = 'Model_Learning_Failed'];
        
        }
        
        string s = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html;charset=utf-8"/><title>UntitledDocument</title></head><body style="margin:0;padding:0;"><table width="500" cellspacing="0" cellpadding="0" border="0" align="center" style="font-family:calibri;border:solid 1px #ccc;color:#000000;"><tbody><tr><td style="background-color:#fdfdfd;"><table width="540"cellspacing="0" cellpadding="0" border="0"><tbody><tr><td height="100" valign="middle" align="center"style="border-bottom: solid 1px #ccc;"><img src="https://delphi-app-dev-ed.my.salesforce.com/servlet/servlet.ImageServer?id=0156F00000GmxeE&amp;oid=00D6F000002Yq9b&amp" style="width: 140px"></td></tr><tr><td valign="top" align="right"><table cellspacing="0" cellpadding="0" border="0"><tbody><tr><td valign="middle" style="padding-left:10px;padding-right:6px;"><p style="margin:0;">&nbsp;</p><p><strong>Hello</strong>{!User.Name}</p><p style="word-spacing:0px;">Delphi has analyzed all your historical sales data and is set to recommend you the following:</p><ul><li>Opportunity Ranking</li><li>Sales Rep recommendation</li><li>Forecasted time for completion of your open Opportunities</li></ul><p>All you need to do is to initiate prediction from <a href="' + checkStatus.base_url__c + '/lightning/n/Configure">here</a>.</p><p>Happy reviewing!</p></td></tr></tbody></table></td></tr></table></td></tr><tr><td valign="bottom" style="padding-left: 10px;padding-right:6px;background-color:#fdfdfd;"><br/><p><strong>Thank you for using Delphi.</strong></p><p><strong>Mirketa Inc</strong><strong><br/></strong><strong>2600 Camino Ramon Rd,Suite 300D,&nbsp;<br/>San Ramon,CA 94583</strong></p><br/></td></tr><tr><td bgcolor="#fafafa" style="background-color:#e8ddee;border-top:solid2px#ccc;"><table width="540"cellspacing="0" cellpadding="0" align="center"><tbody><tr><td width="100%" valign="middle" height="50"style="background-color:#ecfafb;" align="center"><table border="0" align="right" cellpadding="0"cellspacing="5"><tbody><tr><td width="15%" style="padding:10px;"><a href="http://www.mirketa.com" rel="nofollow" target="_blank"><img style="width:120px" src="https://www.mirketa.com/images/Mirketa-logo.png"></a></td><td width="85%" style="padding-right:13px;"><div style="text-align:center;font-family:Arial;font-weight:bold;font-size:14px;margin-top:0px;margin-bottom:0px;padding:0px;color:#7b7777;">Need Help?|Email us at-help@mirketa.com</div></td></tr></tbody></table></td></tr></tbody></table></td></tr></tbody></table></body></html>';
        //mail.setTemplateID(userEmail.Id);
        mail.setHtmlBody('s'); 
        mail.setTargetObjectId('0056F00000AUtVs');  //Userinfo.getUserId()
        mail.setSaveAsActivity(false);
        allmsg.add(mail);
        Messaging.sendEmail(allmsg,false);
        
        
    }
    
    public static void PostPredictionEmail(){
        
        Delphi_Configuration__c checkStatus = [select Prediction_Status__c from Delphi_Configuration__c];
        
        EmailTemplate userEmail = new EmailTemplate();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        
        if(checkStatus.Prediction_Status__c=='Success'){
        
        userEmail = [Select Id from EmailTemplate where developername = 'Prediction_Complete'];
                
        } 
        else
        {
        
        userEmail = [Select Id from EmailTemplate where developername = 'Prediction_Failed'];
        
        }
        
        mail.setTemplateID(userEmail.Id); 
        mail.setTargetObjectId('0056F00000AUtVs');  //Userinfo.getUserId()
        mail.setSaveAsActivity(false);
        allmsg.add(mail);
        Messaging.sendEmail(allmsg,false);
        
    }
    
}