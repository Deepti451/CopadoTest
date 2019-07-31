var ChimpSyncGeneralOptions = {
	namespace: 'ChimpSync__',
	version: 'launch',
	timeout: 30000
};

var ChimpSync = {
	//constants
	endpoint: 'https://chimpsync.herokuapp.com/'+ChimpSyncGeneralOptions.version+'/synctime',
	icons: {
		success: '/resource/'+ChimpSyncGeneralOptions.namespace+'FancyboxIM/check.png',
		error: '/resource/'+ChimpSyncGeneralOptions.namespace+'FancyboxIM/cross.png',
		loading: '/resource/'+ChimpSyncGeneralOptions.namespace+'FancyboxIM/fancybox_loading.gif'
	},
	//end of constants
	jsoncallbackCalled: false,
	init: function(timestamp){
		ChimpSyncGeneralOptions.namespace = timestamp+'/';	
	},
	start: function(SF_campaign_id,orgid,mc_campaign_id,campaignName,dateCreated,userEmail,mailchimpList,type,segmentation,subscriberActivity){
		if(type=='new'){
			mc_campaign_id=null;
		}	
		document.getElementById('CS_outer').innerHTML = '<div id="CS_progress"><img src="'+ChimpSync.icons.loading+'"></div>';

		var obj = {
            'sfcmpg': SF_campaign_id,
            'sfid': orgid,            
            'id': mc_campaign_id,
            'campaignName': campaignName,
            'dateCreated': dateCreated,
            'email': userEmail,
            'list': mailchimpList,
            'type':type,
            'segmentation':segmentation,
            'sa':subscriberActivity
        }
		var str = "";
		for (var key in obj) {
		    str += "&";		    
		    str += key + "=" + encodeURIComponent(obj[key]||'');
		}


		var script = document.createElement('script');
		script.src = ChimpSync.endpoint+'?callback=jsoncallback'+str;
		try{
			document.getElementsByTagName('head')[0].appendChild(script);
		}
		catch(err){
			jsoncallback({error:'Unexpected error occured! Please try again.'});
		}
		script.onerror = function() {
		   jsoncallback({error:'Unexpected error occured! Please try again.'});
		}

		//wait for timeout and than throw an error
		this.startTimeout();

	},
	continue: function(SF_campaign_id,orgid,mc_campaign_id,campaignName,dateCreated,userEmail,mailchimpList,segmentation,subscriberActivity){
		var radios = document.getElementsByName('sync_type');
		var type;
		for (var i = 0, length = radios.length; i < length; i++) {
		    if (radios[i].checked) {
		        // do whatever you want with the checked radio
		        type = radios[i].value;
		        // only one radio can be logically checked, don't check the rest
		        break;
		    }
		}
		if(type=='new'){
			segmentation = 'Sxxxxxxx'.replace(/[xy]/g, function(c) {var r = Math.random()*16|0,v=c=='x'?r:r&0x3|0x8;return v.toString(16);});
		}
		if(typeof type!=="undefined"){
			this.start(SF_campaign_id,orgid,mc_campaign_id,campaignName,dateCreated,userEmail,mailchimpList,type,segmentation,subscriberActivity);
		}else{
			alert("Please select an option.");
		}	
	},
	startTimeout: function(){
		setTimeout(function(){
			if(!ChimpSync.jsoncallbackCalled){
				jsoncallback({error:'Timeout occured. Please try again.'});
			}
		},ChimpSyncGeneralOptions.timeout);

	},
	testAppender: ''
}

ChimpSync.init(new Date().getTime());

function jsoncallback(data){		
	if(ChimpSync.jsoncallbackCalled){
		return false;
	}
	else{
		ChimpSync.jsoncallbackCalled = true;
	}
		var csNewVersion = ''; 
		var injectionHTML = '';
		var selectedIcon = '';
		var returnedText = '';
		var chimpsyncPlan = '';
		if(data.new){
			csNewVersion = data.new;
		}
        if (data.error) {
			selectedIcon = ChimpSync.icons.error;
			returnedText = data.error;
		}
		else if (data.success) {
			selectedIcon = ChimpSync.icons.success;
			returnedText = data.success;
		}

		//data plan
		if(data.plan){
			chimpsyncPlan = '<div class="CS_plan">'+
					'<b>Your plan:</b> '+data.plan+'</div>';
		}
		injectionHTML = '<div id="CS_message">'+
				'<div class="CS_new_version CS_css" id="chimpsync-new-version" style="display:none;">'+csNewVersion+'</div>'+
				'<div class="CS_icon_box">'+
					'<img class="CS_icon" src="'+selectedIcon+'" />'+
				'</div>'+
				'<div class="CS_text">'+returnedText+'</div>'+
				'<div class="CS_clear"></div>'+
				'<div style="text-align: center;padding-bottom: 13px;">'+
				'<button style="padding: 3px 13px;background: #c23934;color:white; border: 1px solid #c23934;" onclick="window.location.reload();">Close</button></div>'+
				chimpsyncPlan+
				'<div class="CS_clear CS_errormessage">Contact us for help: <a href="mailto:support@chimpsync.com" class="CS_errormessage_email">support@chimpsync.com</a>'+
				'</div>'+
			'</div>';              

        if(csNewVersion){
        	document.getElementById('chimpsync-new-version').style.display = 'block';
        }		
        document.getElementById('CS_outer').innerHTML = injectionHTML;
}