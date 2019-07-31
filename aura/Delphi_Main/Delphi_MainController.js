({
	doInit:function(component,event,helper) {
        component.set("v.offset",0);
        component.set("v.pageSize",10);
        helper.fetchPredictedOpportunities(component);
    },
    
    changePageSize:function(component,event,helper){
        component.set("v.disablePrev",true);
        component.set("v.currentPage",1);
        component.set("v.offset",0);
        component.set("v.goToPage","");
        var totalCount=component.get("v.totalCount");
        var pageSize=parseInt(component.get("v.pageSize"));
        if(totalCount<=pageSize)
            component.set("v.disableNext",true);
        else
            component.set("v.disableNext",false);
        if(totalCount%component.get("v.pageSize")==0){
            component.set("v.totalNoOfPages",totalCount/component.get("v.pageSize"));
        }else{
            component.set("v.totalNoOfPages",Math.round((totalCount/component.get("v.pageSize"))));
        }
        helper.changePages(component);
    },
    
    changePage:function(component,event,helper){
        var pageToGo=parseInt(component.get("v.goToPage"));
        var totalPages=parseInt(component.get("v.totalNoOfPages"));
        var pageSize=parseInt(component.get("v.pageSize"));
        if(pageToGo>totalPages){
            alert("Number too large");
            return;
    	}
        if(pageToGo<1){
            alert("Number too small");
            return;
        }
        component.set("v.disablePrev",false);
        component.set("v.disableNext",false);
        if(component.get("v.totalNoOfPages")==pageToGo){
            component.set("v.disableNext",true);
            component.set("v.disablePrev",false);
        }
        if(pageToGo==1){
        	component.set("v.disablePrev",true);
            component.set("v.disableNext",false);
    	}
    	component.set("v.offset",(pageToGo-1)*pageSize);
        component.set("v.currentPage",pageToGo);
        helper.changePages(component);
    },
    
    nextPage:function(component,event,helper){
        var offset=parseInt(component.get("v.offset"));
        var pageSize=parseInt(component.get("v.pageSize"));
        var currentPage=component.get("v.currentPage");
        currentPage=parseInt(currentPage)+1;
        if(component.get("v.totalNoOfPages")==currentPage)
            component.set("v.disableNext",true);
        if(currentPage!=1)
        	component.set("v.disablePrev",false);
        component.set("v.currentPage",currentPage);
	    offset=offset+pageSize;
        component.set("v.offset",offset);
        helper.changePages(component);
    },
    
    prevPage:function(component,event,helper){
        var offset=parseInt(component.get("v.offset"));
        var pageSize=parseInt(component.get("v.pageSize"));
        var currentPage=component.get("v.currentPage");
        currentPage=parseInt(currentPage)-1;
        if(component.get("v.totalNoOfPages")!=currentPage)
            component.set("v.disableNext",false);
        if(currentPage==1)
        	component.set("v.disablePrev",true);
        component.set("v.currentPage",currentPage);
        offset=offset-pageSize;
        component.set("v.offset",offset);
        helper.changePages(component);
    }
})