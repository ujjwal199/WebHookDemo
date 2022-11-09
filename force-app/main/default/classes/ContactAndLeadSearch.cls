public class ContactAndLeadSearch {
    public static  List<List< sObject>> searchContactsAndLeads(String Names)
    {
        List<List< sObject>> LeadConList =[Find : Names IN ALL FIELDS RETURNING Contact(Name), Lead(Name)];
        return LeadConList;
    }

}