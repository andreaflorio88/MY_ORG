import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastMessage extends LightningElement {

    @api title;
    @api message;
    //@api durations;
    @api variant;

    connectedCallback(){
        this.dispatchEvent();
    }
    // Toast event dispatcher
    dispatchToastEvent() {
        const evt = new ShowToastEvent({
            title: this.title,
            message: this.messsage,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }
}