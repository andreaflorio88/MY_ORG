@isTest
private class ControllerLink_Test {
    
    @isTest(seeAllData=false)
    private static void doTest() {
        
        ControllerLink cas = new ControllerLink();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        String ret = ControllerLink.getParameter(acc.Id);
        
    }
}