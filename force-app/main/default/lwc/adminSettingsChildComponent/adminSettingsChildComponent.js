import { LightningElement, track, wire, api } from 'lwc';
import saveBreifingSourceCredsSetting from '@salesforce/apex/SettingsController.saveBreifingSourceCredsSetting';
import Disconnected from '@salesforce/apex/SettingsController.Disconnected';
import getBriefingSourceInfo from '@salesforce/apex/SettingsController.getBriefingSourceInfo';
import saveContact from '@salesforce/apex/SettingsController.saveContact';
import saveCampaigns from '@salesforce/apex/SettingsController.saveCampaigns';
import getState from '@salesforce/apex/SettingsController.getState';
import setoauthuser from '@salesforce/apex/SettingsController.setoauthuser';
import loadBriefingSourceFieldMapping from '@salesforce/apex/SettingsController.loadBriefingSourceFieldMapping';
import saveBreifingSourceMapping from '@salesforce/apex/SettingsController.saveBreifingSourceMapping';
import restoreMappingDefaults from '@salesforce/apex/SettingsController.restoreMappingDefaults';
import insertCustomSetting from '@salesforce/apex/SettingsController.insertCustomSetting';
import getFields from '@salesforce/apex/SettingsController.getFields';
import { showError } from 'c/lwcUtil';
import { setAvailableFieldsByInstanceName } from 'c/adminSettingDataStore';
// New import created to Insert Helpdesk data
import savehelpdeskdata from '@salesforce/apex/SettingsController.saveHelpDeskData';
import getHelpDeskRecord from '@salesforce/apex/SettingsController.getHelpDeskRecord';
import clearBriefingSourceMapping from '@salesforce/apex/SettingsController.clearBriefingSourceMapping';
// get restoreobject
import restoreobjectmapping from '@salesforce/apex/SettingsController.restoreobjectmapping';

export default class AdminSettingsChildComponent extends LightningElement {

    @track loadedCompletely = false;
    @track readOnly = true;
    @track BriefingSourceSettingsInfo = {};
    @track Connected = false;
    @track isLoading = false;
    @track state;
    @track mappingsMap;
    @track refreshData;
    @track _instancename;
    @track BriefingSourcefields = {};
    @track briefingInstanceName;
    @track message;
    @track variant;
    @track instanceNameErrorMsg;
    @track _isLoaded = true;
    // Assign New restore object variable 15_07_2022
    @track restoreobjectvalue;

    @api
    get instancename() {
        return this._instancename;
    }

    set instancename(value) {
        this._instancename = value;
    }
    get getIsLoaded() {

        return this._isLoaded;
    }
    @api index;
    //extra 
    @track availableFieldsForPassingInPickList;
    connectedCallback() {
        this._isLoaded = true;
      
        getFields({ instanceName: this._instancename })
            .then((result) => {
                //extra
                this.availableFieldsForPassingInPickList = result;
           
                this.loadBriefingSourceFields(this._instancename);

            })
            .catch((err) => {
              
            }).finally(() => {
                this.init();
            })
    }

    // get restoreobject value for restorebutton 15_07_2022
    renderedCallback() {
        restoreobjectmapping({ instanceName: this._instancename })
            .then((result) => {
                //extra
                this.restoreobjectvalue = result;
             

            })
            .catch((err) => {
              
            })
    }


    get disabledInput() {
        return this.Connected == false ? false : true;
    }
     setOauthdata(){
        console.log('setdata-oauth is working');
         setoauthuser()
         .then(data=>{
            console.log('response ',data);
         })
         .catch(error=>{
            showError(this, error, 'SettingsController,setoauthuser');
         })
    }

