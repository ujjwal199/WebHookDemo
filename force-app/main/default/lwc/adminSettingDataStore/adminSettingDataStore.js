var availableFieldsByInstanceName = {};

function setAvailableFieldsByInstanceName(instanceName, fields){
	availableFieldsByInstanceName[instanceName] = fields;
	console.log("value1---->" , availableFieldsByInstanceName);
}
function getAvailableFieldsByInstanceName(instanceName){
	return availableFieldsByInstanceName[instanceName];
}

export {
	setAvailableFieldsByInstanceName,
	getAvailableFieldsByInstanceName
}