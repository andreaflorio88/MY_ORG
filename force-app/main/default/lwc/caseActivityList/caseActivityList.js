import { refreshApex } from '@salesforce/apex';
import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getActivities from '@salesforce/apex/CaseActivityListClass.getActivities';

/* Custom Labels */
import Activities from '@salesforce/label/c.Activities';
import CollapseAll from '@salesforce/label/c.CollapseAll';
import ExpandAll from '@salesforce/label/c.ExpandAll';

export default class CaseActivityList extends NavigationMixin(LightningElement) {

    @api recordId;
    @api limit;

    label = {
        Activities,
        CollapseAll,
        ExpandAll
    };

    showDescription = false;
    linkLabel = this.label.ExpandAll;

    @wire(getActivities, {caseId: '$recordId', max_result: '$limit'})
    activities;

    goToRecord(event){

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.id,
                objectApiName: event.target.dataset.objapiname,
                actionName: 'view'
            }
        });
    }

    goToActivityHistory(event){

        if(this.activities.data){

            this[NavigationMixin.Navigate]({
                type: 'standard__recordRelationshipPage',
                attributes: {
                    recordId: this.activities.data[0].accountId,
                    objectApiName: event.target.dataset.objapiname,
                    relationshipApiName: 'ActivityHistories',
                    actionName: 'view'
                }
            });
        }
    }

    handleShowDescription(){
        this.showDescription = !this.showDescription;
        this.linkLabel = this.linkLabel == this.label.ExpandAll ? this.label.CollapseAll : this.label.ExpandAll;
    }

    refresh(){
        console.log('refresh');
        refreshApex(this.activities);
    }
}