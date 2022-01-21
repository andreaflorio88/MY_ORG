import { LightningElement, track } from 'lwc';
import searchAccountView from '@salesforce/apex/searchAccountController.searchAccountView';

const columnList = [
    {label: 'Id', fieldName: 'Id'},
    {label: 'Name', fieldName: 'Name'},
    {label: 'Website', fieldName: 'Website'},
    {label: 'Industry', fieldName: 'Industry'}
];

export default class LightningDataTable extends LightningElement {
    @track accountList;
    @track columnList = columnList;
    @track noRecordsFound = true;

    findAccountResult(event) {
        const accName = event.target.value;

        if(accName) {
            searchAccountView ( {accName}) 
            .then(result => {
                this.accountList = result;
                this.noRecordsFound = false;
            })
        } else {
            this.accountList = undefined;
            this.noRecordsFound = true;
        }
    }

}