trigger Phone on Contact (before insert,before update) {

    for(Contact r:trigger.new){
    
    if(r.Phone == null && r.MobilePhone == null){
        r.Phone.addError('Insert a number');
        r.MobilePhone.addError('Insert a number');
        }
    }
}