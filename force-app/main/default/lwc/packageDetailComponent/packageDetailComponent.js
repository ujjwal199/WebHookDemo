import { LightningElement, track } from 'lwc';
import getpackagedetails from '@salesforce/apex/NewDSRCreationFlowController.getpackagedetails';
export default class PackageDetailComponent extends LightningElement {
   
   version='Please press on the Grant access';
  
   oauth='Please click on grant access';
 connectedCallback(){
    getpackagedetails().then((result)=>{

       
        this.oauth=result;
        this.version='1.59';
        
    }).catch((error)=>{

    })

 }
}