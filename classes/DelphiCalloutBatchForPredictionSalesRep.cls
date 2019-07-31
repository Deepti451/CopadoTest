global class DelphiCalloutBatchForPredictionSalesRep implements Database.Batchable<sObject>,Database.Stateful{
    global Map<String,Schema.SObjectField> schemaFieldMapOpportunity=Schema.SObjectType.Opportunity.fields.getMap();
    global Map<String,Schema.SObjectField> schemaFieldMapAccount=Schema.SObjectType.Account.fields.getMap();
    global Map<String,Schema.SObjectField> schemaFieldMapUser=Schema.SObjectType.User.fields.getMap();
    global List<Opportunity> listOfOpps;
    global String urlLinkfield;
    global List<String> oppFields;
    global List<String> accountFields;
    global List<String> userFields;
    
    global DelphiCalloutBatchForPredictionSalesRep(String urlLink ){
        String queryFields='';
        Delphi_Configuration__c delphi=[SELECT RFE_Fields__c,Configuration_Type__c,Selected_Field_Account__c,Selected_Fields__c,Selected_Field_User__c FROM Delphi_Configuration__c LIMIT 1];
        oppFields=new List<String>();
        accountFields=new List<String>();
        userFields=new List<String>();
        oppFields=delphi.RFE_Fields__c.split(',');
        if(delphi.Configuration_Type__c=='Manual'){
            //if selection type is manual
            accountFields=delphi.Selected_Field_Account__c.split(',');
            userFields=delphi.Selected_Field_User__c.split(',');
        }else{
            //if selection type is automatic
            accountFields=DelphiController.getAccountFields().values();
            userFields=DelphiController.getUserFields().values();
        }
        listOfOpps=new List<Opportunity>();
        urlLinkfield=urlLink;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String queryFields='';
        String queryToRun='';
        if(oppFields.contains('AccountId'))
            oppFields.remove(oppFields.indexOf('AccountId'));
        if(oppFields.contains('OwnerId'))
            oppFields.remove(oppFields.indexOf('OwnerId'));
        for(String o:oppFields){
            if(queryFields=='')
                queryFields=o;
            else
                queryFields=queryFields+','+o;
        }
        for(String a:accountFields){
            queryFields=queryFields+',Account.'+a;
        }
        for(String u:userFields){
            queryFields=queryFields+',Owner.'+u;
        }
        queryToRun='SELECT '+queryFields+' FROM Opportunity where StageName!=\'Closed Won\' AND StageName!=\'Closed Lost\'';
        return Database.getQueryLocator(queryToRun);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            listOfOpps.add(opp);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        JSONGenerator jsonGen = Json.createGenerator(false);
        jsonGen.writeStartObject(); //to start curly braces
        jsonGen.writeStringField('clientid', UserInfo.getOrganizationId());
        JsonGen.writeFieldName('opportunities'); // to print field name along with colen
        jsonGen.writeStartObject(); // curly braces
        for(Opportunity opp : listOfOpps){
            jsonGen.writeFieldName(opp.Id);
            jsonGen.writeStartObject();
            String prob;
            for(String op:oppFields){
                if(opp.get(op) != null){
                    jsonGen.writeObjectField(op,opp.get(op));
                }else{
                    if(String.valueOf(schemaFieldMapOpportunity.get(op).getDescribe().getType()).equalsIgnoreCase('Double') || String.valueOf(schemaFieldMapOpportunity.get(op).getDescribe().getType()).equalsIgnoreCase('Decimal') || String.valueOf(schemaFieldMapOpportunity.get(op).getDescribe().getType()).equalsIgnoreCase('Currency')||String.valueof(schemaFieldMapOpportunity.get(op).getDescribe().getType()).equalsIgnoreCase('Number')||String.valueof(schemaFieldMapOpportunity.get(op).getDescribe().getType()).equalsIgnoreCase('Percent')){
                        jsonGen.writeObjectField(op,decimal.valueof('11000110101011001100000'));
                    }else{
                        jsonGen.writeObjectField(op,'');
                    } 
                }
            }
            for(String af:accountFields){
                if(opp.getSobject('Account').get(af) != null){
                    jsonGen.writeObjectField('Account.'+af,opp.getSobject('Account').get(af));
                }else{
                    if(String.valueOf(schemaFieldMapAccount.get(af).getDescribe().getType()).equalsIgnoreCase('Double') || String.valueOf(schemaFieldMapAccount.get(af).getDescribe().getType()).equalsIgnoreCase('Decimal') || String.valueOf(schemaFieldMapAccount.get(af).getDescribe().getType()).equalsIgnoreCase('Currency')||String.valueOf(schemaFieldMapAccount.get(af).getDescribe().getType()).equalsIgnoreCase('Number')||String.valueOf(schemaFieldMapAccount.get(af).getDescribe().getType()).equalsIgnoreCase('Percent')){
                        jsonGen.writeObjectField('Account.'+af,decimal.valueof('11000110101011001100000'));
                    }else{
                        jsonGen.writeObjectField('Account.'+af,'');
                    } 
                }
            }
            for(String uf:userFields){
                if(opp.getSobject('Owner').get(uf) != null){
                    jsonGen.writeObjectField('Owner.'+uf,opp.getSobject('Owner').get(uf));
                }else{
                    if(String.valueOf(schemaFieldMapUser.get(uf).getDescribe().getType()).equalsIgnoreCase('Double') || String.valueOf(schemaFieldMapUser.get(uf).getDescribe().getType()).equalsIgnoreCase('Decimal') || String.valueOf(schemaFieldMapUser.get(uf).getDescribe().getType()).equalsIgnoreCase('Currency')||String.valueOf(schemaFieldMapUser.get(uf).getDescribe().getType()).equalsIgnoreCase('Number')||String.valueOf(schemaFieldMapUser.get(uf).getDescribe().getType()).equalsIgnoreCase('Percent')){
                        jsonGen.writeObjectField('Owner.'+uf,decimal.valueof('11000110101011001100000'));
                    }else{
                        jsonGen.writeObjectField('Owner.'+uf,'');
                    } 
                }
            }
           jsonGen.writeEndObject();
        }
        System.debug(jsonGen.getAsString());
        if(!Test.isRunningTest())
            System.enqueueJob(new QueueableCalloutUtility(jsonGen.getAsString(),urlLinkfield));
    }
}