/**
 * Created by cge01625 on 03/07/2019.
 */
import { LightningElement, track,  api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchAccount from '@salesforce/apex/searchAccountController.searchAccount';
import deleteRecord from '@salesforce/apex/searchAccountController.deleteRecord';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Active', fieldName: 'IsActive__c', type: 'boolean', cellAttributes: { alignment: 'right' }},
    { label: 'Age', fieldName: 'Age__c', type: 'text' },
    { label: 'Data Creazione', fieldName: 'CreatedDate', type: "date-local",
                                                                 typeAttributes:{
                                                                     month: "2-digit",
                                                                     day: "2-digit"
                                                                 } },
    { label: 'Link', fieldName: 'linkName', type: 'url',
        cellAttributes: { iconName: 'utility:share', iconAlternativeText: 'Go to record!' },
         typeAttributes: { label: {fieldName: 'Id'} }},
    {
    type: 'action',
    typeAttributes: { rowActions: actions },
    },
];

export default class Searchlog extends NavigationMixin(LightningElement){
    
    @api isLoaded = false;
    accountId;
    data = [];
    columns = columns;
    rowOffset = 0;

    handleKeyUp(evt) {
        this.isLoaded = !this.isLoaded;

        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {

            this.accountId = evt.target.value;

            searchAccount({accountId : this.accountId})
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

    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const accountId = event.detail.row.Id;

        if(actionName === 'edit')
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: accountId,
                    actionName: 'edit'
                }
            });
        
        if(actionName === 'delete')
            deleteRecord({accountId : accountId})
            .then(result => {
               
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "Record cancellato correttamente",
                    variant: "success"
                });
                this.dispatchEvent(evt);
                eval("$A.get('e.force:refreshView').fire();");
            })

            .catch(error => {

                const evt = new ShowToastEvent({
                    title: "Error",
                    message: "Ops, Qualcosa è andato storto",
                    variant: "error"
                });
                this.dispatchEvent(evt);
                console.log(JSON.stringify(error)); // eslint-disable-line no-console
            });
    }

}