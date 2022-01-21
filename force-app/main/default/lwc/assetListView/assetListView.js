import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getRecords from '@salesforce/apex/searchAccountController.getRecords';

const columns = [
    {label: 'Action', fieldName: 'Action', type: 'button',  
        typeAttributes: {
            label: { fieldName: 'Action' },
            name: 'Id',
            variant: 'Base'
        }
    },
    {label: 'Section', fieldName: 'Section', type: 'text'},
    {label: 'Created By', fieldName: 'CreatedByName', type: 'text'},
    {label: 'Created Date', fieldName: 'CreatedDate', type: "date",
        typeAttributes:{ 
            year: "numeric",
            month: "long",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }
    }

];

export default class AuditTrailViewer extends NavigationMixin(LightningElement) {
    @track _records = [];
    @track error;
    queryOffset;
    queryLimit;
    totalRecordCount;
    columns = columns; 

    constructor(){
        super();
        this.queryOffset = 0;
        this.queryLimit = 5;
        this.loadRecords();
    }

    loadMoreData(event){
        const { target } = event;
        //Display a spinner to signal that data is being loaded
        target.isLoading = true;
        if(this.totalRecordCount > this.queryOffset){
            this.queryOffset = this.queryOffset + 5;
            this.loadRecords()
                .then(()=> {
                    target.isLoading = false;
                });
        } else {
            target.isLoading = false;
        }
        
    }

    loadRecords(){
        let flatData;
        return getRecords({queryLimit: this.queryLimit, queryOffset: this.queryOffset})
        .then(result => { 
            this.totalRecordCount = result.totalRecordCount;
            flatData = JSON.parse(JSON.stringify(result.auditTrailRecords));
            flatData.forEach(function(entry) {
                // flatten the data to that it can be directly consumed by data table
                if (entry.CreatedBy){
                    entry.CreatedByName = entry.CreatedBy.Name;
                }
            });
            let updatedRecords = [...this._records, ...flatData];
            this._records = updatedRecords;
            this.error = undefined; 
        })
        .catch(error => { 
            this.error = error ;
        })
    }

    get records() {
        return this._records.length ? this._records : null;
    }

    handleRowAction(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                actionName: "view",
                recordId: event.detail.row.Id
            }
        });
    }
    
}