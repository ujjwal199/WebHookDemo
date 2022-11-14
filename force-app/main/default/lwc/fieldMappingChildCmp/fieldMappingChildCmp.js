import { LightningElement,api,track } from 'lwc';
import { getAvailableFieldsByInstanceName } from 'c/adminSettingDataStore';
export default class FieldMappingChildCmp extends LightningElement {
	@api fieldsLabel;
	@api fieldsData;
	@api instanceName;
	@track availableFields = [];

	connectedCallback() {
		console.log('fieldsData opportunityFieldName',this.fieldsData.opportunityFieldName)
		this.availableFields = getAvailableFieldsByInstanceName(this.instanceName);
	}
	
	handleChange(event){
		console.log('event.currentTarget.value',event.detail.payload.value);
		console.log('event.currentTarget.value',event.detail.payload.apiname);
		if(event.detail.payload.value && event.detail.payload.apiname){
		const selectedEvent = new CustomEvent("fieldvalues", {
			bubbles: true, composed: true, detail :{ detail: event.detail.payload.value,apiName : event.detail.payload.apiname}
		});
		this.dispatchEvent(selectedEvent);
	}
	}
}