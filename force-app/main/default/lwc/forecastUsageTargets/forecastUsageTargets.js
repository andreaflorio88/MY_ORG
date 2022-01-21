import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

import USER_ID from '@salesforce/user/Id';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';

import upsertData from '@salesforce/apex/ForecastUsageTargetsClass.upsertData';
import getData from '@salesforce/apex/ForecastUsageTargetsClass.getSubordinatesData';
import getOpportunities from '@salesforce/apex/ForecastUsageTargetsClass.getOpportunities';
import updateOpportunities from '@salesforce/apex/ForecastUsageTargetsClass.updateOpportunities';

/* Importazione delle Custom Labels */
import Save from '@salesforce/label/c.Save';
import Close from '@salesforce/label/c.Close';
import Cancel from '@salesforce/label/c.Cancel';

/* Definizione delle colonne per la tabella di opportunità */
const oppColumns = [
    {label: 'Cliente', fieldName: 'AccountName', type: 'text'},
    {label: 'Piattaforma', fieldName: 'Natura__c',  type: 'text', },
    {label: 'Imp.Consumi Anno', fieldName: 'Totale_Importo_Consumi__c',  type: 'text'},
    {label: 'Stage', fieldName: 'StageName',  type: 'text', editable: 'true'},
    {label: 'Motivazione', fieldName: 'Motivazione_Downgrade__c',  type: 'text', editable: 'true'},
    {label: 'Probabilità', fieldName: 'Probability',  type: 'text'},
    {label: 'Priorità', fieldName: 'Priorita_Automatica__c',  type: 'text'},
    {label: 'Data Chiusura', fieldName: 'CloseDate',  type: 'date-local', editable: 'true', typeAttributes:{
         year: "numeric", month: "2-digit", day: "2-digit" }},
    {label: 'Proprietario', fieldName: 'OwnerName',  type: 'text'},
    {label: 'Dettagli Opportunità', type: "button", typeAttributes: {
        label: 'Dettagli', name: 'Dettagli', title: 'Dettagli', disabled: false, value: 'dettagli' }},
    {label: 'Link Opportunità', fieldName: 'linkName', type: 'url', typeAttributes: { label: {fieldName: 'Id'} }},	

];
export default class ForecastUsageTargets extends LightningElement {

    @api objectApiName;

    Q1;
    Q2;
    Q3;
    Q4;
    year;
    data;
    month;
    oppData;
    viewOpp;  
    criterio;
    userId;     // Current UserId
    userIdAM;   // Area Manager UserId
    tempUserId  // UserId temporaneo
    oppUserId;  // UserId per caricare le Opp.tà
    dateOptions;
    toggleLabel;
    topClientRtId;
    opportunityId;
    showComponent;
    criterioQuarter;
    oppColumns = oppColumns;

    options = [];
    draftValues = [];


    //Label
    label = {Close, Save, Cancel};

    //Boolean
    editMode;
    showModal;
    showError;
    showTable;
    isLoading;
    showQuotas;
    showButtons;
    editRetMode;
    editTarMode;
    showDetails;
    isLoadingModal;
    showConsumiTable;
    isNavigationMode;
    isPersonalForecast;

    //recupero il RT Id di TopClient
    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    oppObjectInfo({data, error}) {
        if(data) {
            // getting map values
            let rtValues = Object.values(data.recordTypeInfos);

            for(let i = 0; i < rtValues.length; i++) {
                // console.log(rtValues[i].name);
                if(rtValues[i].name === '16-Top Client')
                    this.topClientRtId = rtValues[i].recordTypeId;
            }
        }
        else if(error) {
            console.log('Error ===> '+JSON.stringify(error));
        }
    }
    
    //recupero i valori della picklist StageName del RT TopClient
    @wire(getPicklistValuesByRecordType, { objectApiName: 'Opportunity', recordTypeId: "$topClientRtId"}) 
    stagePicklistValues({error, data}) {
        if(data)
            this.options = data.picklistFieldValues.StageName.values;
            // console.log('this.options: ' + JSON.stringify(this.options));
        else if(error) 
            console.log('error =====> '+JSON.stringify(error));
    }

    connectedCallback(){
        this.init();
    }

