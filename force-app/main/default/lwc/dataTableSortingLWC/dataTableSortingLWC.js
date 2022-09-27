import {LightningElement, wire, track} from 'lwc';
import getContacts from '@salesforce/apex/LWCDataTableSortingExample.getContacts';

// datatable columns with row actions. Set sortable = true
const columns = [ { label: 'FirstName', fieldName: 'FirstName', sortable: "true", hideDefaultActions: "true"},
                  { label: 'LastName', fieldName: 'LastName', sortable: "true", hideDefaultActions: "true"},
                  { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: "true", hideDefaultActions: "true"},
                  { label: 'Email', fieldName: 'Email', type: 'email', sortable: "true", hideDefaultActions: "true" }];

export default class DataTableSortingLWC extends LightningElement {
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
 
    @wire(getContacts)
    contacts(result) {
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }    

    handleRowAction(event){
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();;
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
   
            let ids = '';
            selectedRecords.forEach(currentItem => {
                ids = ids + ',' + currentItem.Id;
            });
            this.selectedIds = ids.replace(/^,/, '');
            this.lstSelectedRecords = selectedRecords;
            console.log(this.selectedIds);
        } 
    }
}