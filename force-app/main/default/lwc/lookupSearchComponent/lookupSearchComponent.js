import { LightningElement, api, track } from 'lwc';
import retrieveRecords from '@salesforce/apex/MultiSelectLookupController.retrieveRecords';

let i = 0;
export default class LookupSearchComponent extends LightningElement {

    _handler;
    @track globalSelectedItems = []; //holds all the selected checkbox items


    @api objectApiName;
    @api fieldApiNames;
    @api filterFieldApiName;
    @api iconName;
    @api accountslist;
    @api ocrlist;
    @api recordname;
    @api recid;
    @api initiatedfrom;

    @track items = []; //holds all records from database
    @track selectedItems = []; //holds only selected checkbox items


    @track previousSelectedItems = [];
    @track value = []; //this holds checkbox values ID
    searchInput = '';
    isDialogDisplay = false;
    isDisplayMessage = false; //to show 'No records found' message

    @track insideClick;

    /*connectedCallback(){
        console.log('Inside connected callback');
    }*/

    //  @Deb
    // Code for Selected labels Name
    get AccountLabelName() {
        if (this.objectApiName == 'Account') {
            this.acctlabelname = true;
            return true;
        } else {
            return false;
        }
    }

    get OpportunityLabelName() {
        if (this.objectApiName == 'Opportunity') {
            return true;
        }
    }

    get ContactLabelName() {
        if (this.objectApiName == 'Contact') {
            return true;
        }
    }

    get CampaignLabelName() {
        if (this.objectApiName == 'Campaign') {
            return true;
        }
    }

    get globalSelectedItemsisnull(){
        console.log('globalSelectedItemsisnull',this.globalSelectedItems);
        return this.globalSelectedItems.length>0?true:false;
    }
    get setlookupHeight(){
        return this.globalSelectedItems.length>0?'slds-popover slds-popover_full-width height-lookup':'slds-popover slds-popover_full-width '
    }
    connectedCallback() {
        console.log('Get account label :', this.AccountLabelName);
        console.log('Get Opportunity label :', this.OpportunityLabelName);
        console.log('Get Contact label :', this.ContactLabelName);
        console.log('Get Campaign label :', this.CampaignLabelName);
        // Object API's name
        console.log('Object Api Names :', this.objectApiName);
    }

    // Code ends here for selected labels Name

    renderedCallback() {
        console.log('Inside renderedCallback in Lookup Search Component ', this.items.length);
        if (this.items.length == 0) {
            console.log('No items!!');
            this.isDialogDisplay = false;
        }

        console.log('%cItems = ', 'font-size: 25px; color: blue', this.items);
        console.log('%cGLobal selected items = ', 'font-size: 25px; color: red', this.globalSelectedItems);

    }

    //This method is called when user enters search input. It displays the data from database.
    onchangeSearchInput(event) {
        this.isDisplayMessage = false;
        console.log('Searched for', event.target.value);
        console.log('Obj>>' + this.objectApiName);
        console.log('recid>>' + this.recid);
        this.searchInput = event.target.value;
        if (this.searchInput.trim().length > 2) {
            retrieveRecords({
                    objectName: this.objectApiName,
                    fieldAPINames: this.fieldApiNames,
                    filterFieldAPIName: this.filterFieldApiName,
                    strInput: this.searchInput,
                    accountslist: this.accountslist,
                    ocrlist: this.ocrlist,
                    recid: this.recid,
                    initiatedfrom: this.initiatedfrom
                })
                .then(result => {

                    this.items = [];
                    this.value = [];
                    this.previousSelectedItems = [];

                    if (result.length > 0) {
                        result.map(resElement => {
                            //prepare items array using spread operator
                            this.items = [...this.items, {
                                value: resElement.recordId,
                                label: resElement.recordName
                            }];

                            this.globalSelectedItems.map(element => {
                                if (element.value == resElement.recordId) {
                                    this.value.push(element.value);
                                    this.previousSelectedItems.push(element);
                                }
                            });
                        });


                        this.isDialogDisplay = true; //display dialog
                        this.isDisplayMessage = false;

                        var resultValueArray = [];
                        result.forEach(res => {
                            // console.log('Result item', res.recordId);
                            resultValueArray.push(res.recordId);
                        });

                        // this.globalSelectedItems.forEach((element, index) => {

                        //     if(resultValueArray.indexOf(element.value) < 0){
                        //         console.log('%cGlobal item that needs to be removed is', 'background: blue; color: white;', element.label, ' and index on global array = ', index);
                        //         this.globalSelectedItems.splice(index, 1);

                        //     }
                        // });


                        const arrItems = this.globalSelectedItems;
                        const evtCustomEvent = new CustomEvent('accountremove', {
                            // detail: {removeItem,arrItems}
                            detail: { arrItems }
                        });
                        this.dispatchEvent(evtCustomEvent);

                        const evtCustomEvent2 = new CustomEvent('retrieve', {
                            detail: { arrItems }
                        });
                        this.dispatchEvent(evtCustomEvent2);
                    } else {
                        //display No records found message
                        this.isDialogDisplay = false;
                        this.isDisplayMessage = true;
                    }
                })
                .catch(error => {
                    console.error('error>>' + error)
                    this.error = error;
                    this.items = undefined;
                    this.isDialogDisplay = false;
                })
        } else {
            this.isDialogDisplay = false;
        }
    }

