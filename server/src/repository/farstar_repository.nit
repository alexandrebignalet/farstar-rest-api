module farstar_repository

import farstar_domain

#
# Class used to mocked a database repository which will keep data in memory.
#
#	var phaser = new Phaser(1,1)
#	var blaster = new Blaster(1,1,1)
#	var container = new Container(10,10)
#	var transport_ship = new TransportShip(1,1,1,0)
#	var hybrid_ship = new HybridShip(1,1,1,0,0)
#
#	var repository = new EquipmentRepository
#
#	repository.add(phaser)
#	assert repository.findAll("Equipment").not_empty
#	assert repository.findAll("Equipment").length == 1
#	assert repository.findAll("Equipment").has(phaser)
#	assert repository.find(phaser.id, "Phaser") == phaser
#
#	repository.add(transport_ship)
#	repository.add(hybrid_ship)
#
#	assert repository.findAll("TransportShip").length == 1
#	assert repository.findAll("HybridShip").length == 1
#
class EquipmentRepository

	private var equipments = new Array[Equipment]

	fun add(equipment: Equipment)
	do
		equipments.add equipment
	end

	fun findAll(static_type: String): Array[Equipment]
	do
		if static_type == "Equipment" then
			return equipments
		end

		var equipments_by_type = new Array[Equipment]

		for equipment in equipments
		do
			if equipment.class_name == static_type then
				equipments_by_type.add(equipment)
			end
		end

		return equipments_by_type
	end

	fun find(id: Int, static_type: String): nullable Equipment
	do
		var found = null
		for equipment in equipments
		do
			if equipment.id == id then
				if static_type == "Equipment" then
					return equipment
				else if equipment.class_name == static_type then
					return equipment
				end
			end
		end

		return null
	end

	fun remove(id: Int)
	do
		var equipment = find(id, "Equipment")
		equipments.remove_at equipments.index_of(equipment)
	end
end
