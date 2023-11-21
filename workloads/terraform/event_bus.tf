module "critical_events_target"{
    source = "./modules/event_bus"

    event_bus_name = "criticalEventsTarget"
}