    @api
    loadOpportunityCmpHandler() {
        //console.log('Inside loadOpportunityCmpHandler');
        retrieveRecords({
                objectName: this.objectApiName,
                fieldAPINames: this.fieldApiNames,
                filterFieldAPIName: this.filterFieldApiName,
                strInput: '*',
                accountslist: this.accountslist,
                ocrlist: this.ocrlist,
                recid: this.recid,
                initiatedfrom: this.initiatedfrom
            })
            .then(result => {

                console.log('retrieve records ', result);
                console.log('globalSelectedItems ', this.globalSelectedItems);

                var resultValueArray = [];

                var indexOfElementsThatNeedToBeRemoved = [];

                result.forEach(res => {
                    // console.log('Result item', res.recordId);
                    resultValueArray.push(res.recordId);
                });

                this.globalSelectedItems.forEach((element, index) => {
                    console.log('Global Item from loadOpportunityCmpHandler and its index', element, index);

                    if (resultValueArray.indexOf(element.value) < 0) {

                        console.log('%cGlobal item that needs to be removed is', 'background: blue; color: white;', element.label, ' and index on global array = ', index);
                        // this.globalSelectedItems.splice(index, 1);
                        indexOfElementsThatNeedToBeRemoved.push(index);

                    }

                });

                indexOfElementsThatNeedToBeRemoved.sort(function(a, b) { return b - a });
                console.log('%cindexOfElementsThatNeedToBeRemoved after sorting', 'background: pink; color: white', indexOfElementsThatNeedToBeRemoved);

                for (var i = 0; i < indexOfElementsThatNeedToBeRemoved.length; i++) {
                    console.log('Inside removal loop with loop counter = ', i, ' and element on counter is ', indexOfElementsThatNeedToBeRemoved[i]);
                    console.log('%cRemoving item ', 'background: purple; color: white;', this.globalSelectedItems[indexOfElementsThatNeedToBeRemoved[i]], ' from global array which has index', indexOfElementsThatNeedToBeRemoved[i]);
                    this.globalSelectedItems.splice(indexOfElementsThatNeedToBeRemoved[i]);
                }
                console.log('this.globalSelectedItems', this.globalSelectedItems);

                this.items = [];
                this.value = [];
                this.previousSelectedItems = [];


            })
            .catch(error => {
                console.error('error>>' + error)
                this.error = error;
                this.items = undefined;
                this.isDialogDisplay = false;
            })
    }

    //This method is called during checkbox value change
    handleCheckboxChange(event) {
        let selectItemTemp = event.detail.value;

        //all the chosen checkbox items will come as follows: selectItemTemp=0032v00002x7UE9AAM,0032v00002x7UEHAA2        
        this.selectedItems = []; //it will hold only newly selected checkbox items.        

        selectItemTemp.map(p => {
            let arr = this.items.find(element => element.value == p);
            if (arr != undefined) {
                this.selectedItems.push(arr);
            }
        });
    }

