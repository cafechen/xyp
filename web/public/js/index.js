function showEvents() {
	jQuery("#elist").jqGrid({
		url : '/web/grid_events',
		datatype : "json",
		colNames : ['标题', '俱乐部', ''],
		colModel : [{
			name : 'title',
			index : 'title',
			width : 950 * 30 / 100
		}, {
			name : 'org_name',
			index : 'org_name',
			width : 950 * 40 / 100
		}, {
			name : 'act',
			index : 'join_event',
			width : 950 * 30 / 100
		}],
		rowNum : 10,
		height : 'auto',
		authwidth : 'true',
		rowList : [10, 20, 30],
		pager : '#epager',
		sortname : 'title',
		viewrecords : true,
		sortorder : "desc",
		caption : "活动列表",
		gridComplete : function() {
			var ids = jQuery("#elist").jqGrid('getDataIDs');
			for(var i = 0; i < ids.length; i++) {
				var cl = ids[i];
				je = "<input style='height:22px;width:60px;' type='button' value='加入'/>";
				fe = "<input style='height:22px;width:60px;' type='button' value='关注'/>";
				jQuery("#elist").jqGrid('setRowData', ids[i], {
					act : je + fe
				});
			}
		}
	});
	jQuery("#elist").jqGrid('navGrid', '#epager', {
		edit : false,
		add : false,
		del : false,
		search : false
	});

}

function showEvents() {
	jQuery("#elist").jqGrid({
		url : '/web/grid_events',
		datatype : "json",
		colNames : ['名称', '俱乐部', ''],
		colModel : [{
			name : 'title',
			index : 'title',
			width : 950 * 30 / 100
		}, {
			name : 'org_name',
			index : 'org_name',
			width : 950 * 40 / 100
		}, {
			name : 'act',
			index : 'join_event',
			width : 950 * 30 / 100
		}],
		rowNum : 10,
		height : 'auto',
		authwidth : 'true',
		rowList : [10, 20, 30],
		pager : '#epager',
		sortname : 'title',
		viewrecords : true,
		sortorder : "desc",
		caption : "活动列表",
		gridComplete : function() {
			var ids = jQuery("#elist").jqGrid('getDataIDs');
			for(var i = 0; i < ids.length; i++) {
				var cl = ids[i];
				je = "<input style='height:22px;width:60px;' type='button' value='加入'/>";
				fe = "<input style='height:22px;width:60px;' type='button' value='关注'/>";
				jQuery("#elist").jqGrid('setRowData', ids[i], {
					act : je + fe
				});
			}
		}
	});
	jQuery("#elist").jqGrid('navGrid', '#epager', {
		edit : false,
		add : false,
		del : false,
		search : false
	});

}