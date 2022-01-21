import { LightningElement, api } from 'lwc';

/* Importazione delle Custom Labels */
import Edit from '@salesforce/label/c.Edit';
import Delete from '@salesforce/label/c.Delete';

export default class OpportunitySoluzioneTopClient extends LightningElement {

    @api soluzione;

    label = {
        Edit,
        Delete
    };

    handleClickSoluzione(event){

        let data = {id: this.soluzione.Id, action: event.target.dataset.action};

        event.preventDefault();
        const redirectEvent = new CustomEvent('clicksoluzione', { detail: data });
        this.dispatchEvent(redirectEvent);
    }
}