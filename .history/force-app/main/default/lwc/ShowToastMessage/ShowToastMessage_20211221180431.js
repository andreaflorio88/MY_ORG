import { LightningElement, @api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CallDurationInSeconds from '@salesforce/schema/Task.CallDurationInSeconds';

export default class ShowToastMessage extends LightningElement {

    @title;
    @message;
    @durations;
    @type;
    
    connectedCallback(){

    }
    // Toast event dispatcher
    dispatchToastEvent(title, messsage, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: messsage,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}