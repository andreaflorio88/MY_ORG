trigger ChangeStatus on Case (before update) {

    new TriggerHandler().run();
}