import { LightningElement, track, wire,api } from 'lwc';
import getInstanceName from '@salesforce/apex/SettingsController.getInstanceName';
import whiteListRemoteSiteSetting from '@salesforce/apex/SettingsController.whiteListRemoteSiteSetting';
import updateRemoteSiteSetting from '@salesforce/apex/SettingsController.updateRemoteSiteSetting';
import Disconnected from '@salesforce/apex/SettingsController.Disconnected';
import { showError } from 'c/lwcUtil';
import LightningConfirm from "lightning/confirm";

export default class AdminSettingsParentComponent extends LightningElement {
	@track briefingSourceInstanceName;
	@track lstTabs;
	@track activeInstanceName;
	@track processing = true;
	@track message;
	@track variant;
	@api sessionId;
	connectedCallback(){
		console.log('sessionId',this.sessionId)
		getInstanceName()
		.then((result) => {
			let i = 0;
			let active = false;
			this.lstTabs = result.map(item=>{
				if(i==0){active = true;i++;}else{active=false}
				return {
					Id : item.Id,
					Name : item.Name,
					isActive: active,
					bottomLine: active,
				}
			});
		})
		.catch((err) => {
		})
		.finally(() => {
			this.processing = false;
		});
		
		whiteListRemoteSiteSetting()
		.then((result) => {
			console.log('result'+result);
			if(result != 'false'){
				console.log('createRSS');
				this.createRSS(result,this.sessionId);
			}
		})
		.catch((err) => {
		})
		.finally(() => {
			this.processing = false;
		});
		
	}
	
	addBriefingSource(event) {
		const addedAlready = this.lstTabs.find(item => typeof item.Id == 'number');
		console.log('addBriefingSource');
		if(!addedAlready){
			const tabId = this.lstTabs.length;
			console.log('this.lstTabs.length',this.lstTabs.length);
			let isActive;
			if(tabId == 0){
				isActive=true;
			}
			else{
				isActive=false;
			}
			const addbriefing = {Id:tabId, Name: `NewInstance${tabId + 1}`,isActive: true };
			this.lstTabs = [...this.lstTabs, addbriefing];
			let prepTab = [];
			let tabName = '';
			this.lstTabs.map(tab=>{
				tab.bottomLine = false;
				if(tab.isActive == true){
					let temp = this.template.querySelector('div[data-name='+tab.Name+']');
					if(temp){
						temp.style.display='none';
					}
				}
				if(tab.Id == tabId){
					tab.isActive = true;
					tab.bottomLine = true;
					tabName = tab.Name;
				}
				prepTab.push(JSON.parse(JSON.stringify(tab)));
			});
			console.log('prepTab',prepTab);
			this.lstTabs = prepTab;
			setTimeout(() => {
				let temp = this.template.querySelector('div[data-name='+tabName+']');
				if(temp){
					temp.style.display='block';
				}
			}, 10);
		}
		else {
			this.message = 'BriefingSource Instance is Already Added';
			this.variant = 'error';
			this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
			// showError(this, {message: 'Added Already'});
		}
	}

	handleChangeActive(event){
		this.processing = true;
		let tabName = event.currentTarget.dataset.name;
		let tabId = event.currentTarget.dataset.id;
		console.log('handleChangeActive',tabName);
		let prepTab = [];
		this.lstTabs.map(tab=>{
			tab.bottomLine = false;
			if(tab.isActive == true){
				let temp = this.template.querySelector('div[data-name='+tab.Name+']');
				if(temp){
					temp.style.display='none';
				}
			}
			if(tab.Id == tabId){
				tab.isActive = true;
				tab.bottomLine = true;
			}
			prepTab.push(JSON.parse(JSON.stringify(tab)));
		});
		console.log('prepTab',prepTab);
		this.lstTabs = prepTab;
		setTimeout(() => {
			let temp = this.template.querySelector('div[data-name='+tabName+']');
			if(temp){
				temp.style.display='block';
			}
			this.processing = false;
		}, 10);
		setTimeout(() => {
			this.processing = false;
		}, 1000);
	}

