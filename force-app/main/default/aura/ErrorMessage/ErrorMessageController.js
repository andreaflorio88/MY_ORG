({
	init: function(cmp) {
    var list = cmp.get('v.errorlist');
    // Some logic
	cmp.set('v.errorlist', list); 
    }, 
    close: function(cmp, evt,helper) {
		cmp.set("v.alert",false);
	}
})