public class BankAcct {
    private integer balance=0;
    public string acctName;
    //Declare a public string attribute called accttype
    public string accttype;
    public void makeDeposit (integer deposit) {
        balance = balance + deposit;
    }
    //Declare a method named getBalance that returns an integer and no input parameter
    public integer getBalance() {
        //Return the balance attribute
        return balance;
    }
}