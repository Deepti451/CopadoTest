public class LeadStatusChange {
    List<Lead> lstlead = new List<Lead>();    
    public LeadStatusChange(){   
    }
    public pagereference statuschange(){
    Id leadId = apexpages.currentpage().getparameters().get('lid');
    lstlead = [Select id,Status from lead where id =: leadId];
        if(lstlead.size() == 1 )
        lstlead[0].Status_For_NewsLetter__c = 'active';        
        update lstlead;
    //PageReference mirketaSite= new PageReference('http://www.mirketa.com');
    //mirketaSite.setRedirect(true);
    return null;
    }
}