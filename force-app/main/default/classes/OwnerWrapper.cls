/*Custom classes used for component attributes shouldn’t be inner classes or use inheritance. 
* While these Apex language features might work in some situations, there are known issues, and their use is unsupported in all cases.*/
public class OwnerWrapper{
    @AuraEnabled
    public String ownerName;
    @AuraEnabled
    public Id ownerId;
    @AuraEnabled
    public Boolean isQueue;
    
    public OwnerWrapper(String ownerName, Id ownerId, Boolean isQueue){
        this.ownerName = ownerName;
        this.ownerId = ownerId;
        this.isQueue = isQueue;
    }
}