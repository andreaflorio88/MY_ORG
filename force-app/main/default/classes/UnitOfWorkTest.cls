@isTest
public class UnitOfWorkTest {
    
    @isTest static void challengeComplete(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType,
                Contact.SObjectType,
                Note.SObjectType
            }
        );
        
        for (Integer i=0 ; i<100 ; i++) {
            Account a = new Account(Name= 'Test' + i);
            uow.registerNew(a);
            
            for (Integer j=0 ; j<5 ; j++) {
                Contact c = new Contact(LastName = 'Test'+i + ' ' +j);
                uow.registerNew(c, Contact.AccountId, a);
                
                Note n = new Note(Body='Test '+i + '' + j, Title='Test'+i+j);
                uow.registerRelationship(n, Note.ParentId, a);
                uow.registerNew(n, Note.ParentId, a);
            }
        }

        uow.commitWork();
 
        fflib_SObjectUnitOfWork uow2 = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType,
                Contact.SObjectType,
                Note.SObjectType
            }
        );        
        for (Account a : [SELECT Id, Name, (SELECT Id, LastName FROM Contacts), (SELECT Id, ParentId, Title, Body FROM Notes) FROM Account]) {
            a.Name = 'Test';
            uow2.registerDirty(a);
            
            Integer i = 0;
            for (Contact c : a.Contacts) {
                c.LastName = 'Test';
                uow2.registerDirty(c);
                
                a.Notes[i].Body='Test';
                uow2.registerDirty(a.Notes[i]);
                i++;
            }
        }        
        
        test.startTest();
        uow2.commitWork();
        test.stopTest();
        
        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());
    }
}