import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendEmailAction extends LightningElement {
    
    description;
    isLoaded = false;

    connectedCallback() {
        this.init();
    }

    init(){
        this.description = '';
    }

    handleSuccess() {
        this.dispatchToastEvent("Cerved AML configurata.","Record salvato correttamente","success");
    }

    handleError() {
        this.dispatchToastEvent("Errore","Email non inviata","error");
    }

    handleSubmit() {this.isLoaded = !this.isLoaded;}

    // Toast event dispatcher
    dispatchToastEvent(title, messsage, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: messsage,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    onchangeEvent(event){
        alert(event.target.value);
    }

}