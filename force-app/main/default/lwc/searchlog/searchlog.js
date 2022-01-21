/**
 * Created by cge01625 on 03/07/2019.
 */
import { LightningElement, track, api, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogController.searchLogs';

const columns = [
    { label: 'Evento', fieldName: 'Evento__c', type: 'text' },
    { label: 'Esito', fieldName: 'Esito__c', type: 'text' },
    { label: 'Messaggio Errore', fieldName: 'Messaggio_Errore__c', type: 'text' },
    { label: 'Data Creazione', fieldName: 'CreatedDate', type: "date-local",
                                                                 typeAttributes:{
                                                                     month: "2-digit",
                                                                     day: "2-digit"
                                                                 } },
    { label: 'Link', fieldName: 'linkName', type: 'url',
        cellAttributes: { iconName: 'utility:share', iconAlternativeText: 'Go to record!' },
         typeAttributes: { label: {fieldName: 'Evento__c'} }}
];

export default class Searchlog extends LightningElement {
    @track queryTerm;
    @api isLoaded = false;
    @track data = [];
    @track columns = columns;
    @track rowOffset = 0;

    handleKeyUp(evt) {
        this.isLoaded = !this.isLoaded;

        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {

            this.queryTerm = evt.target.value;

            searchLogs({quoteNumber : this.queryTerm})
            .then(result => {

                this.data = result;
                var records = this.data;
                records.forEach(function(record){
                    record.linkName = '/' + record.Id;
                });
                this.data = records;

                console.log('Log Details: ' + JSON.stringify(this.data));

            })
            .catch(error => {

                console.log('Error: ' + error);
            });
        }
    }
}