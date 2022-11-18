import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveAccountDSRRecords from '@salesforce/apex/CreateDSRRelations.saveAccountDSRRecords';
import saveOpptyDSRRecords from '@salesforce/apex/CreateDSRRelations.saveOpptyDSRRecords';
import saveContactDSRRecords from '@salesforce/apex/CreateDSRRelations.saveContactDSRRecords';
import saveCampaignDSRRecords from '@salesforce/apex/CreateDSRRelations.saveCampaignDSRRecords';
import { NavigationMixin } from 'lightning/navigation';
// get instancename records
import getHelpDeskRecord from '@salesforce/apex/CreateDSRRelations.getHelpDeskRecord';

export default class SelectDsrRelations extends NavigationMixin(LightningElement) {
    @track selectedStep = 'selAccount';
    @track selectedStepOppty = 'selOppty';
    @track listAccountId = '';
    @track listOpptyId = '';
    @track listContactId = '';
    @track listCampaignId = '';
    @track isSelectStepCampaign = false;
    @track hideBack = false;
    @api objectname;
    @api opptyaccount;
    @api recordname;
    @api recid;
    @api opptyFlow = 'Opportunity';
    @api accountFlow = 'Account';
    @api dsrid;
    @api campaignadmin;
    @api campaignAdminPresent = 'Present';
    @api hidecontact; // we are not use this var
    @api hideContactCheck; // we are not use this var
    @track togglerFix = false;
    @track togglerFixForOpp = false;
    @api showcontact;
    @api vfpageflow;
    @api instancename;

    // @Deb
    // Extra code for show help desk data starts here
    // Extra code added for Helpdesk section visible and hide 14_07_2022
    @track accountdetails = false;
    @track campaigndetails = false;
    @track contactdetails = false;
    @track opportunitydetails = false;

    @track Helpdesk;
    accountht;
    campaignht;
    contactht;
    opportunityht;
    connectedCallback() {
            console.log('test');
            console.log('vfpageflow', this.vfpageflow);
            this.ShowAccount();
        }
        //  Code to Show helpdesk records
    ShowAccount() {
            console.log('instancename from getHelpdeskrecord : ', this.instancename);
            getHelpDeskRecord({ instanceName: this.instancename })
                .then((result) => {
                    //extra
                    this.Helpdesk = result;
                    console.log('Helpdesk records', result);
                    console.log('AccountHelpText before convert:', this.Helpdesk[0].bsource__Account_Help_Text__c);
                    this.accountht = this.Helpdesk[0].bsource__Account_Help_Text__c;
                    // Extra code added for Helpdesk section visibilty and hide 14_07_2022
                    if (this.accountht != undefined || this.accountht != null) {
                        this.accountdetails = true;
                        console.log('accountht : ', this.accountht);
                        console.log('account deatils : ', this.accountdetails);

                    }
                    //this.accountht.replace('/(<([^>]+)>)/ig', '');
                    //var input = this.Helpdesk[0].bsource__Account_Help_Text__c;
                    //this.accountht = input.replaceAll('<[/a-zAZ0-9]*>', '');
                    console.log('CampaignHelpText :', this.Helpdesk[0].bsource__Campaign_Help_Text__c);
                    this.campaignht = this.Helpdesk[0].bsource__Campaign_Help_Text__c
                        // Extra code added for Helpdesk section visibilty and hide 14_07_2022
                    if (this.campaignht != undefined || this.campaignht != null) {
                        this.campaigndetails = true;
                        console.log('campaignht : ', this.campaignht);
                        console.log('campaign deatils : ', this.campaigndetails);
                    }
                    console.log('ContactHelpText :', this.Helpdesk[0].bsource__Contact_Help_Text__c);
                    this.contactht = this.Helpdesk[0].bsource__Contact_Help_Text__c;
                    // Extra code added for Helpdesk section visibilty and hide 14_07_2022
                    if (this.contactht != undefined || this.contactht != null) {
                        this.contactdetails = true;
                        console.log('contactht : ', this.contactht);
                        console.log('contact deatils : ', this.contactdetails);
                    }
                    console.log('OpportunityHelpText :', this.Helpdesk[0].bsource__Opportunity_Help_Text__c);
                    this.opportunityht = this.Helpdesk[0].bsource__Opportunity_Help_Text__c;
                    // Extra code added for Helpdesk section visibilty and hide 14_07_2022
                    if (this.opportunityht != undefined || this.opportunityht != null) {
                        this.opportunitydetails = true;
                        console.log('opportunityht : ', this.opportunityht);
                        console.log('opportunity deatils : ', this.opportunitydetails);
                    }
                })
                .catch((err) => {
                    console.log(err);
                })

        }
        //  Extra code for show help desk data ends here

