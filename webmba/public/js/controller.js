function jsonPost(data) {
	$.post("webservice/query", $.toJSON(data), function(data, textStatus) {
		return data;
	}, "json").success(function() {
		console.debug("success");
	}).error(function() {
		console.debug(this);
	}).complete(function() {
		console.debug(this);
	});
}

function describeEvents() {
	return jsonPost({
		"cmd" : "describe_events"
	});
}

function CreateEventsTableView(node) {
	data = {
		"cmd" : "describe_events"
	};
	$.post("webservice/query", $.toJSON(data), function(data, textStatus) {
		console.debug("1111111111") ;
		console.debug(data);
		node.append(CreateTableView(data)) ;
	}, "json").success(function() {
		console.debug("success");
	}).error(function() {
		console.debug(this);
	}).complete(function() {
		console.debug("complete");
	});
}

function CreateTableView(objArray, theme, enableHeader) {
	// set optional theme parameter
	if(theme === undefined) {
		theme = 'mediumTable';
		//default theme
	}

	if(enableHeader === undefined) {
		enableHeader = true;
		//default enable headers
	}

	// If the returned data is an object do nothing, else try to parse
	var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

	var str = '<table class="' + theme + '">';

	// table head
	if(enableHeader) {
		str += '<thead><tr>';
		for(var index in array[0]) {
			str += '<th scope="col">' + index + '</th>';
		}
		str += '</tr></thead>';
	}

	// table body
	str += '<tbody>';
	for(var i = 0; i < array.length; i++) {
		str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
		for(var index in array[i]) {
			str += '<td>' + array[i][index] + '</td>';
		}
		str += '</tr>';
	}
	str += '</tbody>'
	str += '</table>';
	return str;
}