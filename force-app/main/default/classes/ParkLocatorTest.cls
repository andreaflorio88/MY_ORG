@isTest
public class ParkLocatorTest {
	
    @isTest
    static void test(){
        
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String country = 'USA';
        String[] prks = ParkLocator.country(country);

    }
}