    backToHomePage(){
        this.isLoading = true;
        this.tempUserId = USER_ID;
        this.isNavigationMode = false;
        this.initData(USER_ID, this.month, this.year, this.criterioQuarter == '' ? this.criterio : this.criterioQuarter);
    }

    refreshData(){
        this.isLoading = true;
        this.initData(this.tempUserId, this.month, this.year, this.criterioQuarter == '' ? this.criterio : this.criterioQuarter);
    }

    init(){

        this.showComponent = true;
        this.toggleLabel = 'Apri';
        this.dateOptions = [];
        this.criterioQuarter = '';
        this.userId = USER_ID;
        this.tempUserId = USER_ID;

         //Init dei valori per la picklist del periodo
        let currDate = new Date();
        let currMonth = currDate.getMonth()
        let currYear = currDate.getFullYear();
        //let limit = currMonth + 7;
        const formatter = new Intl.DateTimeFormat('it-IT', { month: 'long', year: 'numeric'});

        for(let i = 0; i < 12; i++){
            let currMonth = i % 12;
            let formattedDate = formatter.format(new Date(currYear, currMonth, 1));
            this.dateOptions.push({id: (currMonth + '-' + currYear), isSelected: (i == currDate.getMonth()), name: (formattedDate[0].toUpperCase() + formattedDate.slice(1))});

            // if(currMonth == 11)
            //     currYear += 1;
        }

        this.dateOptions.push({id: ('AC'), name: ('Anno in corso')});
        this.dateOptions.push({id: ('PA'), name: ('Prossimo anno')});

        //Init del periodo di default
        this.month = parseInt(this.dateOptions[currDate.getMonth()].id.split('-')[0]) + 1;
        this.year = this.dateOptions[0].id.split('-')[1];
        this.criterio = '';
        this.initData(this.userId, this.month, this.year, this.criterio);
    }

    toggleQuotas(){
        //toggle per la visualizzazione della LWC
        this.showQuotas = !this.showQuotas;

        if(this.showQuotas)
            this.toggleLabel = 'Chiudi';
        else
            this.toggleLabel = 'Apri';
    }

    initData(userIdRequested, monthRequested, yearRequested, criterioRequested){

        this.data = [];
        this.editMode = false;
        this.showTable = false;
        this.showModal = false;
        this.showError = false;
        this.editRetMode = false;
        this.editTarMode = false;
        this.showButtons = false;
        this.showConsumiTable = false;
        this.isPersonalForecast = true;

        this.viewOpp = this.criterio != 'AC' && this.criterio != 'PA' && !this.Q1 && !this.Q2 && !this.Q3 && !this.Q4? true : false;
        
        this.oppData = [];
        this.quotasToUpsert = [];

        getData({userId: userIdRequested, criterio: criterioRequested, year: yearRequested, month: monthRequested})
        .then(result => {
            if(result.length > 0){
                this.isLoading = false;
                if(result.length == 1)
                    this.isPersonalForecast = true;
                
                if(result.length > 1)
                    this.isPersonalForecast = false;

                this.showComponent = true;
                this.data = result;
            }
        })
        .catch(error => {
            console.error('Error: ' + JSON.stringify(error));
            this.isLoading = false;
        });
        
    }

    toggleEditMode(){
        //toggle per la modifica dei campi Target Annuale e Rettifica Usage
        if(!this.Q1 && !this.Q2 && !this.Q3 && !this.Q4){

            this.editMode = !this.editMode;

            if(this.criterio != 'AC' && this.criterio != 'PA')
                this.editRetMode = !this.editRetMode;
            else
                this.editTarMode = !this.editTarMode;

            if(!this.editMode)
                this.quotasToUpsert = [];
        }
    }

    handleMonthChange(evt){
        //combobox del periodo
        this.isLoading = true;
        this.month = parseInt(evt.target.value.split('-')[0]) + 1;
        this.year = evt.target.value.split('-')[1];
        this.criterio = evt.target.value;
        this.resetToggle();
        this.initData(this.tempUserId, this.month, this.year, this.criterio);
    }

