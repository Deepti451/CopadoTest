global class ImplementTimePredictionBatch implements Database.Batchable<sObject>,Database.stateful {
    
    global double delta;
        
    global ImplementTimePredictionBatch(double d){
         delta = d;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
      return database.getQueryLocator([select Id,Predicted_Close_Date__c,createdDate from Opportunity where stagename != 'Closed Won']);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> records){
        
        List<Opportunity> updateTimeList = new List<Opportunity>();
        
        for(Opportunity o : records){
                
                long ageOfOpp = system.now().getTime() - o.createdDate.getTime();
                system.debug('age of opp: '+ageOfOpp);
                double ageOfOppDays = ageOfOpp/86400000; 
                system.debug('age of opp in days: '+ageOfOppDays);
                double adjustDate = delta - ageOfOppDays;
                system.debug('adjust date: '+adjustDate);    
            
                o.Predicted_Close_Date__c = Date.today().addDays(Integer.valueOf(adjustDate));
                
                system.debug('value prediction: '+Date.today().addDays(Integer.valueOf(adjustDate)));
                updateTimeList.add(o); 
            }
          
        update updateTimeList;  
       
    }    
    
    global void finish(Database.BatchableContext bc){
        
       AsyncApexJob a = [Select Id,Status,NumberOfErrors from AsyncApexJob where Id =:BC.getJobId()];
       Delphi_Configuration__c delphiConfigObj = new Delphi_Configuration__c();
        
        if(a.NumberOfErrors==0){
            
            delphiConfigObj = [select Time_Prediction_Status__c from Delphi_Configuration__c];
            delphiConfigObj.Time_Prediction_Status__c = 'Success';
            update delphiConfigObj;
        } else{
            delphiConfigObj = [select Time_Prediction_Status__c from Delphi_Configuration__c];
            delphiConfigObj.Time_Prediction_Status__c = 'Failure';
            update delphiConfigObj;
            
        }
        DelphiEmailUtility.PostPredictionEmail();
        
    }    
}