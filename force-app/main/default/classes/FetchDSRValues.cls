public with sharing class FetchDSRValues {
    
    public static String fetchDSRvalues(String dsrId, String objectName){
        List<dsrWrapper> listWrapper = new List<dsrWrapper>();
        dsrWrapper dsrwrp;
        if(dsrId!='' && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Opportunity.isAccessible()
           && Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Campaign.isAccessible()
           && Schema.sObjectType.bsource__DSR_Account__c.isAccessible() && Schema.sObjectType.bsource__DSR_Campaign__c.isAccessible()
           && Schema.sObjectType.bsource__DSR_Opportunity__c.isAccessible() && Schema.sObjectType.bsource__DSR_Contact__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.isAccessible() 
             && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.isAccessible()
            && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.id.isAccessible()
            && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.Name.isAccessible()
            && Schema.sObjectType.bsource__BS_Deal_Support_Request__c.fields.bsource__BriefingSource_InstanceName__c.isAccessible()
            && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Briefing_Source_Field__c.isAccessible()
               && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Id.isAccessible()
               && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.Name.isAccessible()
               && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Instance_Name__c.isAccessible()
           && Schema.sObjectType.bsource__Briefing_Source_Field_Mapping_Lists__c.fields.bsource__Salesforce_Field__c.isAccessible()
          ){
              
              //Fetch DSR accounts
              List<bsource__DSR_Account__c> dsrRelationsListAccount = [SELECT Id,bsource__Deal_Support_Request__c,bsource__Account__c,
                                                                       bsource__Account__r.Id,bsource__Account__r.Name,bsource__Account__r.Type, 
                                                                       bsource__Account__r.BillingStreet, bsource__Account__r.BillingCity, 
                                                                       bsource__Account__r.BillingState, bsource__Account__r.BillingPostalCode, 
                                                                       bsource__Account__r.BillingCountry, bsource__Account__r.BillingAddress, 
                                                                       bsource__Account__r.Phone, bsource__Account__r.Fax, 
                                                                       bsource__Account__r.AccountNumber, bsource__Account__r.Website, 
                                                                       bsource__Account__r.Industry, bsource__Account__r.AnnualRevenue, 
                                                                       bsource__Account__r.NumberOfEmployees, bsource__Account__r.Ownership,
                                                                       bsource__Account__r.TickerSymbol, bsource__Account__r.Description, 
                                                                       bsource__Account__r.Rating,bsource__Account__r.Site
                                                                       FROM bsource__DSR_Account__c WHERE
                                                                       bsource__Deal_Support_Request__c = :dsrId];
              
              //Fetch DSR Campaigns
              List<bsource__DSR_Campaign__c> dsrRelationsListCampaign = [SELECT Id,bsource__Deal_Support_Request__c,bsource__Campaign__r.Id,
                                                                         bsource__Campaign__r.Name,bsource__Campaign__r.Type,bsource__Campaign__r.Status,bsource__Campaign__r.StartDate,bsource__Campaign__r.EndDate,
                                                                         bsource__Campaign__r.ExpectedRevenue,bsource__Campaign__r.BudgetedCost,bsource__Campaign__r.ActualCost,
                                                                         bsource__Campaign__r.ExpectedResponse,bsource__Campaign__r.NumberSent,bsource__Campaign__r.IsActive,
                                                                         bsource__Campaign__r.Description,bsource__Campaign__r.NumberOfLeads ,bsource__Campaign__r.NumberOfConvertedLeads,
                                                                         bsource__Campaign__r.NumberOfContacts,bsource__Campaign__r.NumberOfResponses,
                                                                         bsource__Campaign__r.NumberOfOpportunities,bsource__Campaign__r.NumberOfWonOpportunities,
                                                                         bsource__Campaign__r.AmountAllOpportunities,bsource__Campaign__r.AmountWonOpportunities
                                                                         FROM bsource__DSR_Campaign__c WHERE
                                                                         bsource__Deal_Support_Request__c = :dsrId];
              
              //Fetch DSR opportunities
              List<bsource__DSR_Opportunity__c> dsrRelationsListOpportunity = [SELECT Id,bsource__Deal_Support_Request__c, bsource__Opportunity__r.Id,
                                                                               bsource__Opportunity__r.Name,bsource__Opportunity__r.account.name,bsource__Opportunity__r.accountId
                                                                               ,bsource__Opportunity__r.amount,bsource__Opportunity__r.Description,bsource__Opportunity__r.StageName,
                                                                               bsource__Opportunity__r.Probability,bsource__Opportunity__r.ExpectedRevenue,bsource__Opportunity__r.TotalOpportunityQuantity 
                                                                               ,bsource__Opportunity__r.CloseDate,bsource__Opportunity__r.Type,bsource__Opportunity__r.NextStep,
                                                                               bsource__Opportunity__r.LeadSource,bsource__Opportunity__r.IsClosed,bsource__Opportunity__r.IsWon 
                                                                               ,bsource__Opportunity__r.ForecastCategory,bsource__Opportunity__r.ForecastCategoryName ,
                                                                               bsource__Opportunity__r.bsource__TrackingNumber__c ,bsource__Opportunity__r.bsource__Previous_Amount__c 
                                                                               FROM bsource__DSR_Opportunity__c WHERE
                                                                               bsource__Deal_Support_Request__c = :dsrId];
              
              //Fetch DSR Contacts
              List<bsource__DSR_Contact__c> dsrRelationsListContact = [SELECT Id,bsource__Deal_Support_Request__c,bsource__Contact__r.Id, 
                                                                       bsource__Contact__r.Name,bsource__Contact__r.FirstName,
                                                                       bsource__Contact__r.Lastname,bsource__Contact__r.Email,bsource__Contact__r.Description
                                                                       ,bsource__Contact__r.Phone,bsource__Contact__r.Title
                                                                       ,bsource__Contact__r.AccountId,bsource__Contact__r.Salutation,bsource__Contact__r.MailingStreet,
                                                                       bsource__Contact__r.MailingCity,bsource__Contact__r.MailingState,bsource__Contact__r.MailingPostalCode
                                                                       ,bsource__Contact__r.MailingCountry,bsource__Contact__r.MailingAddress,bsource__Contact__r.Fax,
                                                                       bsource__Contact__r.HomePhone,bsource__Contact__r.Department,
                                                                       bsource__Contact__r.AssistantName,bsource__Contact__r.LeadSource,bsource__Contact__r.Birthdate
                                                                       ,bsource__Contact__r.PhotoUrl FROM bsource__DSR_Contact__c WHERE
                                                                       bsource__Deal_Support_Request__c = :dsrId];        
              
              //fetch DSR Vlaue Using the DSRID
              List<bsource__BS_Deal_Support_Request__c> dsrvalues=[SELECT Id,name,bsource__BriefingSource_InstanceName__c  From bsource__BS_Deal_Support_Request__c where id=:dsrId];
              //fetch bsource__Briefing_Source_Field_Mapping_Lists__c
              List<bsource__Briefing_Source_Field_Mapping_Lists__c> BsFieldMappingList   =[SELECT Id, Name, bsource__Briefing_Source_Field__c,
                                                                                        bsource__Instance_Name__c, bsource__Salesforce_Field__c 
                                                                                        FROM bsource__Briefing_Source_Field_Mapping_Lists__c Where bsource__Instance_Name__c=:dsrvalues[0].bsource__BriefingSource_InstanceName__c ];
              
            
              //dsrWrapper dsrwrp;			
              List<accountWrapper> accountList = new List<accountWrapper>();
              List<opportunityWrapper> oppList = new List<opportunityWrapper>();
              List<contactWrapper> contactList = new List<contactWrapper>();
              List<campaignWrapper>campaignList = new List<campaignWrapper>();
              List<bssFieldMappingWrapper>  fieldMappingList=new  List<bssFieldMappingWrapper>();
              //     system.debug('dsrRelationsList'+dsrRelationsList);
              //     bssDsrMapping value to wrapper class
                
              for(bsource__Briefing_Source_Field_Mapping_Lists__c bssDsrMapping : BsFieldMappingList){
                        
                    bssFieldMappingWrapper bssfieldMappingwrapperobj= new bssFieldMappingWrapper();
                   
                    if(bssDsrMapping.bsource__Briefing_Source_Field__c != null){
                        bssfieldMappingwrapperobj.BSField=bssDsrMapping.bsource__Briefing_Source_Field__c;      
                    }
                     if(bssDsrMapping.Name != null){
                        bssfieldMappingwrapperobj.Name=bssDsrMapping.Name;
                    }
                     if(bssDsrMapping.bsource__Instance_Name__c != null){
                         bssfieldMappingwrapperobj.InstanceName=bssDsrMapping.bsource__Instance_Name__c;
                    }
                     if(bssDsrMapping.bsource__Salesforce_Field__c != null){
                        bssfieldMappingwrapperobj.SalesforceField=bssDsrMapping.bsource__Salesforce_Field__c;
                    }
                    fieldMappingList.add(bssfieldMappingwrapperobj);
                    
              }
              
              
              for(bsource__DSR_Account__c dsrRel : dsrRelationsListAccount){                              
                  if(dsrRel.bsource__Account__c != null){
                      accountWrapper objAccount = new accountWrapper();
                      objAccount.dsrId = dsrRel.bsource__Deal_Support_Request__c;
                      if(dsrRel!= null && dsrRel.bsource__Account__r!= null){
                          
                          if(dsrRel.bsource__Account__r.Id!=null){
                              objAccount.id = dsrRel.bsource__Account__r.Id;
                          }
                          if(dsrRel.bsource__Account__r.Name!=null){
                              objAccount.Name = dsrRel.bsource__Account__r.Name;
                          }
                          if(dsrRel.bsource__Account__r.Type!=null){
                              objAccount.Type = dsrRel.bsource__Account__r.Type;
                          } 
                          if(dsrRel.bsource__Account__r.BillingStreet!=null){
                              objAccount.BillingStreet = dsrRel.bsource__Account__r.BillingStreet;
                          } 
                          if(dsrRel.bsource__Account__r.BillingCity!=null){
                              objAccount.BillingCity = dsrRel.bsource__Account__r.BillingCity;
                          } 
                          if(dsrRel.bsource__Account__r.BillingState!=null){
                              objAccount.BillingState = dsrRel.bsource__Account__r.BillingState;
                          } 
                          if(dsrRel.bsource__Account__r.BillingPostalCode!=null){
                              objAccount.BillingPostalCode = dsrRel.bsource__Account__r.BillingPostalCode;
                          } 
                          if(dsrRel.bsource__Account__r.BillingCountry!=null){
                              objAccount.BillingCountry = dsrRel.bsource__Account__r.BillingCountry;
                          } 
                          if(dsrRel.bsource__Account__r.Phone!=null){
                              objAccount.Phone = dsrRel.bsource__Account__r.Phone;
                          } 
                          if(dsrRel.bsource__Account__r.Fax!=null){
                              objAccount.Fax = dsrRel.bsource__Account__r.Fax;
                          } 
                          if(dsrRel.bsource__Account__r.AccountNumber!=null){
                              objAccount.AccountNumber = dsrRel.bsource__Account__r.AccountNumber;
                          } 
                          if(dsrRel.bsource__Account__r.Website!=null){
                              objAccount.Website = dsrRel.bsource__Account__r.Website;
                          } 
                          if(dsrRel.bsource__Account__r.Industry!=null){
                              objAccount.Industry = dsrRel.bsource__Account__r.Industry;
                          } 
                          if(dsrRel.bsource__Account__r.AnnualRevenue!=null){
                              objAccount.AnnualRevenue = dsrRel.bsource__Account__r.AnnualRevenue;
                          } 
                          if(dsrRel.bsource__Account__r.NumberOfEmployees!=null){
                              objAccount.NumberOfEmployees = dsrRel.bsource__Account__r.NumberOfEmployees;
                          } 
                          if(dsrRel.bsource__Account__r.Ownership!=null){
                              objAccount.Ownership = dsrRel.bsource__Account__r.Ownership;
                          } 
                          if(dsrRel.bsource__Account__r.TickerSymbol!=null){
                              objAccount.TickerSymbol = dsrRel.bsource__Account__r.TickerSymbol;
                          } 
                          if(dsrRel.bsource__Account__r.Description!=null){
                              objAccount.Description = dsrRel.bsource__Account__r.Description;
                          } 
                          if(dsrRel.bsource__Account__r.Rating!=null){
                              objAccount.Rating = dsrRel.bsource__Account__r.Rating;
                          } 
                          if(dsrRel.bsource__Account__r.Site!=null){
                              objAccount.Site = dsrRel.bsource__Account__r.Site;
                          }
                      }
                      accountList.add(objAccount);
                  }                                
              }
              
              for(bsource__DSR_Opportunity__c dsrRel : dsrRelationsListOpportunity){
                  if(dsrRel.bsource__Opportunity__c != null){
                      opportunityWrapper objOpp = new opportunityWrapper();
                      
                      if(dsrRel.bsource__Deal_Support_Request__c != null){
                          objOpp.dsrId = dsrRel.bsource__Deal_Support_Request__c;
                      }
                      
                      objOpp.id = dsrRel.bsource__Opportunity__r.Id;
                      
                      if(dsrRel.bsource__Opportunity__r.Name != null){
                          objOpp.Name = dsrRel.bsource__Opportunity__r.Name;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.accountId != null){
                          objOpp.accountId = dsrRel.bsource__Opportunity__r.accountId;
                      }
                      if(dsrRel.bsource__Opportunity__r.account.name!= null){
                          objOpp.accountName = dsrRel.bsource__Opportunity__r.account.name;
                      }
                      if(dsrRel.bsource__Opportunity__r.amount!= null){
                          objOpp.oppAmount = dsrRel.bsource__Opportunity__r.amount;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.Description!= null){
                          objOpp.Description = dsrRel.bsource__Opportunity__r.Description;
                      }
                      if(dsrRel.bsource__Opportunity__r.StageName!= null){
                          objOpp.StageName = dsrRel.bsource__Opportunity__r.StageName;
                      }
                      if(dsrRel.bsource__Opportunity__r.Probability!= null){
                          objOpp.Probability = dsrRel.bsource__Opportunity__r.Probability;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.ExpectedRevenue!= null){
                          objOpp.ExpectedRevenue = dsrRel.bsource__Opportunity__r.ExpectedRevenue;
                      }
                      if(dsrRel.bsource__Opportunity__r.TotalOpportunityQuantity!= null){objOpp.TotalOpportunityQuantity = dsrRel.bsource__Opportunity__r.TotalOpportunityQuantity;
                      }
                      if(dsrRel.bsource__Opportunity__r.CloseDate!= null){
                          objOpp.CloseDate = dsrRel.bsource__Opportunity__r.CloseDate;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.Type!= null){ objOpp.Type = dsrRel.bsource__Opportunity__r.Type;
                      }
                      if(dsrRel.bsource__Opportunity__r.NextStep!= null){  objOpp.NextStep = dsrRel.bsource__Opportunity__r.NextStep;
                      }
                      if(dsrRel.bsource__Opportunity__r.LeadSource!= null){ objOpp.LeadSource = dsrRel.bsource__Opportunity__r.LeadSource;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.IsClosed!= null){
                          objOpp.IsClosed = dsrRel.bsource__Opportunity__r.IsClosed;
                      }
                      if(dsrRel.bsource__Opportunity__r.IsWon!= null){
                          objOpp.IsWon = dsrRel.bsource__Opportunity__r.IsWon;
                      }
                      if(dsrRel.bsource__Opportunity__r.ForecastCategory!= null){
                          objOpp.ForecastCategory = dsrRel.bsource__Opportunity__r.ForecastCategory;
                      }
                      
                      if(dsrRel.bsource__Opportunity__r.ForecastCategoryName!= null){
                          objOpp.ForecastCategoryName = dsrRel.bsource__Opportunity__r.ForecastCategoryName;
                      }
                      if(dsrRel.bsource__Opportunity__r.bsource__TrackingNumber__c!= null){  objOpp.TrackingNumber = dsrRel.bsource__Opportunity__r.bsource__TrackingNumber__c;
                      }
                      if(dsrRel.bsource__Opportunity__r.bsource__Previous_Amount__c!= null){  objOpp.PreviousAmount = dsrRel.bsource__Opportunity__r.bsource__Previous_Amount__c;
                      }
                      oppList.add(objOpp);
                  }
              }
              
              for(bsource__DSR_Contact__c dsrRel : dsrRelationsListContact){
                  if(dsrRel.bsource__Contact__c != null){
                      contactWrapper objContact = new contactWrapper();
                      if(dsrRel.bsource__Deal_Support_Request__c!= null){
                          objContact.dsrId = dsrRel.bsource__Deal_Support_Request__c;
                      }
                      if(dsrRel.bsource__Contact__r.Id!= null){
                          objContact.id = dsrRel.bsource__Contact__r.Id;
                      }
                      if(dsrRel.bsource__Contact__r.Name!= null){
                          objContact.Name = dsrRel.bsource__Contact__r.Name;
                      }
                      if(dsrRel.bsource__Contact__r.FirstName!= null){   objContact.firstName = dsrRel.bsource__Contact__r.FirstName;
                      }
                      if(dsrRel.bsource__Contact__r.LastName!= null){
                          objContact.lastName = dsrRel.bsource__Contact__r.LastName;
                      }
                      if(dsrRel.bsource__Contact__r.Email!= null){
                          objContact.email = dsrRel.bsource__Contact__r.Email;
                      }
                      if(dsrRel.bsource__Contact__r.Title!= null){ objContact.job_title = dsrRel.bsource__Contact__r.Title;
                      }
                      if(dsrRel.bsource__Contact__r.Phone!= null){   objContact.phone = dsrRel.bsource__Contact__r.Phone;
                      }
                      if(dsrRel.bsource__Contact__r.Description!= null){  objContact.comments = dsrRel.bsource__Contact__r.Description;
                      }
                      
                      if(dsrRel.bsource__Contact__r.AccountId!= null){
                          objContact.AccountId = dsrRel.bsource__Contact__r.AccountId;
                      }
                      if(dsrRel.bsource__Contact__r.Salutation!= null){ objContact.Salutation = dsrRel.bsource__Contact__r.Salutation;
                      }
                      if(dsrRel.bsource__Contact__r.MailingStreet!= null){ objContact.MailingStreet = dsrRel.bsource__Contact__r.MailingStreet;
                      }
                      
                      if(dsrRel.bsource__Contact__r.MailingCity!= null){  objContact.MailingCity = dsrRel.bsource__Contact__r.MailingCity;
                      }
                      if(dsrRel.bsource__Contact__r.MailingState!= null){  objContact.MailingState = dsrRel.bsource__Contact__r.MailingState;
                      }
                      if(dsrRel.bsource__Contact__r.MailingPostalCode!= null){   objContact.MailingPostalCode = dsrRel.bsource__Contact__r.MailingPostalCode;
                      }
                      
                      if(dsrRel.bsource__Contact__r.MailingCountry!= null){ objContact.MailingCountry = dsrRel.bsource__Contact__r.MailingCountry;
                      }
                      
                      if(dsrRel.bsource__Contact__r.Fax!= null){  objContact.Fax = dsrRel.bsource__Contact__r.Fax;
                      }
                      
                      if(dsrRel.bsource__Contact__r.HomePhone!= null){ objContact.HomePhone = dsrRel.bsource__Contact__r.HomePhone;
                      }
                      
                      if(dsrRel.bsource__Contact__r.Department!= null){  objContact.Department = dsrRel.bsource__Contact__r.Department;
                      }
                      
                      if(dsrRel.bsource__Contact__r.AssistantName!= null){      objContact.AssistantName = dsrRel.bsource__Contact__r.AssistantName;
                      }
                      if(dsrRel.bsource__Contact__r.LeadSource!= null){    objContact.LeadSource = dsrRel.bsource__Contact__r.LeadSource;
                      }
                      if(dsrRel.bsource__Contact__r.Birthdate!= null){ objContact.Birthdate = dsrRel.bsource__Contact__r.Birthdate;
                      }
                      
                      if(dsrRel.bsource__Contact__r.PhotoUrl!= null){ objContact.PhotoUrl = dsrRel.bsource__Contact__r.PhotoUrl;
                      }
                      contactList.add(objContact);
                  }
              }
              
              for(bsource__DSR_Campaign__c dsrRel : dsrRelationsListCampaign){
                  if(dsrRel.bsource__Campaign__c != null){
                      campaignWrapper objCampaign = new campaignWrapper();
                      if(dsrRel.bsource__Deal_Support_Request__c!= null){
                          objCampaign.dsrId = dsrRel.bsource__Deal_Support_Request__c;
                      }
                      if(dsrRel.bsource__Campaign__r.Id!= null){
                          objCampaign.id = dsrRel.bsource__Campaign__r.Id;
                      }
                      if(dsrRel.bsource__Campaign__r.Name!= null){
                          objCampaign.Name = dsrRel.bsource__Campaign__r.Name;
                      }
                      if(dsrRel.bsource__Campaign__r.Type!= null){
                          objCampaign.Type = dsrRel.bsource__Campaign__r.Type;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.Status!= null){
                          objCampaign.Status = dsrRel.bsource__Campaign__r.Status;
                      }
                      if(dsrRel.bsource__Campaign__r.StartDate!= null){     objCampaign.StartDate = dsrRel.bsource__Campaign__r.StartDate;
                      }
                      if(dsrRel.bsource__Campaign__r.EndDate!= null){     objCampaign.EndDate = dsrRel.bsource__Campaign__r.EndDate;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.ExpectedRevenue!= null){   objCampaign.ExpectedRevenue = dsrRel.bsource__Campaign__r.ExpectedRevenue;
                      }
                      if(dsrRel.bsource__Campaign__r.BudgetedCost!= null){     objCampaign.BudgetedCost = dsrRel.bsource__Campaign__r.BudgetedCost;
                      }
                      if(dsrRel.bsource__Campaign__r.ActualCost!= null){   objCampaign.ActualCost = dsrRel.bsource__Campaign__r.ActualCost;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.ExpectedResponse!= null){
                          objCampaign.ExpectedResponse = dsrRel.bsource__Campaign__r.ExpectedResponse;
                      }
                      if(dsrRel.bsource__Campaign__r.NumberSent!= null){
                          objCampaign.NumberSent = dsrRel.bsource__Campaign__r.NumberSent;
                      }
                      if(dsrRel.bsource__Campaign__r.IsActive!= null){
                          objCampaign.IsActive = dsrRel.bsource__Campaign__r.IsActive;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.Description!= null){     objCampaign.Description = dsrRel.bsource__Campaign__r.Description;
                      }
                      if(dsrRel.bsource__Campaign__r.NumberOfLeads!= null){
                          objCampaign.NumberOfLeads = dsrRel.bsource__Campaign__r.NumberOfLeads;
                      }
                      if(dsrRel.bsource__Campaign__r.NumberOfConvertedLeads!= null){
                          objCampaign.NumberOfConvertedLeads = dsrRel.bsource__Campaign__r.NumberOfConvertedLeads;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.NumberOfContacts!= null){
                          objCampaign.NumberOfContacts = dsrRel.bsource__Campaign__r.NumberOfContacts;
                      }
                      if(dsrRel.bsource__Campaign__r.NumberOfResponses!= null){
                          objCampaign.NumberOfResponses = dsrRel.bsource__Campaign__r.NumberOfResponses;
                      }
                      if(dsrRel.bsource__Campaign__r.NumberOfOpportunities!= null){
                          objCampaign.NumberOfOpportunities = dsrRel.bsource__Campaign__r.NumberOfOpportunities;
                      }
                      
                      if(dsrRel.bsource__Campaign__r.NumberOfWonOpportunities!= null){
                          objCampaign.NumberOfWonOpportunities = dsrRel.bsource__Campaign__r.NumberOfWonOpportunities;
                      }
                      if(dsrRel.bsource__Campaign__r.AmountAllOpportunities!= null){
                          objCampaign.AmountAllOpportunities = dsrRel.bsource__Campaign__r.AmountAllOpportunities;
                      }
                      if(dsrRel.bsource__Campaign__r.AmountWonOpportunities!= null){
                          objCampaign.AmountWonOpportunities = dsrRel.bsource__Campaign__r.AmountWonOpportunities;
                      }
                      
                      campaignList.add(objCampaign);
                  }
              }
              dsrwrp = new dsrWrapper();
              dsrwrp.initiatedFrom = objectName;
              dsrwrp.accounts = accountList;
              dsrwrp.opportunities = oppList;
              dsrwrp.contacts = contactList;
              dsrwrp.campaigns = campaignList;
              dsrwrp.versionNumber ='1.59';
              dsrwrp.bssFieldMappings=fieldMappingList;
              listWrapper.add(dsrwrp);
              System.debug('listWrapper'+listWrapper);
              System.debug('serailized'+JSON.serialize(dsrwrp));    
                           System.debug('serailized bssFieldMappings>>>'+JSON.serialize(dsrwrp.bssFieldMappings));        

          } 
        return JSON.serialize(dsrwrp);
    }
    
    public class dsrWrapper{
        public String initiatedFrom{get;set;}
        public List<accountWrapper> accounts {get;set;}
        public List<opportunityWrapper> opportunities {get;set;}
        public List<contactWrapper> contacts {get;set;}
        public List<campaignWrapper> campaigns {get;set;}
         public List<bssFieldMappingWrapper> bssFieldMappings {get;set;}
        public String versionNumber{get;set;}
        
    }
    public class bssFieldMappingWrapper{
        public String Name{get;set;}
        public String BSField{get;set;}
        public String InstanceName{get;set;}
        public String SalesforceField{get;set;}
    }
    public class accountWrapper{
        public String dsrId{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public String Type{get;set;}
        public String BillingStreet{get;set;}
        public String BillingCity{get;set;}
        public String BillingState{get;set;}
        public String BillingPostalCode{get;set;}
        public String BillingCountry{get;set;} public String BillingAddress{get;set;}
        public String Phone{get;set;}
        public String Fax{get;set;}
        public String AccountNumber{get;set;}
        public String Website{get;set;}
        public String Industry{get;set;}
        public Decimal AnnualRevenue{get;set;}
        public Integer  NumberOfEmployees{get;set;}
        public String Ownership{get;set;}
        public String TickerSymbol{get;set;}
        public String Description{get;set;}
        public String Rating{get;set;}
        public String Site{get;set;}
        
    }
    
    public class opportunityWrapper {
        public String dsrId{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public String accountId{get;set;}
        public String accountName{get;set;} 
        public Decimal oppAmount{get;set;} 
        
        public String Description{get;set;}
        public String StageName{get;set;}
        public Decimal Probability{get;set;}
        public Decimal ExpectedRevenue{get;set;}
        public Decimal TotalOpportunityQuantity{get;set;} 
        public date CloseDate{get;set;}
        public String Type{get;set;}
        public String NextStep{get;set;}
        public String LeadSource{get;set;}
        public Boolean  IsClosed{get;set;}
        public Boolean  IsWon{get;set;} 
        
        public String ForecastCategory{get;set;}    
        public String ForecastCategoryName{get;set;}  public String TrackingNumber{get;set;}    public Decimal PreviousAmount{get;set;} 
    }
    
    public class contactWrapper {
        public String dsrId{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String email{get;set;}      public String job_title{get;set;}
        public String phone{get;set;}      public String comments{get;set;}
        
        public String AccountId{get;set;}
        public String Salutation{get;set;}
        public String MailingStreet{get;set;}
        public String MailingCity{get;set;}
        
        public String MailingState{get;set;}
        public String MailingPostalCode{get;set;}
        public String MailingCountry{get;set;}
        
        public String Fax{get;set;}
        public String HomePhone{get;set;}
        
        public String Department{get;set;}
        public String AssistantName{get;set;}
        public String LeadSource{get;set;}    public Date Birthdate{get;set;}    public String PhotoUrl{get;set;}
    }
    
    public class campaignWrapper {
        public String dsrId{get;set;}
        public String id{get;set;}
        public String name{get;set;}        
        public String Type{get;set;}
        public String Status{get;set;} public Date  StartDate{get;set;}   public Date  EndDate{get;set;}
        public Decimal  ExpectedRevenue{get;set;}
        public Decimal  BudgetedCost{get;set;}
        public Decimal  ActualCost{get;set;}
        public Decimal  ExpectedResponse{get;set;}
        public Decimal  NumberSent{get;set;}        
        public Boolean  IsActive{get;set;}
        public String Description{get;set;}
        public Integer  NumberOfLeads{get;set;}        
        public Integer  NumberOfConvertedLeads{get;set;}
        public Integer  NumberOfContacts{get;set;}
        public Integer  NumberOfResponses{get;set;}       
        public Integer  NumberOfOpportunities{get;set;}
        public Integer  NumberOfWonOpportunities{get;set;}
        public Decimal  AmountAllOpportunities{get;set;}
        public Decimal  AmountWonOpportunities{get;set;}
    }
}