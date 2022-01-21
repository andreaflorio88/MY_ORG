import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastMessage extends LightningElement {

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