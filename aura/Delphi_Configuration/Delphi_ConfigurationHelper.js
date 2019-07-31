({
    checkUpdatedConfigData:function(cmp,source,help){
        var action=cmp.get("c.getWrapperConfigData");
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                var isChanged=false;
                var config=cmp.get("v.configJson");
                var updatedConfig=response.getReturnValue()["configRec"];
                var modelOppCount=response.getReturnValue()["modelOppCount"];
                var predOppCount=response.getReturnValue()["predOppCount"];
                cmp.set("v.modelOppCount",modelOppCount);
                cmp.set("v.predOppCount",predOppCount);
                var modelStatus=updatedConfig["Model_Status__c"];
                if(modelStatus=="Success" || modelStatus=="Failure"){
                    if(source=="Model")
                        isChanged=true;
                    config["Model_Status__c"]=modelStatus;
                    config["Last_Model_Run__c"]=updatedConfig["Last_Model_Run__c"];
                }
                var timePredStatus=updatedConfig["Time_Prediction_Status__c"];
                var predStatus=updatedConfig["Prediction_Status__c"];
                if((predStatus=="Success" || predStatus=="Failure")&&(timePredStatus=="Success" || timePredStatus=="Failure")){
                    if(source=="Prediction")
                        isChanged=true;
                    config["Prediction_Status__c"]=predStatus;
                    config["Time_Prediction_Status__c"]=timePredStatus;
                    config["Last_Prediction_Run__c"]=updatedConfig["Last_Prediction_Run__c"];
                }
                if(!isChanged){
                    window.setTimeout(
                        $A.getCallback(function() {
                            help.checkUpdatedConfigData(cmp,source,help)
                        }), 5000
                    );
                }else{
                    alert("Processing complete!");
                }
                if(config["Last_Model_Run__c"]=="" || config["Prediction_Status__c"]=="Running" || config["Model_Status__c"]=="Running"){
                    cmp.set("v.disablePredBtn",true);
                }else{
                    cmp.set("v.disablePredBtn",false);
                }
                cmp.set("v.configJson",config);
            }else{
                alert("An error occurred!");
            }
        });
        $A.enqueueAction(action);
    },
    
    updateSelectedFields:function(cmp,config){
        //For Opportunity fields
        var selFldsOpp=config["Selected_Fields__c"];
        var selectedFldsOpp=cmp.get("v.selectedFieldListOpportunity");
        if(selFldsOpp.length>0){
            for(var d in selFldsOpp.split(",")){
                selectedFldsOpp.push(selFldsOpp.split(",")[d]);
            }
            cmp.set("v.selectedFieldListOpportunity",selectedFldsOpp);
        }
        
        //For Account fields
        var selFldsAccount=config["Selected_Field_Account__c"];
        var selectedFldsAccount=cmp.get("v.selectedFieldListAccount");
        if(selFldsAccount.length>0){
            for(var d in selFldsAccount.split(",")){
                selectedFldsAccount.push(selFldsAccount.split(",")[d]);
            }
            cmp.set("v.selectedFieldListAccount",selectedFldsAccount);
        }
        
        //For User fields
        var selFldsUser=config["Selected_Field_User__c"];
        var selectedFldsUser=cmp.get("v.selectedFieldListUser");
        if(selFldsUser.length>0){
            for(var d in selFldsUser.split(",")){
                selectedFldsUser.push(selFldsUser.split(",")[d]);
            }
            cmp.set("v.selectedFieldListUser",selectedFldsUser);
        }
    },
    
    updateAllFields:function(cmp,responseObj){
        //For Opportunity fields
        var fieldMapOpportunity=responseObj["mapOfFieldsOpportunity"];
        var showFieldsOpportunity=cmp.get("v.fieldListToShowOpportunity");
        for(var f in fieldMapOpportunity){
            showFieldsOpportunity.push({
                label:f,
                value:fieldMapOpportunity[f]
            });
        }
        cmp.set("v.fieldListToShowOpportunity",showFieldsOpportunity);
        
        //For Account fields
        var fieldMapAccount=responseObj["mapOfFieldsAccount"];
        var showFieldsAccount=cmp.get("v.fieldListToShowAccount");
        for(var f in fieldMapAccount){
            showFieldsAccount.push({
                label:f,
                value:fieldMapAccount[f]
            });
        }
        cmp.set("v.fieldListToShowAccount",showFieldsAccount);
        
        //For User fields
        var fieldMapUser=responseObj["mapOfFieldsUser"];
        var showFieldsUser=cmp.get("v.fieldListToShowUser");
        for(var f in fieldMapUser){
            showFieldsUser.push({
                label:f,
                value:fieldMapUser[f]
            });
        }
        cmp.set("v.fieldListToShowUser",showFieldsUser);
    },
    
    updateConfiguration:function(cmp,responseObj,config){
        //Updating the opportunity count on buttons
        var modelOppCount=responseObj["modelOppCount"];
        var predOppCount=responseObj["predOppCount"];
        cmp.set("v.modelOppCount",modelOppCount);
        cmp.set("v.predOppCount",predOppCount);
        
        //Handling the disabling of prediction button
        if(config["Last_Model_Run__c"]=="" || config["Prediction_Status__c"]=="Running" || config["Model_Status__c"]=="Running"){
            cmp.set("v.disablePredBtn",true);
        }else{
            cmp.set("v.disablePredBtn",false);
        }
        
        //Setting the radio buttons for selection
        if(config["Configuration_Type__c"]=="Automatic"){
            cmp.set("v.manualSelect",false);
        }else if(config["Configuration_Type__c"]=="Manual"){
            cmp.set("v.manualSelect",true);
        }
        cmp.set("v.configJson",config);
    }
})