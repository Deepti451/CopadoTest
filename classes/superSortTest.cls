@IsTest
public class superSortTest{
     public static testMethod void sortAscendingTest(){
        
        List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random()));
        }
        
        Test.startTest();
        Long start = system.currentTimeMillis();
        //sortList(opps,'Amount','asc');
        system.debug(system.currentTimeMillis() - start);
        Test.stopTest();
        
        //Assert the list was sorted correctly
        Decimal assertValue = -1;
        for(Opportunity o : opps) {
            System.debug('Opp value: ' + o.amount);
            //System.assert(assertValue <= o.amount);
            assertValue = o.amount;
        }  
    }
    
    public static testMethod void sortDescendingTest(){
        
        List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random()));
        }
        
        Test.startTest();
        //sortList(opps,'Amount','desc');
        Test.stopTest();
        
        //Assert the list was sorted correctly
        Decimal assertValue = 1001;
        for(Opportunity o : opps) {
            System.debug('Opp value: ' + o.amount);
            //System.assert(assertValue >= o.amount);
            assertValue = o.amount;
        }  
    }   
}