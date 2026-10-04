public class VehicleOrderTriggerHandler {

    public static void preventOrderIfOutOfStock(
        List<Vehicle_Order__c> newOrders
    ) {
        Set<Id> vehicleIds = new Set<Id>();

        for (Vehicle_Order__c order : newOrders) {
            if (order.Vehicle__c != null) {
                vehicleIds.add(order.Vehicle__c);
            }
        }

        Map<Id, Vehicle__c> vehicles = new Map<Id, Vehicle__c>(
            [SELECT Id, Stock_Quantity__c
             FROM Vehicle__c
             WHERE Id IN :vehicleIds]
        );

        for (Vehicle_Order__c order : newOrders) {
            if (order.Vehicle__c != null &&
                vehicles.containsKey(order.Vehicle__c) &&
                vehicles.get(order.Vehicle__c).Stock_Quantity__c <= 0) {

                order.addError('Vehicle is out of stock.');
            }
        }
    }

    public static void updateStockOnOrderPlacement(
        List<Vehicle_Order__c> newOrders
    ) {
        Set<Id> vehicleIds = new Set<Id>();

        for (Vehicle_Order__c order : newOrders) {
            if (order.Vehicle__c != null &&
                order.Status__c == 'Confirmed') {
                vehicleIds.add(order.Vehicle__c);
            }
        }

        List<Vehicle__c> vehiclesToUpdate = [
            SELECT Id, Stock_Quantity__c
            FROM Vehicle__c
            WHERE Id IN :vehicleIds
        ];

        for (Vehicle__c vehicle : vehiclesToUpdate) {
            vehicle.Stock_Quantity__c =
                vehicle.Stock_Quantity__c - 1;
        }

        if (!vehiclesToUpdate.isEmpty()) {
            update vehiclesToUpdate;
        }
    }
}
