global class PendingOrderBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Status__c, Vehicle__c, ' +
            'Vehicle__r.Stock_Quantity__c ' +
            'FROM Vehicle_Order__c ' +
            'WHERE Status__c = \'Pending\''
        );
    }

    global void execute(
        Database.BatchableContext bc,
        List<Vehicle_Order__c> orders
    ) {
        List<Vehicle_Order__c> ordersToUpdate =
            new List<Vehicle_Order__c>();

        Map<Id, Vehicle__c> vehiclesToUpdate =
            new Map<Id, Vehicle__c>();

        for (Vehicle_Order__c order : orders) {

            if (order.Vehicle__c != null &&
                order.Vehicle__r.Stock_Quantity__c > 0) {

                order.Status__c = 'Confirmed';
                ordersToUpdate.add(order);

                Vehicle__c vehicle = new Vehicle__c(
                    Id = order.Vehicle__c,
                    Stock_Quantity__c =
                        order.Vehicle__r.Stock_Quantity__c - 1
                );

                vehiclesToUpdate.put(vehicle.Id, vehicle);
            }
        }

        if (!vehiclesToUpdate.isEmpty()) {
            update vehiclesToUpdate.values();
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}
