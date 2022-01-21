import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastMessage extends LightningElement {

    @api title;
    @api message;
    //@api durations;
    @api variant;

    connectedCallback(){
        this.dispatchEvent(title, message, variant);
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