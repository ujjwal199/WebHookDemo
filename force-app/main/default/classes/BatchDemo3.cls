public class BatchDemo3 implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='Select LastName From Contact ';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Contact> conlist){
        for(Contact c:conlist){
            System.debug('conlist last name>>'+c.LastName);
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('finished');
    }        

}