import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

const COLUMNS = [   
    {label: 'Id', fieldName: 'linkName', type: 'url', typeAttributes: { label: {fieldName: 'Name'} }},
    { label: 'Email', fieldName: 'Email' }
];

export default class LdsGetRelatedListRecords extends NavigationMixin(LightningElement) {

    @api recordId;

    recordCount;
    records;
    columns = COLUMNS;

    @wire( getRelatedListRecords, {

        parentRecordId: '$recordId',
        relatedListId: 'Contacts',
        fields: [ 'Contact.Id', 'Contact.Name', 'Contact.Email' ]

    })listInfo({ error, data }) {

        if (data) {

            console.log( 'Data is', JSON.stringify( data ) );
            let tempRecords = [];

            data.records.forEach( obj => {
                console.log( 'obj is', JSON.stringify( obj ) );
                let tempRecord = {};
                tempRecord.linkName = '/' + obj.fields.Id.value;
                tempRecord.Name = obj.fields.Name.value;
                tempRecord.Email = obj.fields.Email.value;
                tempRecords.push( tempRecord );
            } );

            this.records = tempRecords;
            this.recordCount = data.count;
            console.log( 'Records are ' + JSON.stringify( this.records ) );
            
        } else if(error) {
            this.records = undefined;
        }
    }

    goToRelatedList(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                //objectApiName: 'Contact',
                relationshipApiName: 'Contacts',
                actionName: 'view'
            }
        });
    }
}