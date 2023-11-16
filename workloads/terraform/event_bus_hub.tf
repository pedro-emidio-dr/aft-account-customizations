module "critical_events"{
    source = "./modules/event_bus"

    event_bus_name = "criticalEvents"
}