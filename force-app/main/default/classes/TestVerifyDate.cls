@isTest
public class TestVerifyDate {
public static testmethod void verifyDate()
    {   
        date d=system.today();
        date d1=date.parse('12/05/2016');
        date d2=system.today()+1;
        VerifyDate.CheckDates(d,d1);
        VerifyDate.CheckDates(d,d2);
    }
}