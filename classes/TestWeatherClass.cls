@IsTest
 public with sharing class TestWeatherClass{
     public static testmethod void TestWeatherMethod() {
         Weather weat = new Weather();
         
         weat.validate(weat.weatherHistory);
         weat.convrtUnxToDt(1233);
         weat.weatherHistory = new Weather_Histories__c(City_Name__c = 'Gurgaon', Start_Date__c = DateTime.newInstance(2014, 10, 25, 4, 1, 2), End_Date__c =DateTime.newInstance(2014, 10, 25, 4, 1, 2));  
         weat.getWeatherHistory();
         weat.weatherHistoryProcess('{"message":"","cod":"200","city_id":1273294,"calctime":0.5067,"cnt":36,"list":[{"main":{"temp":305.15,"pressure":1012,"humidity":35,"temp_min":305.15,"temp_max":305.15},"wind":{"speed":1.5,"deg":160},"clouds":{"all":0},"weather":[{"id":721,"main":"Haze","description":"haze","icon":"50d"}],"dt":1414142521}]}');
         weat.getAWeathersList();
         weat.convrtDtToUnx(DateTime.newInstance(2014, 10, 25, 4, 1, 2));
         weat.convrtUnxToDt(1412158900);
         weat.save();
         weat.renderPdf();
     }
}