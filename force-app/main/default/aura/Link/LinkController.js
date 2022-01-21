({
    
    doInit : function(component, event, helper) {
        console.log('doInit method started');
        //if(component.get('v.recordId') != null){  
        helper.checkParameter(component);
        //}
	},

   copyText : function(cmp, event){
     var urlClassic = document.getElementById('urlClassic');
     urlClassic.select();
     document.queryCommandSupported('copy');
     document.execCommand('copy');
     var source = event.getSource();
     source.set('v.label', 'COPIED');
     setTimeout(function(){
      source.set('v.label', 'Copy to Clipboard');
     }, 1000);
   } 
})