    init() {
        this.briefingInstanceName = this._instancename;

        const getBriefingSourceInfoPromise = new Promise((resolve, reject) => {
            getBriefingSourceInfo({ InstanceName: this._instancename })
                .then((result) => {
                 
                    if (result != null && result.BriefingSourceSettingsList != null 
                        && result.BriefingSourceSettingsList.bsource__API_Endpoint__c != null &&
                        result.BriefingSourceSettingsList.bsource__API_Username__c != null &&
                        result.BriefingSourceSettingsList.bsource__API_Password__c != null &&
                        result.BriefingSourceSettingsList.bsource__Client_Id__c != null &&
                        result.BriefingSourceSettingsList.bsource__Client_Secret__c != null) {
                        this.BriefingSourceSettingsInfo.bsource__API_Endpoint__c = result.BriefingSourceSettingsList.bsource__API_Endpoint__c;
                        this.BriefingSourceSettingsInfo.bsource__API_Username__c = result.BriefingSourceSettingsList.bsource__API_Username__c;
                        this.BriefingSourceSettingsInfo.bsource__API_Password__c = result.BriefingSourceSettingsList.bsource__API_Password__c;
                        this.BriefingSourceSettingsInfo.bsource__Is_CanvasApp__c = false;
                        this.BriefingSourceSettingsInfo.bsource__Client_Id__c = result.BriefingSourceSettingsList.bsource__Client_Id__c;
                        this.BriefingSourceSettingsInfo.bsource__Client_Secret__c = result.BriefingSourceSettingsList.bsource__Client_Secret__c;
                        this.BriefingSourceSettingsInfo.Name = result.BriefingSourceSettingsList.Name;

                      
                        if (result.BriefingSourceSettingsList.bsource__isConnected__c) {
                            this.Connected = true;
                          
                        }
                    }
                    if (result.ShowContact != null && result.ShowContact.bsource__Show_Contact_Checkbox__c != null) {
                        this.BriefingSourceSettingsInfo.bsource__Show_Contact_Checkbox__c = result.ShowContact.bsource__Show_Contact_Checkbox__c;
                    }
                    if (result != null && result.CampaignIds) {
                        if (result.CampaignIds.bsource__Campaign_Id__c != null) {
                            this.BriefingSourceSettingsInfo.bsource__Campaign_Id__c = result.CampaignIds.bsource__Campaign_Id__c;
                        }
                        if (result.CampaignIds.bsource__Show_Campaign_Checkbox__c != null) {
                            this.BriefingSourceSettingsInfo.bsource__Show_Campaign_Checkbox__c = result.CampaignIds.bsource__Show_Campaign_Checkbox__c;
                        }
                    }
                    this.loadedCompletely = true;
                    resolve();
                })
                .catch((err) => {
                    reject(err);
                });
        });

       
       
        const getStatePromise = new Promise((resolve, reject) => {
            getState()
                .then((result) => { 
                    console.log('test running');
                    this.state = `/services/oauth2/authorize?response_type=code&client_id=3MVG98SW_UPr.JFhOGyUyfetR4zDK3UJPd2jLL148uqD.QQeXkvKZktdENMugBDesyNo.zPcFX0jlzbwvQWER&redirect_uri=https%3A%2F%2Fsfdc.briefingsource.com%2Fauth%2Fcallback&state=${result}`;
                    console.log('check 1');
                   //setoauthuser();
                   
                    resolve();
                })
                .catch((err) => {
                    console.log('check 2');
                    reject(err);
                });
        });

        Promise.all([
                getBriefingSourceInfoPromise,
                getStatePromise,
            ])
            .then(() => {
               console.log('check 1 in then promise');
            }).catch((err) => {
                console.log('check 2 in then promise',ex);
            })
            .finally(() => {
                this.loadedCompletely = true;
            });

    }
    SubmitDetails(event) {
        this.isloading(true);
        let status = this.isInputValid();
        const element = event.target;
       
        if (status) {
            if (element.dataset.name == 'ConnectToBriefingSource') {
               

                saveBreifingSourceCredsSetting({
                        url: this.BriefingSourceSettingsInfo.bsource__API_Endpoint__c,
                        username: this.BriefingSourceSettingsInfo.bsource__API_Username__c,
                        password: this.BriefingSourceSettingsInfo.bsource__API_Password__c,
                        cId: this.BriefingSourceSettingsInfo.bsource__Client_Id__c,
                        cSecret: this.BriefingSourceSettingsInfo.bsource__Client_Secret__c,
                        briefingSourceInstanceName: this.BriefingSourceSettingsInfo.Name
                    })
                    .then((result) => {
                       
                       
                        return insertCustomSetting({ bssJSONString:  JSON.stringify(result), instanceName: this.BriefingSourceSettingsInfo.Name });
                    })

                .then((result) => {
                    
                        this.Connected = true;
                        this.loadBriefingSourceFields(this.BriefingSourceSettingsInfo.Name);
                        //eval("$A.get('e.force:refreshView').fire();");
                        window.location.reload();
                        this.message = 'Successfully connected with BriefingSource.';
                        this.variant = 'success';
                        this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                       
                        this.isloading(false);
                    })
                    .catch((err) => {
                        this.Connected = false;
                        this.BriefingSourceSettingsInfo.bsource__API_Endpoint__c = '';
                        this.BriefingSourceSettingsInfo.bsource__API_Username__c = '';
                        this.BriefingSourceSettingsInfo.bsource__API_Password__c = '';
                        this.BriefingSourceSettingsInfo.bsource__Client_Id__c = '';
                        this.BriefingSourceSettingsInfo.bsource__Client_Secret__c = '';
                        this.BriefingSourceSettingsInfo.Name = '';
                        showError(this, err, 'saveBreifingSourceCredsSetting,insertCustomSetting');
                    })
                    .finally(() => {
                        this.isloading(false);

                    });
            } else if (element.dataset.name == 'SaveContactStep') {
                if (this.Connected) {
                  
                    saveContact({
                            showContactCheckbox: this.BriefingSourceSettingsInfo.bsource__Show_Contact_Checkbox__c,
                            InstanceName: this.briefingInstanceName
                        })
                        .then((result) => {
                            this.message = 'Contact saved.';
                            this.variant = 'success';
                            this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                           
                            this.isloading(false);
                        })
                        .catch((err) => {
                           
                        })
                        .finally(() => {

                            this.isloading(false);
                        });
                } else {
                    this.isloading(false);
                    this.message = 'Please connect with BriefingSource before changing campaigns or contacts.';
                    this.variant = 'error';
                    this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                }
            } else if (element.dataset.name == 'CampaignId') {
                if (this.Connected) {
                    saveCampaigns({
                            showCampaignCheckbox: this.BriefingSourceSettingsInfo.bsource__Show_Campaign_Checkbox__c,
                            campaignIds: this.BriefingSourceSettingsInfo.bsource__Campaign_Id__c,
                            InstanceName: this.briefingInstanceName
                        })
                        .then((result) => {
                            if (result == 'Success') {
                                this.message = 'Campaign saved.';
                                this.variant = 'success';
                                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                            } else if (result == 'Campaign ID entered is not valid. [ID] :') {
                                this.message = 'The provided campaign ID is invalid.';
                                this.variant = 'error';
                                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                            } else {
                                this.message = 'The provided campaign ID is invalid.';
                                this.variant = 'error';
                                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                            }
                          
                            this.isloading(false);
                        })
                        .catch((err) => {
                           
                        })
                        .finally(() => {

                            this.isloading(false);
                        });
                } else {
                    this.isloading(false);
                    this.message = 'Please connect with BriefingSource before changing campaigns or contacts.';
                    this.variant = 'error';
                    this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                }
            }
        } else {
            this.isloading(false);
        }
    }