    // get isCampaignAdmin() {
    //     return (this.campaignAdminPresent === this.campaignadmin);
    // }
    get isCampaignAdmin() {
        console.log('this.campaignadmin', this.campaignadmin)
        return this.campaignadmin == 'true' ? true : false;
    }

    get isAccountFlow() {
        return (this.objectname === this.accountFlow);
    }

    get isOpptyFlow() {
        return (this.objectname === this.opptyFlow);
    }

    get isShowContactTrue() {
        return this.showcontact == 'true' ? true : false;
    }

    handleSaveNext() {
        this.togglerFixHandler();
        this.togglerFixHandlerForOpp();
        console.log('Inside handleSaveNext with object name', this.objectname);
        // console.log('listAccountId>>'+this.listAccountId);

        if (this.objectname === 'Account') {
            var getselectedStep = this.selectedStep;
        } else {
            var getselectedStep = this.selectedStepOppty;
        }

        if (getselectedStep === 'selAccount') {
            this.selectedStep = 'selOppty';
            this.selectedStepOppty = 'selOppty';
            this.showOpptyComponent();
            this.isSelectStepCampaign = false;
            if (this.objectname === 'Account') {
                this.hideBack = true;
            } else {
                this.hideBack = false;
            }
            saveAccountDSRRecords({
                    accountIds: this.listAccountId,
                    dsrRelationshipId: this.dsrid,
                    recid: this.recid,
                    objectname: this.objectname
                })
                .then(() => {
                    /*const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'Account Update is successful.',
                        variant:'success'
                    });
                    this.dispatchEvent(event);*/

                })
                .catch(error => {
                    console.log(error);
                });

        } else if (getselectedStep === 'selOppty') {
            if (this.showcontact == 'false') {
                if (this.campaignadmin === 'false') {
                    console.log('this.listOpptyId1',this.listOpptyId);
                    saveOpptyDSRRecords({
                            opptyIds: this.listOpptyId,
                            dsrRelationshipId: this.dsrid,
                            recid: this.recid,
                            objectname: this.objectname
                        })
                        .then(() => {
                            this.listOpptyId ='';
                            const event = new ShowToastEvent({
                                title: 'Success',
                                message: 'Record saved successfully. Please wait while we load BriefingSource form.',
                                variant: 'success'
                            });
                            this.dispatchEvent(event);

                            if (this.objectname === 'Account') {
                                const urlWithParameters = '/apex/bsource__AccountDSR?dsrid=' + this.dsrid + '&accountId=' + this.recid + '&instanceName=' + this.instancename;
                                if (this.vfpageflow == true) {
                                    window.location.href = urlWithParameters;
                                } else {
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__webPage',
                                        attributes: {
                                            url: urlWithParameters
                                        }
                                    }, false);
                                }
                            } else {
                                const urlWithParameters = '/apex/bsource__OpportunityDSR?dsrid=' + this.dsrid + '&opptyId=' + this.recid + '&instanceName=' + this.instancename;
                                if (this.vfpageflow == true) {
                                    window.location.href = urlWithParameters;
                                } else {
                                    this[NavigationMixin.Navigate]({
                                        type: 'standard__webPage',
                                        attributes: {
                                            url: urlWithParameters
                                        }
                                    }, false);
                                }
                            }
                        })
                        .catch(error => {
                            console.log(error);
                        });
                } else {
                    this.selectedStep = 'selCampaign';
                    this.selectedStepOppty = 'selCampaign';
                    this.isSelectStepCampaign = true;
                    this.hideBack = true;
                    this.showCampaignComponent();
                    console.log('this.listOpptyId2',this.listOpptyId);
                    saveOpptyDSRRecords({
                            opptyIds: this.listOpptyId,
                            dsrRelationshipId: this.dsrid,
                            recid: this.recid,
                            objectname: this.objectname
                        })
                        .then(() => {
                            this.listOpptyId ='';
                        })
                        .catch(error => {
                            console.log(error);
                        });
                }
            } else {
                this.selectedStep = 'selContact';
                this.selectedStepOppty = 'selContact';
                this.isSelectStepCampaign = false;
                this.hideBack = true;

                this.showContactComponent();
                console.log('this.listOpptyId3',this.listOpptyId);
                saveOpptyDSRRecords({
                        opptyIds: this.listOpptyId,
                        dsrRelationshipId: this.dsrid,
                        recid: this.recid,
                        objectname: this.objectname
                    })
                    .then(() => {
                        this.listOpptyId ='';
                    })
                    .catch(error => {
                        console.log(error);
                    });
            }
        } else if (getselectedStep === 'selContact') {

            if (this.campaignadmin === 'false') {
                saveContactDSRRecords({
                        contactIds: this.listContactId,
                        dsrRelationshipId: this.dsrid
                    })
                    .then(() => {
                        this.listContactId ='';
                        const event = new ShowToastEvent({
                            title: 'Success',
                            message: 'Record saved successfully. Please wait while we load BriefingSource form.',
                            variant: 'success'
                        });
                        this.dispatchEvent(event);

                        if (this.objectname === 'Account') {
                            const urlWithParameters = '/apex/bsource__AccountDSR?dsrid=' + this.dsrid + '&accountId=' + this.recid + '&instanceName=' + this.instancename;
                            if (this.vfpageflow == true) {
                                window.location.href = urlWithParameters;
                            } else {
                                this[NavigationMixin.Navigate]({
                                    type: 'standard__webPage',
                                    attributes: {
                                        url: urlWithParameters
                                    }
                                }, false);
                            }
                        } else {
                            const urlWithParameters = '/apex/bsource__OpportunityDSR?dsrid=' + this.dsrid + '&opptyId=' + this.recid + '&instanceName=' + this.instancename;
                            if (this.vfpageflow == true) {
                                window.location.href = urlWithParameters;
                            } else {
                                this[NavigationMixin.Navigate]({
                                    type: 'standard__webPage',
                                    attributes: {
                                        url: urlWithParameters
                                    }
                                }, false);
                            }
                        }
                    })
                    .catch(error => {
                        console.log(error);
                    });
            } else {
                this.selectedStep = 'selCampaign';
                this.selectedStepOppty = 'selCampaign';
                this.isSelectStepCampaign = true;
                this.hideBack = true;
                this.showCampaignComponent();
                saveContactDSRRecords({
                        contactIds: this.listContactId,
                        dsrRelationshipId: this.dsrid
                    })
                    .then(() => {
                        this.listContactId ='';
                    })
                    .catch(error => {
                        console.log(error);
                    });

            }
        }
    }

    handlePrev() {
        this.togglerFixHandler();
        this.togglerFixHandlerForOpp();
        if (this.objectname === 'Account') {
            var getselectedStep = this.selectedStep;
        } else {
            var getselectedStep = this.selectedStepOppty;
        }
        if (getselectedStep === 'selOppty') {
            this.selectedStep = 'selAccount';
            this.selectedStepOppty = 'selAccount';
            this.isSelectStepCampaign = false;
            this.hideBack = false;
            this.showAccountComponent();
        } else if (getselectedStep === 'selContact') {
            this.selectedStep = 'selOppty';
            this.selectedStepOppty = 'selOppty';
            this.isSelectStepCampaign = false;

            if (this.objectname === 'Account') {
                this.hideBack = true;
            } else {
                this.hideBack = false;
            }
            this.showOpptyComponent();
        } else if (getselectedStep === 'selCampaign') {
            this.selectedStep = 'selContact';
            this.selectedStepOppty = 'selContact';
            this.isSelectStepCampaign = false;
            this.hideBack = true;
            this.showContactComponent();
            if (this.showcontact == 'false') {
                this.handlePrev();
                this.togglerFixHandler();
                this.togglerFixHandlerForOpp();
            }
        }
    }

    handleFinish() {
        this.togglerFixHandler();
        this.togglerFixHandlerForOpp();
        saveCampaignDSRRecords({
                campaignIds: this.listCampaignId,
                dsrRelationshipId: this.dsrid,
                instanceName: this.instancename
            })
            .then(() => {

                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Record saved successfully. Please wait while we load BriefingSource form.',
                    variant: 'success'
                });
                this.dispatchEvent(event);

                if (this.objectname === 'Account') {
                    const urlWithParameters = '/apex/bsource__AccountDSR?dsrid=' + this.dsrid + '&accountId=' + this.recid + '&instanceName=' + this.instancename;
                    if (this.vfpageflow == true) {
                        window.location.href = urlWithParameters;
                    } else {
                        this[NavigationMixin.Navigate]({
                            type: 'standard__webPage',
                            attributes: {
                                url: urlWithParameters
                            }
                        }, false);
                    }
                } else {
                    const urlWithParameters = '/apex/bsource__OpportunityDSR?dsrid=' + this.dsrid + '&opptyId=' + this.recid + '&instanceName=' + this.instancename;
                    if (this.vfpageflow == true) {
                        window.location.href = urlWithParameters;
                    } else {
                        this[NavigationMixin.Navigate]({
                            type: 'standard__webPage',
                            attributes: {
                                url: urlWithParameters
                            }
                        }, false);
                    }
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    selAccount() {
        this.selectedStep = 'selAccount';
        this.selectedStepOppty = 'selAccount';
    }

    selOppty() {
        this.selectedStep = 'selOppty';
        this.selectedStepOppty = 'selOppty';
    }

    selContact() {
        this.selectedStep = 'selContact';
        this.selectedStepOppty = 'selContact';
    }

    selCampaign() {
        this.selectedStep = 'selCampaign';
        this.selectedStepOppty = 'selCampaign';
    }


    getAccountList(event) {
        console.log('Inside getAccountList on selectDsrRelations');
        this.listAccountId = event.detail && event.detail.listAccountIds ? JSON.parse(JSON.stringify(event.detail.listAccountIds)) : [];
    }

    handleAccountUnselect() {
        console.log('Inside handleAccountUnselect');
        // this.template.querySelector('c-opportunity-dsr-relations').clearExistingOpportunities();
    }

    getOpptyList(event) {
        console.log('JSON.stringify(event.detail.listOpptyIds)>>' + JSON.stringify(event.detail.listOpptyIds));
        this.listOpptyId = JSON.parse(JSON.stringify(event.detail.listOpptyIds));
    }

    getContactList(event) {
        this.listContactId = JSON.parse(JSON.stringify(event.detail.listContactIds));
    }

    getCampaignList(event) {
        this.listCampaignId = JSON.parse(JSON.stringify(event.detail.listCampaignIds));
    }

    showOpptyComponent() {
        var accountBlock = this.template.querySelector('[data-id="accountBlock"]');
        if (accountBlock) {
            this.template.querySelector('[data-id="accountBlock"]').classList.add('slds-hide');
        }
        var opptyBlock = this.template.querySelector('[data-id="opptyBlock"]');
        if (opptyBlock) {
            this.template.querySelector('[data-id="opptyBlock"]').classList.remove('slds-hide');
            this.template.querySelector('c-opportunity-dsr-relations').clearExistingOpportunities();
        }
        var contactBlock = this.template.querySelector('[data-id="contactBlock"]');
        if (contactBlock) {
            this.template.querySelector('[data-id="contactBlock"]').classList.add('slds-hide');
        }
        var campaignBlock = this.template.querySelector('[data-id="campaignBlock"]');
        if (campaignBlock) {
            this.template.querySelector('[data-id="campaignBlock"]').classList.add('slds-hide');
        }
    }

    showContactComponent() {
        var accountBlock = this.template.querySelector('[data-id="accountBlock"]');
        if (accountBlock) {
            this.template.querySelector('[data-id="accountBlock"]').classList.add('slds-hide');
        }
        var contactBlock = this.template.querySelector('[data-id="contactBlock"]');
        if (contactBlock) {
            this.template.querySelector('[data-id="contactBlock"]').classList.remove('slds-hide');
            this.template.querySelector('c-contact-dsr-relations').clearExistingOpportunities();
        }
        var opptyBlock = this.template.querySelector('[data-id="opptyBlock"]');
        if (opptyBlock) {
            this.template.querySelector('[data-id="opptyBlock"]').classList.add('slds-hide');
        }
        var campaignBlock = this.template.querySelector('[data-id="campaignBlock"]');
        if (campaignBlock) {
            this.template.querySelector('[data-id="campaignBlock"]').classList.add('slds-hide');
        }
    }
    showCampaignComponent() {
        var accountBlock = this.template.querySelector('[data-id="accountBlock"]');
        if (accountBlock) {
            this.template.querySelector('[data-id="accountBlock"]').classList.add('slds-hide');
        }
        var contactBlock = this.template.querySelector('[data-id="contactBlock"]');
        if (contactBlock) {
            this.template.querySelector('[data-id="contactBlock"]').classList.add('slds-hide');
        }
        var opptyBlock = this.template.querySelector('[data-id="opptyBlock"]');
        if (opptyBlock) {
            this.template.querySelector('[data-id="opptyBlock"]').classList.add('slds-hide');
        }
        var campaignBlock = this.template.querySelector('[data-id="campaignBlock"]');
        if (campaignBlock) {
            this.template.querySelector('[data-id="campaignBlock"]').classList.remove('slds-hide');
        }
    }
    showAccountComponent() {
        var accountBlock = this.template.querySelector('[data-id="accountBlock"]');
        if (accountBlock) {
            this.template.querySelector('[data-id="accountBlock"]').classList.remove('slds-hide');
        }
        var contactBlock = this.template.querySelector('[data-id="contactBlock"]');
        if (contactBlock) {
            this.template.querySelector('[data-id="contactBlock"]').classList.add('slds-hide');
        }
        var opptyBlock = this.template.querySelector('[data-id="opptyBlock"]');
        if (opptyBlock) {
            this.template.querySelector('[data-id="opptyBlock"]').classList.add('slds-hide');
        }
        var campaignBlock = this.template.querySelector('[data-id="campaignBlock"]');
        if (campaignBlock) {
            this.template.querySelector('[data-id="campaignBlock"]').classList.add('slds-hide');
        }

    }

    handleDivClick(event) {
        if (event.currentTarget.dataset.close) {
            console.log(this.objectname);
            console.log(this.isSelectStepCampaign);
            if (this.objectname == 'Account') {
                this.template.querySelector('c-account-dsr-relations').closeDropDown();
            }

            this.template.querySelector('c-opportunity-dsr-relations').closeDropDown();
            this.template.querySelector('c-contact-dsr-relations').closeDropDown();
            if (this.isSelectStepCampaign) {
                this.template.querySelector('c-campaign-dsr-relations').closeDropDown();
            }
        }
    }
    togglerFixHandler() {
        this.togglerFix = !this.togglerFix;
        setTimeout(() => {
            const step = this.template.querySelector('.step.' + this.selectedStep);
            if (step && step.scrollIntoViewIfNeeded) {
                step.scrollIntoViewIfNeeded();
            }
        }, 0)
    }
    togglerFixHandlerForOpp() {
        this.togglerFixForOpp = !this.togglerFixForOpp;

    }
}