	handleClose(event){
		event.preventDefault();
		event.stopPropagation();
		let tabName = event.currentTarget.dataset.name;
		let tabId = event.currentTarget.dataset.id;
		console.log('tabId',tabId);
		let tablabel;
		if(tabId.length > 16){
			tablabel= 'Are you sure? This will disconnect the BriefingSource instance from Salesforce?';
		}
		else{
			tablabel= 'Are you sure?';
		}
		//let tabLabel = 
		LightningConfirm.open({
			message: "",
			theme: "error",
			label: tablabel
		  }).then((result) => {
			if(result){
				if(tabId.length > 16){
					console.log('instanceName',tabName)
					Disconnected({ InstanceName: tabName })
					.then((result) => {
						let tempVar = [];
						this.lstTabs.map(tab=>{
							tab.bottomLine = false;
							if(tab.isActive == true){
								let temp = this.template.querySelector('div[data-name='+tab.Name+']');
								if(temp){
									temp.style.display='none';
								}
							}
							if(this.lstTabs[this.lstTabs.length - 2]){
								this.lstTabs[this.lstTabs.length - 2].isActive = true;
								this.lstTabs[this.lstTabs.length - 2].bottomLine = true;
								let temp = this.template.querySelector('div[data-name='+this.lstTabs[this.lstTabs.length - 2].Name+']');
								if(temp){
									temp.style.display='block';
								}
							}else{
								this.lstTabs[this.lstTabs.length - 1].isActive = true;
								this.lstTabs[this.lstTabs.length - 1].bottomLine = true;
								let temp = this.template.querySelector('div[data-name='+this.lstTabs[this.lstTabs.length - 2].Name+']');
								if(temp){
									temp.style.display='block';
								}
							}
							if(tab.Name != tabName){
								tempVar.push(tab)
							}
						});
						console.log('tempVar',tempVar);
						this.lstTabs = tempVar ? JSON.parse(JSON.stringify(tempVar)) : this.lstTabs;
					})
				}else{
					let prepTab = [];
					this.lstTabs.map(tab=>{
						tab.bottomLine = false;
						if(tab.isActive == true){
							let temp = this.template.querySelector('div[data-name='+tab.Name+']');
							if(temp){
								temp.style.display='none';
							}
						}
						if(this.lstTabs[this.lstTabs.length - 2]){
							this.lstTabs[this.lstTabs.length - 2].isActive = true;
							this.lstTabs[this.lstTabs.length - 2].bottomLine = true;
							let temp = this.template.querySelector('div[data-name='+this.lstTabs[this.lstTabs.length - 2].Name+']');
							if(temp){
								temp.style.display='block';
							}
						}else{
							this.lstTabs[this.lstTabs.length - 1].isActive = true;
							this.lstTabs[this.lstTabs.length - 1].bottomLine = true;
							let temp = this.template.querySelector('div[data-name='+this.lstTabs[this.lstTabs.length - 1].Name+']');
							if(temp){
								temp.style.display='block';
							}
						}
						if(tab.Id != tabId){
							prepTab.push(JSON.parse(JSON.stringify(tab)));
						}
					});
					this.lstTabs = prepTab;
				}
			}
		  });
	}

	handleDisconnectCallBack(tabName){
		// let prepTab = [];
		// this.lstTabs.map(tab=>{
		// 	if(this.lstTabs[this.lstTabs.length - 2]){
		// 		this.lstTabs[this.lstTabs.length - 2].isActive = true;
		// 	}
		// 	if(tab.Name != tabName){
		// 		prepTab.push(JSON.parse(JSON.stringify(tab)));
		// 	}
		// });
		// this.lstTabs = prepTab;
	}
	
	showLoader(event){
		this.processing = event.detail.value;
	}
	createRSS(url,sessionId) {
		// url= 'http://google12.com/';
		// sessionId = prompt('sessionId');
		var binding = new XMLHttpRequest();
		var request =
		'<?xml version="1.0" encoding="utf-8"?>' +
		'<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
		'<env:Header>' +
		'<urn:SessionHeader xmlns:urn="http://soap.sforce.com/2006/04/metadata">' +
		'<urn:sessionId>'+ sessionId +'</urn:sessionId>' +
		'</urn:SessionHeader>' +
		'</env:Header>' +
		'<env:Body>' +
		'<createMetadata xmlns="http://soap.sforce.com/2006/04/metadata">' +
		'<metadata xsi:type="RemoteSiteSetting">' +
		'<fullName>'+ 'self_instance_url' + '</fullName>' +
		'<description>The URL used to access this instance of Salesforce (eg "company-name.my.salesforce.com" if using mydomains otherwise "naXX.salesforce.com").</description>' +
		'<disableProtocolSecurity>false</disableProtocolSecurity>' +
		'<isActive>true</isActive>' +
		'<url>' + url + '</url>' +
		'</metadata>' +
		'</createMetadata>' +
		'</env:Body>' +
		'</env:Envelope>';
		binding.open('POST', '/services/Soap/m/35.0');
		binding.setRequestHeader('SOAPAction','""');
		binding.setRequestHeader('Content-Type', 'text/xml');
		binding.onreadystatechange = function() {
			if (this.readyState==4) {
				var parser = new DOMParser();
				var doc = parser.parseFromString(this.response, 'application/xml');
				var errors = doc.getElementsByTagName('errors');
				var messageText = '';
				for(var errorIdx = 0; errorIdx < errors.length; errorIdx++){
					messageText+= errors.item(errorIdx).getElementsByTagName('message').item(0).innerHTML + '\n';
				}
				console.log(messageText);
				console.log('RemoteSiteSetting created.');
				// saveCredentials(url, username, password,cId,cSecret);
			}
		}
		binding.send(request);

		updateRemoteSiteSetting()
		.then((result) => {

		})
		.catch((err) => {
		})
		.finally(() => {
			this.processing = false;
		});
	}
	handleButtonChange(){
		alert();
	}
}