    handleChange(event) {
      
        this.instanceNameErrorMsg = '';
        const element = event.target;
       
        if (element.type == 'checkbox') {
            this.BriefingSourceSettingsInfo[element.dataset.name] = element.checked;
        } else {
            if (element.dataset.name == 'Name' && element.value.includes(' ')) {
                element.value = element.value.replace(' ', '');
                event.target.value.replace(' ', '');
                this.instanceNameErrorMsg = 'You can not use Space in BriefingSource InstanceName';
            } else if (element.dataset.name == 'Name' && element.value.includes('%')) {
                element.value = element.value.replace('%', '');
                event.target.value.replace('%', '');
                this.instanceNameErrorMsg = 'You can not use % in BriefingSource InstanceName';
            } else if (element.dataset.name == 'Name' && element.value.includes('#')) {
                element.value = element.value.replace('#', '');
                event.target.value.replace('#', '');
                this.instanceNameErrorMsg = 'You can not use # in BriefingSource InstanceName';
            }
           
            this.BriefingSourceSettingsInfo[element.dataset.name] = element.value;
        }
    }
    DisconnectedBriefingSourceHandler() {
        this.isloading(true);
        Disconnected({ InstanceName: this.briefingInstanceName })
            .then((result) => {

                this.dispatchEvent(new CustomEvent('disconnect', { tabName: this.briefingInstanceName }));
                window.location.reload();
            })
            .catch((err) => {
              
            })
            .finally(() => {

            });
    }
    AddBriefingSource(event) {
      
        var TabId = this.lstTabs.length;
        var addbriefing = { Id: TabId, Name: `Tab ${TabId}` };
        this.lstTabs = [...this.lstTabs, addbriefing]

    }
    handelFieldChange(event) {
            this.BriefingSourcefields[event.detail.apiName] = event.detail.detail;
        }
        //extra 
    handlePicklistChange(event) {
       
        if (event.detail.payload.value && event.detail.payload.apiname) {
            this.BriefingSourcefields[event.detail.payload.apiname] = event.detail.payload.value;
        }
    }

