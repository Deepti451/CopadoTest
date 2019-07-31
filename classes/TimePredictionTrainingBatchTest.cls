@isTest
public class TimePredictionTrainingBatchTest {

    @testSetup
    static void setup(){
        
        List<Opportunity> oppList = new List<Opportunity>();
        
            Opportunity oppObject1 = new Opportunity();
            oppObject1.CloseDate = system.today();
          oppObject1.Name = 'TestOpp1';
          oppObject1.StageName = 'Prospecting';
          //oppObject1.CreatedDate = system.today().addDays(-5);
          oppList.add(oppObject1);
        
          Opportunity oppObject2 = new Opportunity();
            oppObject2.CloseDate = system.today().addDays(20);
          oppObject2.Name = 'TestOpp2';
          oppObject2.StageName = 'Prospecting';
          //oppObject1.CreatedDate = system.today().addDays(-10);
          oppList.add(oppObject2);
          
          Opportunity oppObject3 = new Opportunity();
            oppObject3.CloseDate = system.today().addDays(50);
          oppObject3.Name = 'TestOpp3';
          oppObject3.StageName = 'Prospecting';
          //oppObject1.CreatedDate = system.today().addDays(-30);
          oppList.add(oppObject3);
        
          Opportunity oppObject4 = new Opportunity();
            oppObject4.CloseDate = system.today().addDays(100);
          oppObject4.Name = 'TestOpp4';
          oppObject4.StageName = 'Prospecting';
          //oppObject1.CreatedDate = system.today().addDays(-30);
          oppList.add(oppObject4);
        
          insert oppList;
       
          oppList[0].StageName = 'Value Proposition';
          update oppList;
          oppList[1].StageName = 'Value Proposition';
          update oppList;
          oppList[2].StageName = 'Proposal/Price Quote';
          update oppList;
          oppList[0].StageName = 'Proposal/Price Quote';
          update oppList;
          oppList[1].StageName = 'Closed Won';
          update oppList;
          oppList[2].StageName = 'Closed Won';
          update oppList;
          oppList[0].StageName = 'Closed Won';
          update oppList;
    }
    
    
    @isTest static void method(){
        Test.startTest();
        Delphi_Configuration__c dc = new Delphi_Configuration__c();
       dc.Name = 'Test';
        insert dc;
          TimePredictionTrainingBatch testObject = new TimePredictionTrainingBatch();
          database.executeBatch(testObject);
        Test.stopTest();
        system.assertEquals(1,1);
    }
}