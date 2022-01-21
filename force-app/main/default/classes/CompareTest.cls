public class CompareTest {
	
    public class Employee implements Comparable{
    public Integer age;
    
    //dal più grande al più piccolo
    public Integer compareTo(Object compareTo) {
        Employee emp = (Employee)compareTo;
        if(this.age == emp.age)		return 0;
        if(this.age > emp.age)     	return -1;
        else			           	return 1;
        }
    }
    /*dal più grande al più piccolo
    public Integer compareTo(Object compareTo) {
        Employee emp = (Employee)compareTo;
        if(this.age == emp.age)		return 0;
        if(this.age > emp.age)		return -1;
        else		          		return 1;
        }
    }*/

    public static List<Employee> getEmpList(){
        
        List<Employee> empList = new List<Employee>();
        for(Account acc: [SELECT Id, Age__c FROM Account WHERE Age__c != null LIMIT 10]){
            Employee e = new Employee();
            e.age = Integer.valueOf(acc.Age__c);
            empList.add(e);
        }
        if(!empList.isEmpty())	empList.sort();
        
        return empList;
    }
}