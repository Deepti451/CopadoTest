public class DelphiDashboardController{
    public class DataWrapper{
        @AuraEnabled
        public List<Opportunity> oppList;
        @AuraEnabled
        public Map<Id,User> userMap;
        @AuraEnabled
        public Delphi_Configuration__c config;
        public DataWrapper(List<Opportunity> opp,Map<Id,User> uMap,Delphi_Configuration__c del){
            this.oppList=opp;
            this.userMap=uMap;
            this.config=del;
        }
    }
    
    @AuraEnabled
    public static DataWrapper getPredictedOpportunities(){
        Map<Id,User> mapOfUsers=new Map<Id,User>([SELECT Id,Name FROM User]);
        String query='SELECT Id,Name,Opportunity_Conversion_Probability__c,Predicted_Close_Date__c,Sales_Rep_Recommendation__c FROM Opportunity WHERE Opportunity_Conversion_Probability__c!=null AND StageName!=\'Closed Won\' AND StageName!=\'Closed Lost\' ORDER BY Opportunity_Conversion_Probability__c DESC LIMIT 50000 ';
        List<Opportunity> listOfOpps=Database.query(query);
        DataWrapper wrapperToReturn=new DataWrapper(listOfOpps,mapOfUsers,createConfig());
        return wrapperToReturn;
    }
    
    @AuraEnabled
    public static Delphi_Configuration__c createConfig(){
        List<Delphi_Configuration__c> metaType = new List<Delphi_Configuration__c>();
        metaType =[Select id,Configuration_Type__c,Time_Prediction_Status__c,Last_Model_Run__c,Last_Prediction_Run__c,Model_Status__c,Prediction_Status__c,Selected_Fields__c,Selected_Field_Account__c,Selected_Field_User__c from Delphi_Configuration__c];
        if(metaType.size()==0){
            Delphi_Configuration__c   delphi = new Delphi_Configuration__c();
            delphi.Name='Delphi config';
            metaType.add(delphi);
            insert metaType;
        }
        return metaType[0];
    }
}