({
    fetchPredictedOpportunities:function(cmp){
		var action=cmp.get("c.getPredictedOpportunities");
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                var listOfOpps=response.getReturnValue()["oppList"];
                var userMap=response.getReturnValue()["userMap"];
                var configData=response.getReturnValue()["config"];
                if(configData["Prediction_Status__c"]=="Not Started"){
                    cmp.set("v.ShowPredictionStatus",true);
                }
                if(configData["Time_Prediction_Status__c"]=="Running" || configData["Prediction_Status__c"]=="Running"){
                	cmp.set("v.processComplete",false);    
                }
                if(configData["Time_Prediction_Status__c"]=="Failure"){
                    cmp.set("v.timePredictionSuccess",false);
                }
                cmp.set("v.userMap",userMap);
                var totalCount=listOfOpps.length;
                cmp.set("v.totalCount",totalCount);
                if(totalCount%10==0){
                    cmp.set("v.totalNoOfPages",totalCount/10);
                }else{
                    cmp.set("v.totalNoOfPages",Math.round(totalCount/10));
                }
                if(cmp.get("v.totalNoOfPages")>1)
                    cmp.set("v.disableNext",false);
                for(var l in listOfOpps){
                    var probabilityValue=parseFloat(listOfOpps[l]["Opportunity_Conversion_Probability__c"])*100;
                    if(probabilityValue<0.0001)
                        probabilityValue=0.0000;
                    listOfOpps[l]["Opportunity_Conversion_Probability__c"]=probabilityValue.toPrecision(4);
                	var salesRepIdList=[];
                    if(listOfOpps[l]["Sales_Rep_Recommendation__c"] != undefined)
	                    salesRepIdList=listOfOpps[l]["Sales_Rep_Recommendation__c"].split(",");
                    var salesRepList=[];
                    for(var s in salesRepIdList){
                        salesRepList.push(userMap[salesRepIdList[s]]);
                    }
                    listOfOpps[l]["Ranking"]=parseInt(l)+1;
                    listOfOpps[l]["SalesReps"]=salesRepList;
                }
                cmp.set("v.listOfOpportunities",listOfOpps);
                var listOfOppsToShow=[];
                for(var i=0;i<10;i++){
                    listOfOppsToShow.push(listOfOpps[i]);
                }
                cmp.set("v.listOfOpportunitiesToShow",listOfOppsToShow);
            }
        });
        $A.enqueueAction(action);
	},
    
    changePages:function(cmp){
        var offset=cmp.get("v.offset");
        var pageSize=cmp.get("v.pageSize");
        if(typeof(pageSize)!="number")
        	pageSize=parseInt(pageSize.trim());
        if(typeof(offset)!="number")
        	offset=parseInt(offset.trim());
        var listOfOpps=cmp.get("v.listOfOpportunities");
        var listOfOppsToShow=[];
        for(var i=offset;i<(offset+pageSize);i++){
            if(listOfOpps[i]!=undefined){
                listOfOppsToShow.push(listOfOpps[i]);
            }
        }
        cmp.set("v.listOfOpportunitiesToShow",listOfOppsToShow);
    }
})