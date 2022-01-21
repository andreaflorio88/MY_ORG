public class ParkLocator {
	
    public static String[] country(String country){
		
        ParkService.ParksImplPort prk = new ParkService.ParksImplPort(); 
        return prk.byCountry(country);
    }
}