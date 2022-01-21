@isTest
public class LightningTreeApexController_Test {
	@isTest
    private static void doTest() {
        LightningTreeApexController sc = new LightningTreeApexController();
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        String rt = LightningTreeApexController.getTreeData(acc.Id);
        
    }
}