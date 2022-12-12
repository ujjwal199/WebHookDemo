import { LightningElement, track, api} from 'lwc';

export default class OpportunityDsrRelations extends LightningElement {

    @track selectedItemsToDisplay = ''; //to display items in comma-delimited way
    @track values = []; //stores the labels in this array
    @track isItemExists = false; //flag to check if message can be displayed
    @api accountslist;
    @api recordname;
    @api recid;
    @api initiatedfrom;

    //captures the retrieve event propagated from lookup component
    selectItemEventHandler(event){
       
        
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        
        
        this.displayItem(args);        
    }

    handleAccountRemoval(event){
       
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
        if(args != ''){

            this.values = []; //initialize first
            args.map(element=>{
                this.values.push(element.value);
            });
    
            this.isItemExists = (args.length>0);
            this.selectedItemsToDisplay = this.values.join(',');
            let listOpptyIds = this.selectedItemsToDisplay;
            const evtCustomEvent = new CustomEvent('getoppty', { 
                detail: {listOpptyIds}
                });
            this.dispatchEvent(evtCustomEvent);
        }else{
            this.values = [];
            this.selectedItemsToDisplay = '';
        }
    
    }

    // created by Shatarchi
    @api
    clearExistingOpportunities(){
        this.template.querySelector('c-lookup-search-component').loadOpportunityCmpHandler();
    }

    @api
    closeDropDown(){
        
        this.template.querySelector('c-lookup-search-component').handleDivClick();

    }
    // created by Shatarchi ends here
}