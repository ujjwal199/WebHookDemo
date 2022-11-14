import { api, LightningElement, track} from 'lwc';

export default class AccountDsrRelations extends LightningElement {

    @track selectedItemsToDisplay = ''; //to display items in comma-delimited way
    @track values = []; //stores the labels in this array
    @track isItemExists = false; //flag to check if message can be displayed
    @api recordname;
    @api recid;
    @api initiatedfrom;


    //captures the retrieve event propagated from lookup component
    selectItemEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        this.displayItem(args);        
    }

    //captures the remove event propagated from lookup component
    deleteItemEventHandler(event){
        console.log('Inside deleteItemEventHandler on Account');
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        console.log('Unselected account args = ', args);
        this.displayItem(args);

        // calling method to clear existing opp on removal of a selected account
        const evtCustomEvent = new CustomEvent('removeaccount');
        this.dispatchEvent(evtCustomEvent);
    }

    //displays the items in comma-delimited way
    displayItem(args){
        this.values = []; //initialize first
        args.map(element=>{
            this.values.push(element.value);
        });

        this.isItemExists = (args.length>0);
        this.selectedItemsToDisplay = this.values.join(',');
        let listAccountIds = this.selectedItemsToDisplay;
        console.log('Inside displayItem values = ', this.values);
        console.log('Inside displayItem selectedItemsToDisplay = ', this.selectedItemsToDisplay);
        const evtCustomEvent = new CustomEvent('getaccounts', { 
            detail: {listAccountIds}
            });
        this.dispatchEvent(evtCustomEvent);
        
    
    }

    @api
    closeDropDown(){
        
        this.template.querySelector('c-lookup-search-component').handleDivClick();

    }
}

/*import { LightningElement } from 'lwc';

export default class AccountDsrRelations extends LightningElement {
    selectedRecordId; //store the record id of the selected 
    handleValueSelcted(event) {
        this.selectedRecordId = event.detail;
    }
}*/