    handleRowChange(evt){
        //construzione degli array per l'aggiornamento di Target Annuale e Rettifica Usage
        let match = false;

        this.quotasToUpsert.forEach(quota => {                                               
                                                if(quota.Id == evt.target.name){
                                                    match = true;
                                                    if(this.criterio != 'AC' && this.criterio != 'PA')
                                                        quota.rtf = evt.target.value;
                                                    else
                                                        quota.quotaAmount = (evt.target.value);
                                                }
                                            });

        if(this.criterio == 'AC' || this.criterio == 'PA'){   

            let year = this.criterio == 'AC' ? new Date().getFullYear() : new Date().getFullYear() + 1;
            
            for(let i = 1; i <= 12; i++){
                if(!match && evt.target.dataset.fid)
                    this.quotasToUpsert.push({Id: evt.target.name, userId: evt.target.dataset.uid, forecastId: evt.target.dataset.fid, key: year+'-'+i+'-'+evt.target.dataset.key.split('-')[2], quotaAmount:(evt.target.value)});
                if(!match && !evt.target.dataset.fid) 
                    this.quotasToUpsert.push({Id: evt.target.name, userId: evt.target.dataset.uid, key: year+'-'+i+'-'+evt.target.dataset.key.split('-')[2], quotaAmount:(evt.target.value)});
            }
        } 
        else {
            
            if(!match && evt.target.dataset.fid)                                 
                this.quotasToUpsert.push({Id: evt.target.name, userId: evt.target.dataset.uid, forecastId: evt.target.dataset.fid, key: evt.target.dataset.key, rtf: evt.target.value});

            if(!match && !evt.target.dataset.fid)
                this.quotasToUpsert.push({Id: evt.target.name, userId: evt.target.dataset.uid, key: evt.target.dataset.key, rtf: evt.target.value});
        }
    }

    saveGoals(){
        //salvataggio degli obiettivi
        this.isLoading = true;
        upsertData({quotasToUpsert_json: JSON.stringify(this.quotasToUpsert), month: this.month, year: this.year})
        .then(result => {
            
            if(!result){
                const evt = new ShowToastEvent({
                    title: "Errore.",
                    message: "Si è verificato un errore durante l'aggiornamento dei riepiloghi",
                    variant: "error"
                });
                this.dispatchEvent(evt);
            }
            this.initData(this.tempUserId, this.month, this.year, this.criterio);

        })
        .catch(error => {
            console.log('Error: ' + error);

            const evt = new ShowToastEvent({
                title: "Errore.",
                message: "Si è verificato un errore durante l'aggiornamento dei riepiloghi",
                variant: "error"
            });

            this.dispatchEvent(evt);
            this.isLoading = false;
        });
    }

    getOpp(evt){
        //al click sul nome dell'agente vengono recuperate le sue opportunità
        this.isLoadingModal = true;
        this.oppUserId = evt.target.dataset.uid;
        this.showModal = !this.showModal;
        this.getOpps(this.month, this.year, this.oppUserId);
    }
    
    getOpps(month, year, oppUserId){
    //metodo comune per il recupero delle opportunità
        getOpportunities({mese : month, anno : year, userId : oppUserId})
            .then(result => {

                if(result.length == 0){
                    this.showError = true;
                    this.isLoadingModal = false;
                } 
                else {	
                    this.oppData = result;
                    var records = this.oppData;
                    records.forEach(function(record){
                        record.linkName = '/' + record.Id;
                        record.AccountName = record.Account.Name;
                        record.OwnerName = record.Owner.Name;
                    });
                    this.oppData = records;
                    this.showTable = true;
                    this.isLoadingModal = false;
                }
            })
            .catch(error => {
                console.log(error);
                
                const evt = new ShowToastEvent({
                    title: "Errore.",
                    message: "Si è verificato un errore durante il caricamento il recupero delle opportunità",
                    variant: "error"
                });
                
                this.dispatchEvent(evt);
                this.isLoadingModal = false;
            });
    }
	
	closeOpportunityTable(){
        //chiusura della tabella delle opportunità e reset dei parametri
        this.oppData = [];
        this.consumiData = [];
        this.showError = false;
        this.showTable = false;
        this.showModal = false;
        this.showDetails = false;

        //la maschera di riepilogo verrà ricaricata per recuperare eventuali modifiche
        this.isLoading = true;
        this.initData(this.tempUserId, this.month, this.year, this.criterio);
    }

