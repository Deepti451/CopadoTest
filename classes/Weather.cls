public with sharing class Weather{

    public Weather_Histories__c weatherHistory{get; set;}    
    public List<weatherRecords> WeathersList{get; set;}
    public Boolean renderWeatherRecords{get; set;}
    
    public Weather() {
        weatherHistory = new Weather_Histories__c();
    }
    public List<weatherRecords> getAWeathersList() {
        return WeathersList;

    }
        
    public void getWeatherHistory(){
        renderWeatherRecords = false;
        if(weatherHistory != null && weatherHistory.City_Name__c != null && weatherHistory.City_Name__c != '' && weatherHistory.Start_Date__c != null && weatherHistory.End_Date__c != null && convrtDtToUnx(weatherHistory.Start_Date__c) != null && convrtDtToUnx(weatherHistory.End_Date__c) != null){
            try{
                String startUnixTime = convrtDtToUnx(weatherHistory.Start_Date__c);
                String endUnixTime = convrtDtToUnx(weatherHistory.End_Date__c);
                System.debug('startUnixTime: '+startUnixTime+'endUnixTime: '+endUnixTime);
                String weatherGetUrl = 'http://api.openweathermap.org/data/2.5/history/city?q='+weatherHistory.City_Name__c+'&start='+startUnixTime+'&end='+endUnixTime;
                HttpResponse httpRes = getInfoFromOpenWeathermap(weatherGetUrl);
                String res = httpRes.getBody();
                weatherHistoryProcess(res);
            }catch(exception ee){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
            }
        }else{
            String errorMsg = 'Please fill all required fields';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
        }
    }
    
    public void weatherHistoryProcess(String res){
       try{
            Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(res);
            if(root.get('list') != null && root.get('list') != ''){
                List<Object> weathers = (List<Object>)root.get('list');
                WeathersList = new List<weatherRecords>();
                for(object record: weathers){
                    Map<String, Object> obj = (Map<String, Object>)record;
                    if(obj.get('dt') != null && obj.get('weather') != null && obj.get('main') != null && obj.get('wind') != null){
                        weatherRecords wR = new weatherRecords();
                        wR.Dtime = convrtUnxToDt(integer.valueof(obj.get('dt')));
                        
                        List<Object> weatherList = (List<Object>)obj.get('weather');
                        Map<String, Object> main = (Map<String, Object>)obj.get('main');
                        Map<String, Object> wind = (Map<String, Object>)obj.get('wind');
                        
                        if(weatherList != null && weatherList.size() != 0 && main.get('temp') != null && main.get('temp_min') != null && main.get('temp_max') != null && main.get('pressure') != null && main.get('humidity') != null && wind.get('speed') != null){
                            Map<String, Object> weather = (Map<String, Object>)weatherList[0];
                            if(weather.get('icon') != null && weather.get('description') != null){
                                wR.weatherIcon = String.valueof(weather.get('icon'));
                                wR.weatherDescription = String.valueof(weather.get('description'));
                            
                                wR.temperature = Decimal.valueof(String.valueof(main.get('temp'))) - 273.15;
                                wR.minTemp = Decimal.valueof(String.valueof(main.get('temp_min'))) - 273.15;
                                wR.maxTemp = Decimal.valueof(String.valueof(main.get('temp_max'))) - 273.15;
                                wR.pressure = Decimal.valueof(String.valueof(main.get('pressure')));
                                wR.humidity = Decimal.valueof(String.valueof(main.get('humidity')));
                            
                                wR.airSpeed = Decimal.valueof(String.valueof(wind.get('speed')));
                                WeathersList.add(wR);
                            }
                        }
                        
                    }
                }
                renderWeatherRecords = true;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records to display for CIty: '+weatherHistory.City_Name__c));
            }
        }catch(exception ee){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
        }
    }
    
    public PageReference renderPdf(){
            Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=WeatherHistories.pdf');
            PageReference pageRef = new PageReference('/apex/ExportToPdf');
            pageRef.setRedirect(false);
            return pageRef;
    }
    
    public pageReference save(){
        try{
            if(validate(weatherHistory) == true)
            {
                insert weatherHistory;
                if(WeathersList.size() > 0){
                    List<Weathers__c> weathers = new List<Weathers__c>();
                    for(weatherRecords record : WeathersList){
                        Weathers__c wether = new Weathers__c();
                        wether.Weather__c = weatherHistory.Id;
                        wether.Time__c = record.Dtime;
                        wether.Weather_Description__c = record.weatherDescription;
                        wether.Temperature__c = String.Valueof(record.temperature)+'°C';
                        wether.Min_Temperature__c = record.minTemp; 
                        wether.Max_Temperature__c = record.maxTemp; 
                        wether.Pressure_hPa__c = record.pressure; 
                        wether.Humidity__c = record.humidity; 
                        wether.Air_Speed__c = record.airSpeed;
                        weathers.add(wether);
                    }
                    if(weathers.size() > 0){
                        insert weathers;
                        String returnUrl = '/'+weatherHistory.Id;
                        PageReference pageRef = new PageReference(returnUrl);
                        pageRef.setRedirect(true);
                        return pageRef; 
                    }
                }
            }
        }catch(exception ee){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
        }
        return null;    
    }
    
    public Boolean validate(Weather_Histories__c WH){
        Boolean valid = true;
        if(WH.City_Name__c == null || WH.City_Name__c == ''){
            valid  = false;
            WH.City_Name__c.addError('Required field');
        }
        if(WH.Start_Date__c  == null){
            valid  = false;
            WH.Start_Date__c.addError('Required field');
        }
        if(WH.End_Date__c   == null){
            valid  = false;
            WH.End_Date__c.addError('Required field');
        }
        return valid;
    }   
    
    //Get Info From "OpenWeathermap" external service. 
    public static HttpResponse getInfoFromOpenWeathermap(String strUrl) {
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(strUrl);   
            req.setTimeOut(120000);    
            req.setMethod('GET');
            Http h = new Http();
            HttpResponse res = h.send(req);
            return res;
        }catch(exception ee){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
            return null;
        }
    }
    
    //Converting DateTime to Unix time-stamp
    public String convrtDtToUnx(DateTime dateTimeNow){
        try{
            String unixTime = ''+dateTimeNow.getTime()/1000;
            return unixTime;
        }catch(exception ee){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
            return null;
        }
    }
    
    //Converting Unix time-stamp to DateTime
    public DateTime convrtUnxToDt(Integer unixTime){
        try{
            DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
            String dateTimeValue = dateInstance.addSeconds(unixTime).format();
            DateTime dt = DateTime.parse(dateTimeValue);
            return dt;
        }catch(exception ee){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ee.getMessage()));
            return null;
        }    
    }        
    public class weatherRecords{
        public DateTime Dtime{get; set;}
        public String weatherIcon{get; set;}
        public String weatherDescription{get; set;}
        public Decimal temperature{get; set;}
        public Decimal minTemp{get; set;}
        public Decimal maxTemp{get; set;}
        public Decimal pressure{get; set;}
        public Decimal airSpeed{get; set;}
        public Decimal humidity{get; set;}
    }
}