import { LightningElement, track, api} from 'lwc';

export default class ContactDsrRelations extends LightningElement {

    @track selectedItemsToDisplay = ''; //to display items in comma-delimited way
    @track values = []; //stores the labels in this array
    @track isItemExists = false; //flag to check if message can be displayed
    @api accountslist;
    @api ocrlist;
    @api initiatedfrom;
    @api recid;

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
        let listContactIds = this.selectedItemsToDisplay;
        const evtCustomEvent = new CustomEvent('getcontact', { 
            detail: {listContactIds}
            });
        this.dispatchEvent(evtCustomEvent);
    
    }

    @api
    clearExistingOpportunities(){
        console.log('%cInside clearExistingOpportunities', 'background: green; color: white');  
        this.template.querySelector('c-lookup-search-component').loadOpportunityCmpHandler();
    }

    @api
    closeDropDown(){
        
        this.template.querySelector('c-lookup-search-component').handleDivClick();

    }
}