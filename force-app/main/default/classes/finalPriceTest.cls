public virtual class finalPriceTest{
    

	// the current context of the trigger, overridable in tests
	@TestVisible
	private TriggerContext context;

	// the current context of the trigger, overridable in tests
	@TestVisible
	private Boolean isTriggerExecuting;


	public finalPriceTest() {
		this.setTriggerContext();
	}

	public void run() {


		// dispatch to the correct handler method
		if(this.context == TriggerContext.BEFORE_INSERT) {
			this.beforeInsert();
		} else if(this.context == TriggerContext.BEFORE_UPDATE) {
		  	this.beforeUpdate();
		} else if(this.context == TriggerContext.BEFORE_DELETE) {
		  	this.beforeDelete();
		} else if(this.context == TriggerContext.AFTER_INSERT) {
		  	this.afterInsert();
		} else if(this.context == TriggerContext.AFTER_UPDATE) {
		  	this.afterUpdate();
		} else if(this.context == TriggerContext.AFTER_DELETE) {
		  	this.afterDelete();
		} else if(this.context == TriggerContext.AFTER_UNDELETE) {
		  	this.afterUndelete();
		}
	}
	@TestVisible
	protected virtual void beforeInsert(){}

	@TestVisible
	protected virtual void beforeUpdate(){}

	@TestVisible
	protected virtual void beforeDelete(){}

	@TestVisible
	protected virtual void afterInsert(){}

	@TestVisible
	protected virtual void afterUpdate(){}

	@TestVisible
	protected virtual void afterDelete(){}

	@TestVisible
	protected virtual void afterUndelete(){}

	private Boolean inTestContextEquals(TriggerContext cnt){
		return Test.isRunningTest() && this.context == cnt;
	}
	@TestVisible
	private void setTriggerContext() {

		if(!Trigger.isExecuting && !Test.isRunningTest()) {

		  this.isTriggerExecuting = false;
		  return;
		} 
		else {
		  this.isTriggerExecuting = true;
		}

		if( inTestContextEquals(TriggerContext.BEFORE_INSERT) || (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert )) {

			this.context = TriggerContext.BEFORE_INSERT;

		} 
		else if( inTestContextEquals(TriggerContext.BEFORE_UPDATE) || ( Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate )) {

		  this.context = TriggerContext.BEFORE_UPDATE;

		}
		else if( inTestContextEquals(TriggerContext.BEFORE_DELETE) || ( Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete )) {

		  this.context = TriggerContext.BEFORE_DELETE;

		}
		else if( inTestContextEquals(TriggerContext.AFTER_INSERT) || ( Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert )) {

		  this.context = TriggerContext.AFTER_INSERT;

		}
		else if( inTestContextEquals(TriggerContext.AFTER_UPDATE) || ( Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate )) {

		  this.context = TriggerContext.AFTER_UPDATE;

		}
		else if(  inTestContextEquals(TriggerContext.AFTER_DELETE) || ( Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete )) {

		  this.context = TriggerContext.AFTER_DELETE;

		} 
		else if( inTestContextEquals(TriggerContext.AFTER_UNDELETE) || ( Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete )) {

		  this.context = TriggerContext.AFTER_UNDELETE;

		}
	}


	// possible trigger contexts
	@TestVisible
	private enum TriggerContext {

		BEFORE_INSERT,
		BEFORE_UPDATE,
		BEFORE_DELETE,
		AFTER_INSERT,
		AFTER_UPDATE,
		AFTER_DELETE,
		AFTER_UNDELETE
	}


}