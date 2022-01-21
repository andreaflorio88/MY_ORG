public class TreeGridExamples {
    @AuraEnabled
    public static String getTreeGridData(Id accountId){
        List<Asset> assetList = [Select Id , Name, Status, InstallDate,(Select Id , Name, Status, InstallDate from ChildAssets) from Asset where accountId=: accountId and ParentId = null and Status = 'Active' /*and Product2.Family = 'RRP1 KIT'*/];
        
        List<AssetWrapper> aooo = new List<AssetWrapper>();
        for(Asset a : assetList){
            AssetWrapper aWraper = new AssetWrapper() ; 
            aWraper.name =a.name;
            aWraper.status =a.Status;
            aWraper.label =a.InstallDate;
            List<Items> co = new List<Items>();
            for(Asset c : a.ChildAssets){
                Items conWrapp = new Items();
                conWrapp.name =c.Name;
                conWrapp.status =c.Status;       
                conWrapp.label =c.InstallDate; 
                
                co.add(conWrapp);
            }
            aWraper.items = co;
            aooo.add(aWraper);
        }
        return JSON.serializePretty(aooo) ;
    } 
    public Class AssetWrapper{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String status {get;set;}
        @AuraEnabled
        public Date label {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }
    public Class Items{
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String status {get;set;}
        @AuraEnabled
        public Date label {get;set;}
        @AuraEnabled
        public List<Items> items {get;set;}
    }
    
}