    SaveMapping() {
        this.isloading(true);
       
        const data = Object.keys(this.BriefingSourcefields).map(item => {
            return {
                key: item,
                field: this.BriefingSourcefields[item]
            }
        });
       
        saveBreifingSourceMapping({
                briefingSourceFields: data,
                instanceName: this._instancename

            })
            .then((result) => {
                //this.loadBriefingSourceFields(this._instancename);
                this.BriefingSourcefields = {};
              
                this.message = 'Mappings were Saved successfully.';
                this.variant = 'success';
                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
            })
            .catch((err) => {
              
            })
            .finally(() => {
                this.isloading(false);

            });
    }
    loadBriefingSourceFields(instanceName) {
        const promise = new Promise((resolve, reject) => {
            loadBriefingSourceFieldMapping({ InstanceName: instanceName })
                .then((data) => {
                    if (data) {
                        const result = JSON.parse(data);
                        var objArray = [];
                        for (var obj in result) {
                            let second = result[obj];
                            var newObjArray = [];
                            for (let s in second) {
                                let tempVarCopy = {};
                                tempVarCopy.display = second[s].display;
                                tempVarCopy.fieldLabel = second[s].fieldLabel;
                                tempVarCopy.opportunityFieldLabel = second[s].opportunityFieldLabel;
                                tempVarCopy.opportunityFieldName = second[s].opportunityFieldName;
                                tempVarCopy.field = { label: second[s].field.label, name: second[s].field.name
                                ,dataType :  second[s].field.type_formatted};
                                newObjArray.push(tempVarCopy);
                            }
                            // objArray.push({ fieldLabel: obj, ...result[obj]});
                            objArray.push({ fieldLabel: obj, records: newObjArray });
                        }
                      
                        this.mappingsMap = objArray;
                        this.isloading(false);
                      
                    }
                    resolve();
                })
                .catch((err) => {
                   
                    reject(err);
                })
                .finally(() => {
                    this._isLoaded = false;
                });
        });
        return promise;
    }


    restoreDefaults() {
        this.isloading(true);
       
        restoreMappingDefaults({ instanceName: this.briefingInstanceName })
            .then((data) => {
               
                this.loadBriefingSourceFields(this.briefingInstanceName);
                this.message = 'Values Restore Successfully.';
                this.variant = 'success';
                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
            })
            .catch((err) => {
                
            })
            .finally(() => {
                this.isloading(false);
                window.location.reload();
            });
    }


    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }
    isloading(value) {
        this.dispatchEvent(new CustomEvent('loading', { detail: { 'value': value } }));
    }

    // @Deb 
    // New code for Popup Modal and save data in Help desk starts here
    @track isShowModal = false;
    //@track InstanceName; // Instance name is updating from above code 
    @track AccountHelpText;
    @track ContactHelpText;
    @track CampaignHelpText;
    @track OpportunityHelpText;

    //extra 
    @track Helpdesk;
    accountht;
    campaignht;
    contactht;
    opportunityht;

    // Method for calling helpdsek data
    HelpdeskMethod() {
      
        getHelpDeskRecord({ instanceName: this._instancename })
            .then((result) => {
                //extra
                this.Helpdesk = result;
                this.AccountHelpText = this.Helpdesk[0].bsource__Account_Help_Text__c;
                this.ContactHelpText = this.Helpdesk[0].bsource__Contact_Help_Text__c;
                this.CampaignHelpText = this.Helpdesk[0].bsource__Campaign_Help_Text__c
                this.OpportunityHelpText = this.Helpdesk[0].bsource__Opportunity_Help_Text__c;
            })
            .catch((err) => {
              
            })
    }
    showModalBox() {
        this.HelpdeskMethod();
        this.isShowModal = true;
    }

    hideModalBox() {
        this.isShowModal = false;
    }
    handleFieldChange(event) {
        var finalvalue = event.target.name;
        if (finalvalue == 'AccountHelpText') {
            this.AccountHelpText = event.target.value;
        }
        if (finalvalue == 'ContactHelpText') {
            this.ContactHelpText = event.target.value;
        }
        if (finalvalue == 'CampaignHelpText') {
            this.CampaignHelpText = event.target.value;
        }

        if (finalvalue == 'OpportunityHelpText') {
            this.OpportunityHelpText = event.target.value;
        }
    }

    Finalsave() {
            savehelpdeskdata({ inst: this._instancename, acc: this.AccountHelpText, con: this.ContactHelpText, camp: this.CampaignHelpText, Opp: this.OpportunityHelpText })
                .then(result => {
                    this.isShowModal = false;
                    this.message = ' Help Desk data Saved Successfully',
                        this.variant = 'success';
                    this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                    // close the modal after data inserted or updated successfully

                })
                .catch(error => {
                    this.message = ' Error occured: ' + error.body.message,
                        this.variant = 'error';
                    this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                })
                .finally(() => {
                    this.isShowModal = false;
                });


            // }

        }
        // New code for Popup modal and save Helpdesk data ends here 
    clearMappingHandler() {
        this.isloading(true);
           console.log('this.briefingInstanceName >>0',this.briefingInstanceName );
        clearBriefingSourceMapping({ instanceName: this.briefingInstanceName })
            .then((data) => {
               
                this.loadBriefingSourceFields(this.briefingInstanceName);
                this.message = 'Values Deleted Successfully.';
                this.variant = 'success';
                this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
                let options = this.template.querySelectorAll('c-searchable-select');
                for (let i = 0; i < options.length; i++) {
                    options[i].setValues(this.briefingInstanceName);
                }
            })
            .catch((err) => {
               console.log('rejected err');
            })
            .finally(() => {
                console.log('final inside');
                this.isloading(false);
            });
    }
}