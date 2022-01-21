public class TreeNodeDataProvider {
    @AuraEnabled public static Asset[] getUserRoles(Id recordId) {
        return [SELECT Id, Name, ReplacedBy__c,ParentId FROM Asset where accountId =: '0010N00004KzgwCQAR'];
    }
}