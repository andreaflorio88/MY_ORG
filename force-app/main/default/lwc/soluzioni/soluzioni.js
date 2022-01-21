import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getConsumi from '@salesforce/apex/OpportunitySoluzioniTopClient.getConsumi';
import getSoluzioni from '@salesforce/apex/OpportunitySoluzioniTopClient.getSoluzioni';
import upsertConsumi from '@salesforce/apex/OpportunitySoluzioniTopClient.upsertConsumi';
import deleteSoluzione from '@salesforce/apex/OpportunitySoluzioniTopClient.deleteSoluzione';

/* Importazione delle Custom Labels */
import Save from '@salesforce/label/c.Save';
import Close from '@salesforce/label/c.Close';
import Cancel from '@salesforce/label/c.Cancel';
import Success from '@salesforce/label/c.Success';
import LWC_Error from '@salesforce/label/c.LWC_Error';
import USAGE_ERROR from '@salesforce/label/c.USAGE_ERROR';
import New_solution from '@salesforce/label/c.New_Solution';
import Manage_usages from '@salesforce/label/c.Manage_usages';
import USAGE_SUCCESS from '@salesforce/label/c.USAGE_SUCCESS';
import Total_Usage_Error from '@salesforce/label/c.Total_Usage_Error';
import Solutions_and_usages from '@salesforce/label/c.Solutions_and_usages';

