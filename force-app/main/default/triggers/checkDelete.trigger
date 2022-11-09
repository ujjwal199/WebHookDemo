trigger checkDelete on Contact (before Delete) {
      Profile u = [SELECT Id, Name, Description, UserType FROM Profile where id=:userinfo.getProfileId()];
    if(u.Name	=='System Administrator'){
         System.debug('u>>>'+u);
        for(Contact c: trigger.old){
            c.addError('error');
        }
    }
}