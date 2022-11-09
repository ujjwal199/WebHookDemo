trigger CaseOrigin on Case (before insert) {
    for(Case c:trigger.new){
        if(c.Origin=='Email')
        {
            c.Status='New';
            c.Priority='Medium';
        }
    }

}