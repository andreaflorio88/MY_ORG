@isTest
public class TriggerAssetHandler_Test {
    
    private static Asset getTestAsset(){
        Account acc = new Account();
        acc.Name = 'Mario';
        Asset asset = new Asset();
        asset.Name = 'Test';
        asset.ParentId = null;
        asset.AccountId =acc.Id;
        return asset;
    }
    
    
    private static testmethod void testBeforeInsert() { 
        TriggerAssetHandler trig = new TriggerAssetHandler();
        trig.beforeInsert();
        
        Account acc = new Account();
        acc.Name = 'Mario';
        insert acc;
        Asset asset = new Asset();
        asset.Name = 'Test';
        asset.ParentId = null;
        asset.AccountId =acc.Id;
        insert asset;
        System.debug('@@@ASSET: '+ asset);
        List<Asset> assetList = new List<Asset>();
        assetList.add(asset);
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        try {
            System.runAs(u) {
                insert asset;
            }
        } 
        catch(Exception e){
            asset.addError('error');
        }
        
        
    }
    
}