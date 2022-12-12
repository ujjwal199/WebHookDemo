var availableFieldsByInstanceName = {};

function setAvailableFieldsByInstanceName(instanceName, fields){
	availableFieldsByInstanceName[instanceName] = fields;
	
}
function getAvailableFieldsByInstanceName(instanceName){
	return availableFieldsByInstanceName[instanceName];
}

export {
	setAvailableFieldsByInstanceName,
	getAvailableFieldsByInstanceName
}