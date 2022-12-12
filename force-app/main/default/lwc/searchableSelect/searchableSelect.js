import { LightningElement, track, api } from 'lwc';
import resetPicklistValue from '@salesforce/apex/SettingsController.resetPicklistValue';
export default class SearchableSelect extends LightningElement {

    @api options;
    @track selectedValue;
    @api selectedValues = [];
    @api label;
    @api minChar = 2;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track message;
    @track showDropdown = false;
    @api fieldApiName;
    @api selectedfield;
    @api instanceName;
    @api labelName;
    connectedCallback() {
      
        this.optionData = this.options;
        this.showDropdown = false;
        this.value = this.selectedfield;
        let selected = this.optionData.filter(item => item.value == this.value);
        if (selected) {
            selected = JSON.parse(JSON.stringify(selected))
               
            if (selected.length > 0 && selected[0].label) {
                this.searchString = selected[0].label
            }
        }


    }

    @api setValues(values){
        if(values){
            this.value = ''
            this.optionData.map(item =>{
                if(item.selected == true)
                    item.selected == false;
            });
            this.searchString = '';
        }
    }

    @api refreshOptions(options, value) {
        this.searchString = '';
        if (options && options.length > 0)
            this.optionData = JSON.parse(JSON.stringify(options));
        for (var i = 0; i < this.optionData.length; i++) {
            if (this.optionData[i].value == value) {
                this.searchString = this.optionData[i].label;
            }
        }
    }

    filterOptions(event) {
        this.searchString = event.target.value;
        if (this.searchString && this.searchString.length > 0) {
            this.message = '';
            if (this.searchString.length >= this.minChar) {
                var flag = true;
                for (var i = 0; i < this.optionData.length; i++) {
                    if (this.optionData[i].label.toLowerCase().trim().includes(this.searchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        flag = false;
                    } else {
                        this.optionData[i].isVisible = false;
                    }
                }
                if (flag) {
                    this.message = "No results found for '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
    }

    selectItem(event) {
        var selectedVal = event.currentTarget.dataset.id;
        if (selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.optionData));
            for (var i = 0; i < options.length; i++) {
                if (options[i].value === selectedVal) {
                    if (this.multiSelect) {
                        if (this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;
                    } else {
                        this.value = options[i].value;
                        this.searchString = options[i].label;
                    }
                }
                if (options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
            if (this.multiSelect)
                this.searchString = count + ' Option(s) Selected';
            if (this.multiSelect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
      


    }

    showOptions() {
        if (this.disabled == false && this.options) {
            this.message = '';
            this.searchString = '';
            var options = JSON.parse(JSON.stringify(this.optionData));
            for (var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if (options.length > 0) {
                this.showDropdown = true;
            }
            this.optionData = options;
        }
    }

    removePill(event) {
        var value = event.currentTarget.name;
      
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for (var i = 0; i < options.length; i++) {
            if (options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
               
            }
            if (options[i].selected) {
                count++;
            }
        }
        this.optionData = options;
        if (this.multiSelect)
            this.searchString = count + ' Option(s) Selected';
    }

    blurEvent() {
        var previousLabel;
        var count = 0;
        for (var i = 0; i < this.optionData.length; i++) {
            if (this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if (this.optionData[i].selected) {
                count++;
            }
        }
        if (this.multiSelect)
            this.searchString = count + ' Option(s) Selected';
        else
            this.searchString = previousLabel;

        this.showDropdown = false;
      

        this.dispatchEvent(new CustomEvent('select', {
            detail: {
                'payloadType': 'multi-select',
                'payload': {
                    'value': this.value,
                    'values': this.values,
                    'apiname': this.fieldApiName
                }
            }
        }));
    }
    resetPicklistValueHandler(){
      
        resetPicklistValue({ instanceName: this.instanceName,picklistValue: this.value,labelValue:this.labelName })
        .then((data) => {
            this.searchString='';
        })
        .catch((err) => {

        })
        .finally(() => {

        });
    } 
}