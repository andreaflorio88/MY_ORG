public class finalPrice extends finalPriceTest{

   protected override void beforeUpdate(){
   
   List<Account> accList = Trigger.new;
      for(Account acc : accList){
         if(acc.Price__c == null || acc.Price__c == 0) {
         acc.Price__c.AddError('Price not valid');
         }
      }
   /*
   public void run2(){
      for(SObject currObj : Trigger.new){
      // set current object Account 
      Account acc = (Account) currObj;
         if(acc.Fax == null) {
            acc.Fax.AddError('Fax not valid');
         }
      }
   }

   public void run3(){
      List<Account> accList = Trigger.new;
         for(Account acc : accList){
            if(String.isBlank(acc.Type)) {
            acc.Type.AddError('Type not valid');
            }
         }
      }*/
   }
}