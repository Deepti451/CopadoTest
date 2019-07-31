public class QueueableCalloutUtility implements Queueable{
    public String jsonStr;
    public String endPoint;
    public QueueableCalloutUtility(String js,String endPt){
        jsonStr=js;
        endPoint=endPt;
    }
    
    public void execute(QueueableContext qc){
        CalloutUtility.processCalloutToPython(jsonStr,endPoint);
    }
}