import { api, LightningElement, track} from 'lwc';

export default class CampaignDsrRelations extends LightningElement {

    @track selectedItemsToDisplay = ''; //to display items in comma-delimited way
    @track values = []; //stores the labels in this array
    @track isItemExists = false; //flag to check if message can be displayed

    //captures the retrieve event propagated from lookup component
    selectItemEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        this.displayItem(args);        
    }

    //captures the remove event propagated from lookup component
    deleteItemEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        this.displayItem(args);
    }

    //displays the items in comma-delimited way
    displayItem(args){
        this.values = []; //initialize first
        args.map(element=>{
            this.values.push(element.value);
        });

        this.isItemExists = (args.length>0);
        this.selectedItemsToDisplay = this.values.join(',');
        let listCampaignIds = this.selectedItemsToDisplay;
        const evtCustomEvent = new CustomEvent('getcampaign', { 
            detail: {listCampaignIds}
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