module data_binder

private import json
import validator

#
# This class is used to handle errors coming from Deserilisation and Validation
# DataBinder must bind a request_body String to create a "static_type" obj.
# It can be specified a Validator in order to validate directly the obj created.
#
# The target must be a DTO (an temp obj) in order to begin the validation and
# conversion process
#
#	var validator = new WeaponValidator
#	var static_type = "PhaserDTO"
#
#	var data_binder = new DataBinder(new PhaserDTO, static_type, validator)
#
#	var valid_equipment_as_request_body = """{ "mass": 1, "volume": 1}"""
#
#	var phaser_dto = data_binder.bind(valid_equipment_as_request_body)
#	assert phaser_dto.as(PhaserDTO) isa PhaserDTO
#	assert phaser_dto.as(PhaserDTO).mass == 1
#	assert phaser_dto.as(PhaserDTO).volume == 1
#	assert data_binder.get_results.length == 0
#
# case of missing attributes to create the object: the deserializer will create
# errors objects which will be handled by DataBinder to be visible
#
# 	var bad_request_body = """{ "mass": 1 }"""
#	phaser_dto = data_binder.bind(bad_request_body)
#	assert data_binder.get_results.not_empty
#
#
# case of request passing deserialization but not valid as Domain obj
#
# 	var clean_data_binder = new DataBinder(new PhaserDTO, static_type, validator)
#	var valid_serialize_request_body = """{ "mass": 1, "volume": -1}"""
#
#	phaser_dto = clean_data_binder.bind(valid_serialize_request_body)
#	print clean_data_binder.get_results
#	assert clean_data_binder.get_results.length == 0
#
#	clean_data_binder.validate
#	assert clean_data_binder.get_results.not_empty
#
class DataBinder

	protected var target: nullable Object
	private var static_type: String
	private var validator: nullable Validator
	private var errors = new Array[Error]

	fun bind(request_body: nullable String): nullable Object
	do
		if request_body == null then
			errors.add(new Error("Binding Error - Empty request body"))
			return null
		end

		var deserializer = new JsonDeserializer(request_body)
		target = deserializer.deserialize(static_type)

		for error in deserializer.errors do
			errors.add error
		end

		return target
	end

	fun validate
	do
		if not errors.not_empty and validator != null then
			validator.validate(target, errors)
		end
	end

	fun get_results: Array[Error]
	do
		return errors
	end
end