    handleRowAction(evt){
        //pulsante di dettaglio sulla tabelle delle opportunità per visualizzare i consumi
        this.opportunityId = evt.detail.row.Id;
        this.showModal = false;
        this.showConsumiTable = true;
    }

    closeConsumiTable(){
        //chiusura della tabella dei consumi
        this.showConsumiTable = false;
        this.showModal = true;  
    }

    showStageValues(){
        //pulsante per la visualizzazione dei valori di Stage Ammessi
        this.showDetails = !this.showDetails;
    }

    viewPrevisioni(evt){
        //toggle per la visualizzazione delle previsioni per Quarter
        this.isLoading = true;
        
        //se il toggle viene selezionato si attiverà la visualizzazione multipla
        if(evt.target.checked){

            if(this.criterioQuarter == '')
                this.criterioQuarter = evt.target.label;
            else 
                this.criterioQuarter += ',' + evt.target.label;

            this.intiToggle(evt, true);
            this.initData(this.tempUserId, this.month, this.year, this.criterioQuarter);
        }
        /*se il toggle viene deselezionato si verificherà se ci sono altri toggle attivi.
        in caso contratio verrà visualizzato l'ultimo periodo selezionato*/
        else if(!evt.target.checked){
            
            this.intiToggle(evt, false);
            this.criterioQuarter = this.criterioQuarter.replace(',' + evt.target.label, '');
            this.criterioQuarter = this.criterioQuarter.replace(evt.target.label, '');

            if(this.criterioQuarter == '')
                this.initData(this.tempUserId, this.month, this.year, this.criterio);
            else 
                this.initData(this.tempUserId, this.month, this.year, this.criterioQuarter);
        }
    }

    resetToggle(){
        //reset dei toggle quando cambio il periodo
        this.Q1 = false;
        this.Q2 = false;
        this.Q3 = false;
        this.Q4 = false;
        this.criterioQuarter = '';
    }

    intiToggle(evt, value){
        //switch on/off dei toggle
        switch(evt.target.label) {
            case '1Q':
                this.Q1 = value;
                break;
            case '2Q':
                this.Q2 = value;
                break;
            case '3Q':
                this.Q3 = value;
                break;
            case '4Q':
                this.Q4 = value;
                break;
        }
    }

    async handleSave(event) {
        //salvataggio delle Opportunità con reset della tabella
        this.isLoadingModal = true;
        const updatedFields = event.detail.draftValues;
        
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });
    
       // Pass edited fields to the updateContacts Apex controller
        await updateOpportunities({data: updatedFields})
        .then(result => {

            if(result == 'Success'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Salvataggio avvenuto con successo',
                        message: 'Opportunità aggiornata',
                        variant: 'success'
                    })
                );

                // Refresh data in the datatable
                this.oppData = [];
                this.getOpps(this.month, this.year, this.oppUserId);

                this.draftValues = [];


            } else {
                console.log('Error: '+ JSON.stringify(result));
                let errorLog = JSON.stringify(result);
                let validationError = "Prima di proseguire è necessario aggiornare il campo";
                let errorMessage = errorLog.includes(validationError) ? 'Assicurati di aver inserito un valore valido nel campo Stage o di aver aggiornato il campo Motivazione' : 
                                                                        "Si è verificato un errore durante l'aggiornamento delle opportunità";
        
                const evt = new ShowToastEvent({
                    title: "Errore.",
                    message: errorMessage,
                    variant: "error"
                });
                this.isLoadingModal = false;
                this.dispatchEvent(evt);
            }
        
        }).catch(error => {
            console.log('Error: '+ JSON.stringify(error));

            const evt = new ShowToastEvent({
                title: "Errore.",
                message: "Si è verificato un errore durante l'aggiornamento delle opportunità",
                variant: "error"
            });
            this.isLoadingModal = false;
            this.dispatchEvent(evt);
        });
        
    }

    viewRecordAM(evt){
        /*il Regional Manager vedrà gli agenti dell'Area Manager selezionato
        oppure il Direttore vedrà gli Area Manager del Regional Manager selezionato*/
        this.userIdAM = evt.target.dataset.uid;
        this.tempUserId = this.userIdAM;
        this.isLoading = true;
        this.isNavigationMode = true;
        this.initData(this.userIdAM, this.month, this.year, this.criterioQuarter == '' ? this.criterio : this.criterioQuarter);
    }

}