public class DelphiController{
    //wrapper class to return the config data
    public class DataWrapper{
        @AuraEnabled
        public Map<String,String> mapOfFieldsOpportunity; //map of opportunity fields <label,api name>
        @AuraEnabled
        public Map<String,String> mapOfFieldsAccount; //map of account fields <label,api name>
        @AuraEnabled
        public Map<String,String> mapOfFieldsUser; //map of user fields <label,api name>
        @AuraEnabled
        public Integer modelOppCount; //opportunity count since last model run 
        @AuraEnabled
        public Integer predOppCount; //opportunity count since last prediction
        @AuraEnabled
        public Delphi_Configuration__c configRec; //configuration record
        
        public DataWrapper(Map<String,String> fldMap,Map<String,String> fldMapAccount,Map<String,String> fldMapUser,Integer modelCount,Integer predCount,Delphi_Configuration__c config){
            this.mapOfFieldsOpportunity=fldMap;
            this.mapOfFieldsAccount=fldMapAccount;
            this.mapOfFieldsUser=fldMapUser;
            this.modelOppCount=modelCount;
            this.predOppCount=predCount;
            this.configRec=config;
        }
    }
    
    //returns wrapper class object for state retention
    @AuraEnabled
    public static DataWrapper getWrapperConfigData() {
        Delphi_Configuration__c config=createConfig();
        Integer modelOppCount=[SELECT COUNT() FROM Opportunity WHERE Delphi_CloseDate__c>:config.Last_Model_Run__c AND (StageName='Closed Won' OR StageName='Closed Lost')];
        Integer predOppCount=[SELECT COUNT() FROM Opportunity WHERE CreatedDate>:config.Last_Prediction_Run__c AND StageName!='Closed Won' AND StageName!='Closed Lost'];
        DataWrapper wrapperObj=new DataWrapper(getOpportunityFields(),getAccountFields(),getUserFields(),modelOppCount,predOppCount,config);
        return wrapperObj;
    }
    
