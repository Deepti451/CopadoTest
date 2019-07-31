({
	doInit:function(component, event, helper) {
        /*
        var locationComponent = window.location.href;
        
        var selectedTab = locationComponent.split("?")[1].split("=")[1];
        
        component.set("v.test",selectedTab);
        */
		var config=component.get("v.configJson");
        var url=window.location.href;
        url=url.substring(0,url.indexOf("lightning/"));
        config={"Configuration_Type__c":"","Base_URL__c":url,"Last_Model_Run__c":"","Last_Prediction_Run__c":"","Model_Status__c":"","Prediction_Status__c":"","Selected_Fields__c":"","Selected_Field_Account__c":"","Selected_Field_User__c":""};
        var action=component.get("c.getWrapperConfigData");
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                var configRec=response.getReturnValue()["configRec"];
                for(var f in configRec){
                    config[f]=configRec[f];
                }
                helper.updateAllFields(component,response.getReturnValue());
                helper.updateSelectedFields(component,config);
            	helper.updateConfiguration(component,response.getReturnValue(),config);
            }
        });
        $A.enqueueAction(action);
	},
    //called when either of the radio buttons is clicked
    checkRadio:function(component,event,helper){
        if(event.getSource().get("v.name")==="radioMan"){
            component.set("v.manualSelect",true);
        }else{
            component.set("v.manualSelect",false);
        }    
    },
    startModelLearning : function(component, event, helper){
        var config=component.get("v.configJson");
        var isManual=component.get("v.manualSelect");
        var selectedFieldsOpp=component.get("v.selectedFieldListOpportunity");
        var selectedFieldsAcc=component.get("v.selectedFieldListAccount");
        var selectedFieldsUser=component.get("v.selectedFieldListUser");
        config["Configuration_Type__c"]="Automatic";
        var selFieldStringOpp="";
        var selFieldStringAcc="";
        var selFieldStringUser="";
        if(isManual==true){
            config["Configuration_Type__c"]="Manual";
            if(selectedFieldsOpp.length==0 || selectedFieldsAcc.length==0 || selectedFieldsUser.length==0){
                alert("Please select atleast one field(s)!");
                return;
            }
            for(var s in selectedFieldsOpp){
                if(selFieldStringOpp=="")
                    selFieldStringOpp=selectedFieldsOpp[s].trim();
                else
                    selFieldStringOpp+=","+selectedFieldsOpp[s].trim();
        	}
            for(var s in selectedFieldsAcc){
                if(selFieldStringAcc=="")
                    selFieldStringAcc=selectedFieldsAcc[s];
                else
                    selFieldStringAcc+=","+selectedFieldsAcc[s];
            }
            for(var s in selectedFieldsUser){
                if(selFieldStringUser=="")
                    selFieldStringUser=selectedFieldsUser[s];
                else
                    selFieldStringUser+=","+selectedFieldsUser[s];
            }
        }
        else{
            var emptyArray=[];
            component.set("v.selectedFieldListOpportunity",emptyArray);
            component.set("v.selectedFieldListAccount",emptyArray);
            component.set("v.selectedFieldListUser",emptyArray);
        }
        config["Selected_Fields__c"]=selFieldStringOpp;
        config["Selected_Field_Account__c"]=selFieldStringAcc;
        config["Selected_Field_User__c"]=selFieldStringUser;
        config["Model_Status__c"]="Running";
        component.set("v.configJson",config);
        if(config["Last_Model_Run__c"]=="" || config["Prediction_Status__c"]=="Running" || config["Model_Status__c"]=="Running"){
        	component.set("v.disablePredBtn",true);
        }else{
            component.set("v.disablePredBtn",false);
        }
        var action=component.get("c.initiateModelLearning");
        action.setParams({
            "isManual":isManual,
            "selectedFields":selectedFieldsOpp,
            "config":config
        });
        action.setCallback(this,function(response){
        	if(response.getState()=="SUCCESS"){
                alert("Model training has been initiated. You will get a notification mail once the process is completed.");
            	window.setTimeout(
                	$A.getCallback(function() {
                    	helper.checkUpdatedConfigData(component,"Model",helper)
                	}), 5000
				);
            }
        });
        $A.enqueueAction(action);
    },
    startPrediction : function(component, event, helper){
       
        var config=component.get("v.configJson");
        config["Prediction_Status__c"]="Running";
        component.set("v.disablePredBtn",true);
        component.set("v.configJson",config);
        var action=component.get("c.initiateOpportunityPrediction");
        action.setCallback(this,function(response){
        	if(response.getState()=="SUCCESS"){
                alert("Opportunity Scoring has been initiated. You will get a notification mail once the process is completed.");
            	window.setTimeout(
                	$A.getCallback(function() {
                    	helper.checkUpdatedConfigData(component,"Prediction",helper)
                	}), 5000
				);
            }
        });
        $A.enqueueAction(action);
    }
})