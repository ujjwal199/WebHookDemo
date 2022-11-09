public class batchDemo2 implements Database.Batchable <sObject>{
    public Database.QueryLocator start(DataBase.BatchableContext BC){
        String q= 'Select id from Account';
        return Database.getQueryLocator(q);
    }
    public void execute(Database.BatchableContext BC,List<Account> acc){
        System.debug('acc>>'+acc);
        
    }
    public void Finish (Database.BatchableContext BC){
        System.debug('sakesaahdbh asdtasdnashn gasjddahdudas');
    }
    

}