/* Definizioni delle colonne per la tabella di soluzioni e consumi */
const consumiColumns = [
    {label: 'Soluzione', fieldName: 'TipoSoluzione', initialWidth: 180, type: 'text'},
    {label: 'Gennaio', fieldName: 'Mese_1__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Febbraio', fieldName: 'Mese_2__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Marzo', fieldName: 'Mese_3__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Aprile', fieldName: 'Mese_4__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Maggio', fieldName: 'Mese_5__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Giugno', fieldName: 'Mese_6__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Luglio', fieldName: 'Mese_7__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Agosto', fieldName: 'Mese_8__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Settembre', fieldName: 'Mese_9__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Ottobre', fieldName: 'Mese_10__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Novembre', fieldName: 'Mese_11__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
    {label: 'Dicembre', fieldName: 'Mese_12__c', editable: 'true', type: 'currency', typeAttributes: { currencyCode: 'EUR'}},
];

export default class OpportunitySoluzioniTopClient extends NavigationMixin(LightningElement){

    @api recordId;

    label = {
        Save,
        Close,
        Cancel,
        Success,
        LWC_Error,
        USAGE_ERROR,
        New_solution,
        Manage_usages,
        USAGE_SUCCESS,
        Total_Usage_Error,
        Solutions_and_usages
    };

    soluzioni = [];
    consumiData = [];
    yearOptions = [];
    editedConsumiData = [];

    showButtons = false;
    showConsumiTable = false;
    showConsumiTableSpinner = false;
    consumiColumns = consumiColumns;
    selectedYear = new Date().getFullYear();

    connectedCallback(){this.init();}

    init(){

        this.initYearOptions();
        this.initSoluzioni();
        this.initConsumi();
    }

    initYearOptions(){

        //Set dei valori di default per la picklist dell'anno di riferimento: i prossimi 3 anni
        let NEXT_N_YEARS = 5;
        for(let i = 0; i < NEXT_N_YEARS; i++)
            this.yearOptions.push({label: (this.selectedYear + i).toString(), value: (this.selectedYear + i).toString()});

        this.selectedYear = this.selectedYear.toString();
    }

    initSoluzioni(){

        this.soluzioni = [];

        //Fetch delle soluzioni legate all'opportunità
        getSoluzioni({opportunityId: this.recordId})
        .then(result => {
            this.soluzioni = result;
            this.showFooter = this.soluzioni.length > 0 ? true : false;
        })
        .catch(error => {
            console.log(JSON.stringify(error)); // eslint-disable-line no-console
        });
    }

    initConsumi(){

        this.consumiData = [];
        let consumidataTemp = [];

        //Fetch dei consumi legati all'opportunità
        getConsumi({opportunityId: this.recordId, year: this.selectedYear})
        .then(result => {

            for(let i = 0; i < this.soluzioni.length; i++){

                let soluzione = this.soluzioni[i];
                let key = soluzione.Id + '_' + this.selectedYear;
                let consumi = result.filter(consumo => consumo.Soluzione_Top_Client__c == soluzione.Id);

                if(consumi.length > 0){

                    let consumo = consumi[0];

                    //Costruzione dei record di consumi recuperati da DB
                    consumidataTemp.push({id: key, TipoSoluzione: consumo.Soluzione_Top_Client__r.Tipo_Soluzione__c,
                        Mese_1__c: consumo.Mese_1__c, Mese_2__c: consumo.Mese_2__c, Mese_3__c: consumo.Mese_3__c, Mese_4__c: consumo.Mese_4__c,
                        Mese_5__c: consumo.Mese_5__c, Mese_6__c: consumo.Mese_6__c, Mese_7__c: consumo.Mese_7__c, Mese_8__c: consumo.Mese_8__c,
                        Mese_9__c: consumo.Mese_9__c, Mese_10__c: consumo.Mese_10__c, Mese_11__c: consumo.Mese_11__c, Mese_12__c: consumo.Mese_12__c});
                }else{

                    //Creazione di record di consumi temporanei in assenza di record da DB
                    consumidataTemp.push({id: key, TipoSoluzione: soluzione.Tipo_Soluzione__c,
                        Mese_1__c: 0, Mese_2__c: 0, Mese_3__c: 0, Mese_4__c: 0,
                        Mese_5__c: 0, Mese_6__c: 0, Mese_7__c: 0, Mese_8__c: 0,
                        Mese_9__c: 0, Mese_10__c: 0, Mese_11__c: 0, Mese_12__c: 0});
                }
            }

            this.consumiData = consumidataTemp;
        })
        .catch(error => {
            console.log(JSON.stringify(error)); // eslint-disable-line no-console
        });
    }

    openConsumiTable(){
        this.showConsumiTable = true;
        this.initConsumi();
    }

    closeConsumiTable(){
        this.editedConsumiData = [];
        this.showButtons = false;
        this.showConsumiTable = false;
    }

    resetTable(){
        this.editedConsumiData = [];
        this.showButtons = false;
    }

    handleYearChange(event){
        this.selectedYear = event.target.value;
        this.initConsumi();
    }

    handleCellChange(event){
        this.showButtons = true;
        event.detail.draftValues[0].year = this.selectedYear;
        this.editedConsumiData.push(event.detail.draftValues[0]);
    }

    saveEditedValues(){

        console.log('$$$' + this.editedConsumiData);

        upsertConsumi({jsonConsumi: JSON.stringify(this.editedConsumiData), year: this.selectedYear})
        .then(result => {

            if(result === 'success'){

                this.resetTable();
                this.initConsumi();

                const evt = new ShowToastEvent({
                    title: this.label.Success,
                    message: this.label.USAGE_SUCCESS,
                    variant: "success"
                });
                this.dispatchEvent(evt);

                eval("$A.get('e.force:refreshView').fire();");

            }else if(result === 'error'){

                const evt = new ShowToastEvent({
                    title: this.label.LWC_Error,
                    message: this.label.USAGE_ERROR,
                    variant: "error"
                });
                this.dispatchEvent(evt);

            }else if(result === 'error_totale_consumi'){

                const evt = new ShowToastEvent({
                    title: this.label.LWC_Error,
                    message: this.label.Total_Usage_Error,
                    variant: "error"
                });
                this.dispatchEvent(evt);
            }

        })
        .catch(error => {
            console.log(JSON.stringify(error)); // eslint-disable-line no-console
        });

    }

    redirectToNew(){

        const defaultFields = encodeDefaultFieldValues({
            Opportunity__c: this.recordId,
            nooverride: 1
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Soluzione_Top_Client__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues : defaultFields
            }
        });
    }

    //Gestione del click sul button menu relativo alla soluzione, con le varie opzioni
    handleClickSoluzione(event){

        if(event.detail.action === 'View')
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    actionName: 'view'
                }
            });

        if(event.detail.action === 'Edit')
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    actionName: 'edit'
                }
            });

        if(event.detail.action === 'Delete'){
            deleteSoluzione({soluzioneId : event.detail.id})
            .then(result =>{

                eval("$A.get('e.force:refreshView').fire();");
                this.initSoluzioni();
                this.initConsumi();

            })
            .catch(error => {
                console.log(JSON.stringify(error)); // eslint-disable-line no-console
            });
        }
    }
}