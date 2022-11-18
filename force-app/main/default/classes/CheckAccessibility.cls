public with sharing class CheckAccessibility
{
    public static String isAccessible(String fieldstocheck,String sObjectName){
        String Verifiedfields = '';        
        sObjectName = sObjectName.trim();
        try{
            if(sObjectName != null && sObjectName != ''){
                if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                    sObjectType schemaType = Schema.getGlobalDescribe().get(sObjectName) ;
                    Map<String, SObjectField> fieldsMap = schemaType.getDescribe().fields.getMap();
                    if(fieldsMap != null && !fieldsMap.isEmpty()){ 
                        List<String> fieldstocheckList = fieldstocheck.split(',');
                        for(String fieldtoverify : fieldstocheckList){
                            fieldtoverify = fieldtoverify.trim();
                            if(fieldsMap.containsKey(fieldtoverify) && 
                               fieldsMap.get(fieldtoverify).getDescribe().isAccessible() ){
                                   Verifiedfields += fieldtoverify+',';
                               }
                        }
                        if(Verifiedfields!= '')
                            Verifiedfields = Verifiedfields.substring(0, Verifiedfields.length() - 1);
                        return Verifiedfields;
                    }
                }
            }
            return Verifiedfields;
        }catch(Exception e){ System.debug('*************Error'+e.getMessage()+' At Line '+e.getLineNumber()); }
        System.debug('8888888888'+Verifiedfields);
        return Verifiedfields;
    }
    public static Boolean isUpsertable(String fieldstocheck,String sObjectName){
        try{
            sObjectName = sObjectName.trim();
            if(sObjectName != null && sObjectName != ''){
                if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isCreateable() || Schema.getGlobalDescribe().get(sObjectName).getDescribe().isUpdateable() || Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                       sObjectType schemaType = Schema.getGlobalDescribe().get(sObjectName) ;
                       Map<String, SObjectField> fieldsMap = schemaType.getDescribe().fields.getMap();
                       
                       if(fieldsMap != null && !fieldsMap.isEmpty()){
                           
                           List<String> fieldstocheckList = fieldstocheck.split(',');
                           
                           for(String fieldtoverify : fieldstocheckList){
                               
                               fieldtoverify = fieldtoverify.trim();
                               System.debug('***** fieldsMap.containsKey(fieldtoverify)  '+fieldsMap.containsKey(fieldtoverify) );
                               if(fieldsMap.containsKey(fieldtoverify) ){
                                   
                                   if(fieldsMap.get(fieldtoverify).getDescribe().isCreateable() || fieldsMap.get(fieldtoverify).getDescribe().isUpdateable() || fieldsMap.get(fieldtoverify).getDescribe().isAccessible()){
                                          System.debug('****');
                                      }else{
                                          return false;
                                      } 
                               }
                               else{ return false;
                               } 
                           }
                           return true;   
                       }
                   }
            }
        }catch(Exception e){
            System.debug('*************Error'+e.getMessage()+' At Line '+e.getLineNumber());
        }
        return false;
    }
    
    public static Boolean isDeletable(String sObjectName){
        try{
            sObjectName = sObjectName.trim();
            if(sObjectName != null && sObjectName != ''){
                if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isDeletable() || Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                    return true;
                } 
            }
        }catch(Exception e){
            System.debug(' Error --------'+e.getMessage()+'At Line '+e.getLineNumber());
        }
        return false;
    }
    
    public static Boolean isInsertable(String fieldstocheck,String sObjectName){
        try{
            sObjectName = sObjectName.trim();
            if(sObjectName != null && sObjectName != ''){
                if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isCreateable()|| Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                    sObjectType schemaType = Schema.getGlobalDescribe().get(sObjectName) ;
                    Map<String, SObjectField> fieldsMap = schemaType.getDescribe().fields.getMap();
                    if(fieldsMap != null && !fieldsMap.isEmpty()){
                        List<String> fieldstocheckList = fieldstocheck.split(',');
                        for(String fieldtoverify : fieldstocheckList){
                            fieldtoverify = fieldtoverify.trim();
                            if(fieldsMap.containsKey(fieldtoverify) && 
                               fieldsMap.get(fieldtoverify).getDescribe().isCreateable() || fieldsMap.get(fieldtoverify).getDescribe().isAccessible()){                                   
                               }
                            else{
                                return false;
                            } 
                        }
                        return true;   
                    }
                }
            }
        }catch(Exception e){
            System.debug('*************Error'+e.getMessage()+' At Line '+e.getLineNumber());
        }
        return false;
    }
    public static Boolean isUpdateable(String fieldstocheck,String sObjectName){
        try{
            sObjectName = sObjectName.trim();
            if(sObjectName != null && sObjectName != ''){
                if(Schema.getGlobalDescribe().get(sObjectName).getDescribe().isUpdateable()||  Schema.getGlobalDescribe().get(sObjectName).getDescribe().isAccessible()){
                    sObjectType schemaType = Schema.getGlobalDescribe().get(sObjectName) ;
                    Map<String, SObjectField> fieldsMap = schemaType.getDescribe().fields.getMap();
                    if(fieldsMap != null && !fieldsMap.isEmpty()){
                        List<String> fieldstocheckList = fieldstocheck.split(',');
                        for(String fieldtoverify : fieldstocheckList){
                            fieldtoverify = fieldtoverify.trim();
                            if(fieldsMap.containsKey(fieldtoverify) && 
                               fieldsMap.get(fieldtoverify).getDescribe().isUpdateable() || fieldsMap.get(fieldtoverify).getDescribe().isAccessible()){}
                            else{
                                return false;
                            } 
                        }
                        return true;   
                    }
                }
            }
        }catch(Exception e){
            System.debug('*************Error'+e.getMessage()+' At Line '+e.getLineNumber());
        }
        return false;
    } 
}