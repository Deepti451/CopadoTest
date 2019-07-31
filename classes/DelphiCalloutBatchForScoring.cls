global class DelphiCalloutBatchForScoring implements DataBase.Batchable<Sobject>,Database.Stateful {
    global Map<String,Schema.SObjectField> schemaFieldMap=Schema.SObjectType.Opportunity.fields.getMap();
    global List<String> selectedFields;
	global String queryToRun;
    global Integer flag;
    global List<Opportunity> listOfOpps;
    global string urlLinkfield;
    
    
    global DelphiCalloutBatchForScoring(String query,List<String> selFields,String urlLink){
        selectedFields=new List<String>();
        selectedFields.addAll(selFields);
        queryToRun=query;
        listOfOpps=new List<Opportunity>();
        urlLinkfield=urlLink;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
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
            for(String str:selectedFields){
                if(!str.equalsIgnoreCase('Id')  && !str.equalsIgnoreCase('Probability')){
                    String dataType=String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).trim();
                    if(opp.get(str) != null && opp.get(str)!=''){
                        jsonGen.writeObjectField(str,opp.get(str));
                    }else{
                        if(String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).equalsIgnoreCase('Double') || String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).equalsIgnoreCase('Currency')|| String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).equalsIgnoreCase('Decimal') ||String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).equalsIgnoreCase('Number')||String.valueOf(schemaFieldMap.get(str).getDescribe().getType()).equalsIgnoreCase('Percent'))
                        {
                        	jsonGen.writeObjectField(str,decimal.valueof('11000110101011001100000'));
                        }else{
                            jsonGen.writeObjectField(str,'');
                        } 
                    }
                } 
            }
            jsonGen.writeEndObject();
        } 
        jsonGen.writeEndObject();
        jsonGen.writeEndObject();
        System.debug(jsonGen.getAsString());
        if(!Test.isRunningTest())
        	System.enqueueJob(new QueueableCalloutUtility(jsonGen.getAsString(),urlLinkfield));
    }    
}