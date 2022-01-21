public class LightningTreeApexController {
    @AuraEnabled
    public static String getTreeData(Id recordId){
        
        // fatherList select father nodes
        List<Asset> fatherList = [Select Id , Name from Asset where accountId =: recordId and ParentId = ''];
        // Set Assets ParentId
            Set<Id> fatherSet = new Set<Id>();
            for (Asset a : fatherList) {
                fatherSet.add(a.Id);
            }
            System.debug('@@@fatherSet'+ fatherSet);
        
        // create AssetChildList
        // opps select child nodes based on each father node
        List<Asset>  childList = [Select Id , Name, ParentId, ReplacedBy__c from Asset where ParentId IN: fatherSet];
        System.debug('@@@childList'+ childList);
		
        // Set Assets ChildId
            Set<Id> ChildSet = new Set<Id>();
            for (Asset a : childList) {
                ChildSet.add(a.Id);
            }
            System.debug('@@@ChildSet'+ ChildSet);
        
        // create AssetReplacedList
        // opps select child Replaced nodes based on each child node
        List<Asset>  childListReplaced = [Select Id , Name, ReplacedBy__c from Asset where Id IN: childSet];
        System.debug('@@@childListReplaced'+ childListReplaced);
        
            List<Items> listItemsFather = new List<Items>();
            for(Asset fatherTemp : fatherList){
                Items conWrapp = new Items();
                conWrapp.name = fatherTemp.Id;
                conWrapp.label= fatherTemp.Name;
                conWrapp.expanded = false ;
            	listItemsFather.add(conWrapp);
                
            List<Items> listItemsChild = new List<Items>();
            for (Asset childTemp : childList ) {
                if(childTemp.ParentId.equals(fatherTemp.Id)) {
                    System.debug('@@@fatherTemp.Id: '+ fatherTemp.Id);
                    System.debug('@@@childTemp.ParentId: '+ childTemp.ParentId);
                    Items itemChild = new Items(); 
                    itemChild.name = childTemp.Id ;
                    itemChild.label = childTemp.Name ;
                    itemChild.expanded = false ;
                    listItemsChild.add(itemChild);         
                    
            List<Items> listReplaced = new List<Items>();
            for (Asset childReplaced : childListReplaced ) {
                if(childReplaced.Id.equals(childTemp.ReplacedBy__c /* && childReplaced.Replaced__c */)) {
                    System.debug('@@@childReplaced.Id: '+ childReplaced.Id);
                    System.debug('@@@childTemp.ReplacedBy__c: '+ childTemp.ReplacedBy__c);
                    Items itemChildReplaced = new Items(); 
                    itemChildReplaced.name = childReplaced.ReplacedBy__c ;
                    itemChildReplaced.label = childReplaced.Name ;
                    itemChildReplaced.expanded = false ;
                    listReplaced.add(itemChildReplaced);         
                }
            }
                itemChild.items =listReplaced;
                }
                conWrapp.items =listItemsChild ;
            	}
            } 
        return JSON.serializePretty(listItemsFather) ;    
    } 

    public Class Items{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String ParentId {get;set;}
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Boolean expanded {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    	
    }  
}