function jsonPost(data){
	$.post("webservice/query", $.toJSON(data), function (data, textStatus){
		console.debug(textStatus);
		console.debug(data);
		return data;
	}, "json").success(function() { console.debug("second success"); })
	.error(function() { console.debug(this); }) 
	.complete(function() { console.debug(this); }) ;
}

function describeEvents() {
	return jsonPost({"cmd":"describe_eventss"}) ;
}
