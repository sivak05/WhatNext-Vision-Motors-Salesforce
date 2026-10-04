global class PendingOrderScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(
            new PendingOrderBatch(),
            50
        );
    }
}
