/**
 * Created by cge01625 on 13/12/2019.
 */

import { LightningElement, track, api } from 'lwc';
import getRESTWS from '@salesforce/apex/RestWebService.getRestWebserviceList';
import updateWS from '@salesforce/apex/RestWebService.updateWS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RestWebService extends LightningElement {

    /*@wire(getRESTWS) restWebServices;*/
    @track restWebServices;

    @api
    get size() {
        return 'width: 200px'
    }

    init() {
        getRESTWS()
        .then(result => {

            this.restWebServices = result;
            console.log('Rest Web Service: ' + JSON.stringify(result));

        })
        .catch(error => {
            console.log('Error: ' + error);
        });
    }

    manageWS(event) {
        console.log('Event: ' + event.target.checked);
        console.log('value: ' + event.target.value);

        updateWS({ws : event.target.value, isActive : event.target.checked})
        .then(result => {

            if (event.target.checked)
                console.log('Servizio REST attivato.');
            else
                console.log('Servizio REST disattivato.');

            this.init();

        })
        .catch(error => {

            console.log('Error: ' + error);
        });
    }

    connectedCallback() {

        this.init();
    }
}