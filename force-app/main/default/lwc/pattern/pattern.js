import { LightningElement, track } from 'lwc';

export default class Pattern extends LightningElement {
@track a1=[];
@track a2=[];
@track input;
@track pattern2=false;
@track pattern=false;
 change(e){
    //a1=[];
    //a2=[];
    console.log(e.target.value);
     this.input = e.target.value;
     let str1;
     let str2;
   
   for(var i=0;i<=this.input;i++){
       str1='';
       str2='';
       for(let j=1;j<=i;j++){
        str1+='*';
        }
        this.a2[i]=str1;
        for(var k=this.input;k>=i;k--){
            str2+='*';
            }
        
        this.a1[i]=str2;

  } 
  
  this.pattern=true;
  this.pattern2=true;
    }

    activeSections = ['A', 'C'];
    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
}