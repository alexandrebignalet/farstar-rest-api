module server


import farstar_controller
import farstar_domain
import validator
import data_binder
import farstar_dto
import farstar_converter

# Listening interface
fun iface: String do return "0.0.0.0:8080"

# Setup routes
var vh = new VirtualHost(iface)
#repository in order to emulate a database storage
var equipment_repository = new EquipmentRepository
equipment_repository.add_fixtures_data

var ship_converter = new ShipConverter(equipment_repository)
var weapon_converter = new WeaponConverter
var container_converter = new ContainerConverter

var equipment_validator = new EquipmentValidator
var transport_ship_validator = new TransportShipValidator(equipment_repository)
var heavy_war_ship_validator = new HeavyWarShipValidator(equipment_repository)
var light_war_ship_validator = new LightWarShipValidator(equipment_repository)
var hybrid_ship_validator = new HybridShipValidator(equipment_repository)
var weapon_validator = new WeaponValidator
var container_validator = new ContainerValidator


var equipment_controller = new EquipmentRestController(equipment_repository, equipment_validator, container_converter)

vh.routes.add new Route("/api/equipments/:id", equipment_controller)
vh.routes.add new Route("/api/equipments", equipment_controller)


var transport_ship_controller = new TransportShipRestController(equipment_repository, transport_ship_validator, ship_converter)

vh.routes.add new Route("/api/transportships/:id", transport_ship_controller)
vh.routes.add new Route("/api/transportships", transport_ship_controller)

var heavy_warship_controller = new HeavyWarShipRestController(equipment_repository, heavy_war_ship_validator, ship_converter)

vh.routes.add new Route("/api/heavywarships/:id", heavy_warship_controller)
vh.routes.add new Route("/api/heavywarships", heavy_warship_controller)

var hybrid_ship_controller = new HybridShipRestController(equipment_repository, hybrid_ship_validator, ship_converter)

vh.routes.add new Route("/api/hybridships/:id", hybrid_ship_controller)
vh.routes.add new Route("/api/hybridships", hybrid_ship_controller)

var light_warship_controller = new LightWarShipRestController(equipment_repository, light_war_ship_validator, ship_converter)

vh.routes.add new Route("/api/lightwarships/:id", light_warship_controller)
vh.routes.add new Route("/api/lightwarships", light_warship_controller)

var phaser_controller = new PhaserRestController(equipment_repository, weapon_validator, weapon_converter)

vh.routes.add new Route("/api/phasers/:id", phaser_controller)
vh.routes.add new Route("/api/phasers", phaser_controller)

var blaster_controller = new BlasterRestController(equipment_repository, weapon_validator, weapon_converter)
vh.routes.add new Route("/api/blasters/:id", blaster_controller)
vh.routes.add new Route("/api/blasters", blaster_controller)

var container_controller = new ContainerRestController(equipment_repository, container_validator, container_converter)
vh.routes.add new Route("/api/containers/:id", container_controller)
vh.routes.add new Route("/api/containers", container_controller)

var factory = new HttpFactory.and_libevent
factory.config.virtual_hosts.add vh

print "Launching server on http://{iface}/"
factory.run