    //this method removes the pill item
    handleRemoveRecord(event) {
        const removeItem = event.target.dataset.item; //"0011a000004e1bJAAQ"
        console.log('removeItem',removeItem);
        //this will prepare globalSelectedItems array excluding the item to be removed.
        this.globalSelectedItems = this.globalSelectedItems.filter(item => item.value != removeItem);
        console.log('this.globalSelectedItems removeItem',this.globalSelectedItems);
        const arrItems = this.globalSelectedItems;

        //added this line on 9/7
        this.selectedItems = this.globalSelectedItems;

        this.initializeValues();
        this.value = [];

        //console.log("remove arrItems"+arrItems);
        const evtCustomEvent = new CustomEvent('remove', {
            detail: { removeItem, arrItems }
        });
        this.dispatchEvent(evtCustomEvent);

    }


    handleDoneClick(event) {

        event.preventDefault();

        //remove previous selected items first as there could be changes in checkbox selection
        this.previousSelectedItems.map(p => {
            this.globalSelectedItems = this.globalSelectedItems.filter(item => item.value != p.value);
        });

        this.globalSelectedItems.map(p => {
            this.selectedItems = this.selectedItems.filter(item => item.value != p.value);
        });


        //now add newly selected items to the globalSelectedItems
        this.globalSelectedItems.push(...this.selectedItems);
        //this.globalSelectedItems = this.selectedItems;   
        const arrItems = this.globalSelectedItems;

        //store current selection as previousSelectionItems
        this.previousSelectedItems = this.selectedItems;

        // this.initializeValues();      

        //propagate event to parent component
        const evtCustomEvent = new CustomEvent('retrieve', {
            detail: { arrItems }
        });
        this.dispatchEvent(evtCustomEvent);
    }

    handleCloseDivChild(event) {
        var a = event.currentTarget.dataset.close;
        if (a == 'false') {
            this.insideClick = true;

        }
        // this.isDialogDisplay = true;

    }

    // closing the drop down
    @api
    handleDivClick() {

        if (this.insideClick) {
            this.isDialogDisplay = true;

        } else {
            this.searchInput = '';
            this.isDialogDisplay = false;
            this.items = [];
        }
        this.insideClick = false;

    }

    handleCancelClick(event) {
        this.initializeValues();
    }

    //this method initializes values after performing operations
    initializeValues() {
        this.searchInput = '';
        this.isDialogDisplay = false;
    }

    /*
    connectedCallback() {
        document.addEventListener('click', this._handler = this.close.bind(this));
    }
    disconnectedCallback() {
        document.removeEventListener('click', this._handler);
    }
    
    ignore(event) {
        event.stopPropagation();
        return false;
    }
    close() { 
        console.log('we should close now');
        //remove previous selected items first as there could be changes in checkbox selection
        this.previousSelectedItems.map(p=>{
            this.globalSelectedItems = this.globalSelectedItems.filter(item => item.value != p.value);
        });
        
        this.globalSelectedItems.map(p=>{
            this.selectedItems = this.selectedItems.filter(item => item.value != p.value);
        });
        
        //now add newly selected items to the globalSelectedItems
        // this.globalSelectedItems.push(...this.selectedItems);    
        this.globalSelectedItems = this.selectedItems;    
        const arrItems = this.globalSelectedItems;
        
        //store current selection as previousSelectionItems
        this.previousSelectedItems = this.selectedItems;
        this.initializeValues();        
        
        //propagate event to parent component
        const evtCustomEvent = new CustomEvent('retrieve', { 
            detail: {arrItems}
            });
        this.dispatchEvent(evtCustomEvent);
    }*/
}

/*import { LightningElement, api } from 'lwc';

export default class LookupSearchComponent extends LightningElement {
    @api childObjectApiName = 'Contact'; //Contact is the default value
    @api targetFieldApiName = 'AccountId'; //AccountId is the default value
    @api fieldLabel = 'Your field label here';
    @api disabled = false;
    @api value;
    @api required = false;

    handleChange(event) {
        // Creates the event
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }

    @api isValid() {
        if (this.required) {
            this.template.querySelector('lightning-input-field').reportValidity();
        }
    }
}*/