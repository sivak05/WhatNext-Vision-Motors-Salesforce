trigger VehicleOrderTrigger on Vehicle_Order__c
(before insert, before update, after insert, after update) {

    if (Trigger.isBefore) {
        VehicleOrderTriggerHandler.preventOrderIfOutOfStock(
            Trigger.new
        );
    }

    if (Trigger.isAfter) {
        VehicleOrderTriggerHandler.updateStockOnOrderPlacement(
            Trigger.new
        );
    }
}