    //returns map of opportunity fields
    @AuraEnabled
    public static Map<String,String> getOpportunityFields() {
        Map<String,String> fieldMap = new Map<String,String>();
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
        for(String str:schemaFieldMap.keyset()){
            String dataType=String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).trim();
            if(!dataType.equalsIgnoreCase('Date') && !dataType.equalsIgnoreCase('DATETIME') && !dataType.equalsIgnoreCase('AUTONUMBER') && !dataType.equalsIgnoreCase('TEXTAREA') && !schemaFieldMap.get(str).getDescribe().getName().equalsIgnoreCase('Probability') && !schemaFieldMap.get(str).getDescribe().getName().equalsIgnoreCase('StageName') && !schemaFieldMap.get(str).getDescribe().getName().equalsIgnoreCase('Opportunity_Conversion_Probability__c') && !schemaFieldMap.get(str).getDescribe().getName().equalsIgnoreCase('IsClosed') && !schemaFieldMap.get(str).getDescribe().getName().equalsIgnoreCase('IsWon')){
                fieldMap.put(schemaFieldMap.get(str).getDescribe().getLabel(), schemaFieldMap.get(str).getDescribe().getName());        
            }
        }
        return fieldMap;
    }
    
    //returns map of account fields
    @AuraEnabled
    public static Map<String,String> getAccountFields() {
        Set<String> setOfAccFields=new Set<String>{'billinglatitude','name','accountsource','annualrevenue','industry','rating','shippingcity','shippingstate','billingcity','billingstate','shippinglatitude','billinglongitude','shippinglongitude','billingcountry','shippingcountry','type'};
        Map<String,String> fieldMapAccount = new Map<String,String>();
        Map<String, Schema.SObjectField> schemaFieldMapAccount = Schema.SObjectType.Account.fields.getMap();
        for(String str:schemaFieldMapAccount.keyset()){
            String dataType=String.valueOf(schemaFieldMapAccount.get(str).getDescribe().getType()).trim();
            Boolean isFieldValid=(str.contains('__c'))||(setOfAccFields.contains(str));
            if(isFieldValid){
                if(!dataType.equalsIgnoreCase('Date') && !dataType.equalsIgnoreCase('DATETIME') && !dataType.equalsIgnoreCase('AUTONUMBER') && !dataType.equalsIgnoreCase('TEXTAREA') && !schemaFieldMapAccount.get(str).getDescribe().getName().equalsIgnoreCase('Probability') && !schemaFieldMapAccount.get(str).getDescribe().getName().equalsIgnoreCase('StageName') && !schemaFieldMapAccount.get(str).getDescribe().getName().equalsIgnoreCase('Opportunity_Conversion_Probability__c') && !schemaFieldMapAccount.get(str).getDescribe().getName().equalsIgnoreCase('IsClosed') && !schemaFieldMapAccount.get(str).getDescribe().getName().equalsIgnoreCase('IsWon')){
                    fieldMapAccount.put(schemaFieldMapAccount.get(str).getDescribe().getLabel(), schemaFieldMapAccount.get(str).getDescribe().getName());        
                }
            }
        }
        return fieldMapAccount;
    }
    
    //returns map of user fields
    @AuraEnabled
    public static Map<String,String> getUserFields() {
        Set<String> setOfUserFields=new Set<String>{'firstname','street','division','department','userroleid','city','state','country','longitude','latitude'};
        Map<String,String> fieldMapUser = new Map<String,String>();
        Map<String, Schema.SObjectField> schemaFieldMapUser = Schema.SObjectType.User.fields.getMap();
        for(String str:schemaFieldMapUser.keyset()){
            String dataType=String.valueOf(schemaFieldMapUser.get(str).getDescribe().getType()).trim();
            Boolean isFieldValid=(str.contains('__c'))||(setOfUserFields.contains(str));
            if(isFieldValid){
                if(!dataType.equalsIgnoreCase('Date') && !dataType.equalsIgnoreCase('DATETIME') && !dataType.equalsIgnoreCase('AUTONUMBER') && !dataType.equalsIgnoreCase('TEXTAREA') && !schemaFieldMapUser.get(str).getDescribe().getName().equalsIgnoreCase('Probability') && !schemaFieldMapUser.get(str).getDescribe().getName().equalsIgnoreCase('StageName') && !schemaFieldMapUser.get(str).getDescribe().getName().equalsIgnoreCase('Opportunity_Conversion_Probability__c') && !schemaFieldMapUser.get(str).getDescribe().getName().equalsIgnoreCase('Closed') && !schemaFieldMapUser.get(str).getDescribe().getName().equalsIgnoreCase('Won')){
                    fieldMapUser.put(schemaFieldMapUser.get(str).getDescribe().getLabel(), schemaFieldMapUser.get(str).getDescribe().getName());        
                }
            }
        }
        return fieldMapUser;
    }
    
    //returns the configuration record (creates a new blank record if no record is found)
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
    
    //saves the configuration record and calls the model training batch class
    @AuraEnabled
    public static void initiateModelLearning(Boolean isManual,List<String> selectedFields,Delphi_Configuration__c config){
        config.Model_Status__c='Running';
        if(!isManual){
            selectedFields=new List<String>();
            Map<String,String> tempMapOfFields=getOpportunityFields();
            for(String str:tempMapOfFields.keyset()){
                selectedFields.add(tempMapOfFields.get(str));
            }
        }
        update config;
        String fieldsToQuery='';
        for(String str:selectedFields){
            if(fieldsToQuery=='')
                fieldsToQuery=str;
            else
                fieldsToQuery=fieldsToQuery+','+str;
        }
        String query='SELECT Probability,'+fieldsToQuery+' FROM Opportunity where StageName=\'Closed Won\' OR StageName=\'Closed Lost\'';
        DelphiCalloutBatchForTraining d=new DelphiCalloutBatchForTraining(query,selectedFields,'https://delphi-testing.herokuapp.com/FitModel');
        if(!Test.isRunningTest())
            Database.executeBatch(d,1000);
    }
    
    //saves the configuration record and calls the opportunity prediction batch class
    @AuraEnabled
    public static void initiateOpportunityPrediction(){
        Delphi_Configuration__c config=[SELECT Id,Configuration_Type__c,Last_Model_Run__c,Last_Prediction_Run__c,Model_Status__c,Prediction_Status__c,Selected_Fields__c FROM Delphi_Configuration__c LIMIT 1];
        config.Prediction_Status__c ='Running';
        update config;
        Boolean isManual=config.Configuration_Type__c=='Manual'?true:false;
        List<String> selectedFields=new List<String>();
        Delphi_Configuration__c configRecord=[SELECT RFE_Fields__c FROM Delphi_Configuration__c  LIMIT 1];
        selectedFields=configRecord.RFE_Fields__c.trim().split(',');
        String fieldsToQuery='';
        for(String str:selectedFields){
            if(fieldsToQuery=='')
                fieldsToQuery=str;
            else
                fieldsToQuery=fieldsToQuery+','+str;
        }
        String query='SELECT '+fieldsToQuery+' FROM Opportunity where StageName!=\'Closed Won\' AND StageName!=\'Closed Lost\'';
        DelphiCalloutBatchForScoring d=new DelphiCalloutBatchForScoring(query,selectedFields,'https://delphi-testing.herokuapp.com/PredictProbabilities');
        if(!Test.isRunningTest())
            Database.executeBatch(d,1000);
    }    
}