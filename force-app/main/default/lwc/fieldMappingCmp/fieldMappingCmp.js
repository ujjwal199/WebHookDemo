import { LightningElement,api,wire,track } from 'lwc';

export default class FieldMappingCmp extends LightningElement {
    @api fieldsLabel;
    @api fieldsData;
    @api instanceName;
    @track fieldsDataForChild;
    @track fieldsLabelForChild;


    
    connectedCallback(){
        var fieldsLabelTemp = JSON.stringify(this.fieldsLabel);
        fieldsLabelTemp = JSON.parse(fieldsLabelTemp);
        this.fieldsLabelForChild = fieldsLabelTemp;
        var fieldsDataTemp = JSON.stringify(this.fieldsData);
        fieldsDataTemp = JSON.parse(fieldsDataTemp);

        var objLength = Object.keys(fieldsDataTemp).length;
        var tempArr = [];
        for(let i=0;i<objLength;i++){
            tempArr.push(fieldsDataTemp[i]);
        }
        this.fieldsDataForChild = tempArr;

         console.log("fieldsDataTemp 44",this.fieldsDataForChild)
         console.log("fieldsDataTemp data",this.fieldsDataForChild.length);
        
    }
    



}