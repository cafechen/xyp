var date = new Date();
date.setTime(date.getTime() + (1 * 1 * 60 * 60 * 1000));  
var url = '/webservice/query' ;

function initPage(){
	var page = $.cookie('page') ;
	console.debug("go to page " + page);
	if(page == null || page == "" || page == "index"){
		initIndexPage();
	}else if(page == 'login'){
		initLoginPage();
	}else if(page == 'register'){
		initRegisterPage();
	}else if(page == 'home'){
		initHomePage();
	}else if(page == 'editProfile'){
		initEditProfilePage();
	}else {
		initIndexPage();
	}
}

function initIndexPage(){
	$("#container").load('/pages/index.html', function (){
		showBanner();
		showEvents();
		showOrgs();
	});
}

function initLoginPage(){
	showBanner();
	$("#container").load('/pages/login.html', function (){
		if($.cookie('email') && $.cookie('email').split != ""){
	    $("#login").append('<p align="center">请先注销!</p>');
		}else{
			$("#login").load('/form/login.html');
		}
	});
}

function initRegisterPage(){
	showBanner();
	$("#container").load('/pages/login.html', function (){
		if($.cookie('email') && $.cookie('email').split != ""){
	    $("#login").append('<p align="center">请先注销!</p>');
		}else{
			$("#login").load('/form/register.html');
		}
	});
}

function initHomePage(){
	showBanner();
	if($.cookie('email') && $.cookie('email').split != ""){
		$("#container").load('/pages/home.html', function (){
			cmd = {"cmd":"describe_user","email":$.cookie('email'), "password":$.cookie('password'), "getEvent": "true"};
			req = $.toJSON(cmd) ;
			$.post(url,req, function (data, textStatus, jqXHR){
				var first_vcard = $("#first_vcard") ;
				data = data[0] ;
				if (data['email'] != null && data['email'].split() != ""){
					$("#first_vcard").append('<dl><dt>邮箱</dt><dd>' + data['email'] + '</dd></dl>');
				}
				if (data['school'] != null && data['school'].split() != ""){
					first_vcard.append('<dl><dt>学校</dt><dd>' + data['school'] + '</dd></dl>');
				}
				if (data['company'] != null && data['company'].split() != ""){
					first_vcard.append('<dl><dt>公司</dt><dd>' + data['company'] + '</dd></dl>');
				}
				if (data['title'] != null && data['title'].split() != ""){
					first_vcard.append('<dl><dt>职位</dt><dd>' + data['title'] + '</dd></dl>');
				}
		 	},"json").error(function (xhr, ajaxOptions, thrownError) {
				console.error(xhr.status);
				error = $.evalJSON(xhr.responseText);
				if($.type(error) === 'array'){
					alert(error[0]['error']);
				}else{
					alert(error['error']);
				}
			});
			showMyEvents('follow_events');
			showMyOrgs('follow_orgs');
			showEvents();
			showOrgs();
		});
	}else{
		$("#container").append('<div><p align="center">请先登陆!</p></div>');
	}
}

function initEditProfilePage(){
	showBanner();
	if($.cookie('email') && $.cookie('email').split != ""){
		$("#container").load('/pages/editProfile.html', function (){
			//$("#spanName")[0].append($.cookie('name'));
			if( 'editPublicProfile' == $.cookie('editPage')){
				editPublicProfile();
			}else if('editAccount' == $.cookie('editPage')){
				editAccount();
			}else if('editClubs' == $.cookie('editPage')){
				editClubs();
			}else if('editEvents' == $.cookie('editPage')){
				editEvents();
			}else{
				editPublicProfile();
			}
		});
	}else{
		$("#container").append('<div><p align="center">请先登陆!</p></div>');
	}
}

function editPublicProfile() {
	$.cookie('editPage','editPublicProfile',{ path: '/', expires: date });
	$("#setting-contect").load('/pages/editPublicProfile.html', function (){
		fillPublicProfile();
	});
}

function fillPublicProfile() {
	var email = $.cookie('email'); 
	var password = $.cookie('password'); 
	
	cmd = {"cmd":"describe_user","email":email, "password":password};
	
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		console.debug(data[0]); 
		$("#name")[0].value = data[0]['name'];
		$("#school")[0].value = data[0]['school'];
		$("#company")[0].value = data[0]['company'];
		$("#mobile")[0].value = data[0]['mobile'];
		$("#intro")[0].value = data[0]['intro'];
		//$("input[name=workstate]")[data[0]['workstate']].checked = true;
		$("#title")[0].value = data[0]['title'];
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function savePublicProfile(){
	var email = $.cookie('email') ;
	var password = $.cookie('password') ;
	var mobile = $("#mobile")[0].value ;
	var school = $("#school")[0].value ;
	var company = $("#company")[0].value ;
	var title = $("#title")[0].value ;
	var intro = $("#intro")[0].value ;
	//var workstate = $("#workstate")[0].value ;
	var cmd = {	"cmd":"modify_user",
							"email":email, 
							"password":password, 
							"mobile": mobile, 
							"school":school, 
							"company": company, 
							"title": title, 
							"intro": intro};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){  
  	location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function saveAccount(){
	var email = $.cookie('email') ;
	var oldPassword = $("#old_password")[0].value ;
	var newPassword = $("#new_password")[0].value ;
	var comfirmPassword = $("#comfirm_password")[0].value ;
	
	if($.md5(oldPassword) != $.cookie('password')){
		alert("输入的旧密码不正确！");
		return false ;
	}
	
	if(newPassword != comfirmPassword){
		alert("您两次输入密码不一致！");
		return false ;
	}
	
	var cmd = {	"cmd":"modify_password",
							"email":email, 
							"password": $.md5(oldPassword), 
							"newPassword": $.md5(newPassword)};
							
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		$.cookie('password',newPassword, { path: '/', expires: date }); 
  	location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function editAccount() {
	$.cookie('editPage','editAccount',{ path: '/', expires: date });
	$("#setting-contect").load('/pages/editAccount.html', function (){
	});
}

function editClubs() {
	$.cookie('editPage','editClubs',{ path: '/', expires: date });
	$("#setting-contect").load('/pages/editClubs.html', function (){
		cmd = {"cmd":"describe_orgs", "owner": $.cookie('email')};
		req = $.toJSON(cmd) ;
		$.post(url,req, function (data, textStatus, jqXHR){
			var $clubs=$("#clubs"); 
			var html = '<ul class="boxed-group-list standalone">'
			$.each(data,function(n,value){
				html = html + 	'<li class="clearfix"> \
          								<strong>' + value['name'] + '</strong> \
          								<a href="#" class="minibutton danger js-remove-key"> \
            							<span>删除</span> \
          								</a> \
          								<a href="#" onclick="modifyClub(' + value['id'] + ');" class="minibutton danger js-remove-key"> \
            							<span>修改</span> \
          								</a> \
        								</li>';
			});
			var html = html + '</ul>' ;
			$clubs.append(html);
		},"json");
	});
}

function editEvents() {
	$.cookie('editPage','editEvents',{ path: '/', expires: date });
	$("#setting-contect").load('/pages/editEvents.html', function (){
		cmd = {"cmd":"describe_events", "owner": $.cookie('email')};
		req = $.toJSON(cmd) ;
		$.post(url,req, function (data, textStatus, jqXHR){
			var $events=$("#events"); 
			var html = '<ul class="boxed-group-list standalone">'
			$.each(data,function(n,value){
				html = html + 	'<li class="clearfix"> \
          								<strong>' + value['title'] + '</strong> \
          								<a href="#" class="minibutton danger js-remove-key"> \
            							<span>删除</span> \
          								</a> \
          								<a href="#" class="minibutton danger js-remove-key"> \
            							<span>关闭</span> \
          								</a> \
          								<a href="#" onclick="modifyEvent(' + value['id'] + ');" class="minibutton danger js-remove-key"> \
            							<span>修改</span> \
          								</a> \
        								</li>';
			});
			var html = html + '</ul>' ;
			$events.append(html);
		});
	});
}

function modifyClub(org_id){
	$("#contentClub").load('/form/editClub.html', function (){
		cmd = {"cmd":"describe_orgs", "owner": $.cookie('email')};
		req = $.toJSON(cmd) ;
		$.post(url,req, function (data, textStatus, jqXHR){
			$.each(data,function(n,value){
				if(value['id'] == org_id){
					$("#orgId")[0].value = org_id;
					$("#name")[0].value = value['name'];
					$("#intro")[0].value = value['intro'];
				}
			});
		});
	});
}

function modifyEvent(event_id){
	$("#contentEvent").load('/form/editEvent.html', function (){
		cmd = {"cmd":"describe_events", "owner": $.cookie('email')};
		req = $.toJSON(cmd) ;
		$.post(url,req, function (data, textStatus, jqXHR){
			$.each(data,function(n,value){
				if(value['id'] == event_id){
					$("#eventId")[0].value = event_id;
					$("#title")[0].value = value['title'];
					$("#orgName")[0].value = value['org_name'];
					$("#place")[0].value = value['place'];
					$("#speaker")[0].value = value['speaker'];
					$("#speakerInfo")[0].value = value['speakerInfo'];
					$("#sponsor")[0].value = value['sponsor'];
					$("#undertaker")[0].value = value['undertaker'];
					$("#cooperater")[0].value = value['cooperater'];
					$("#seat")[0].value = value['seat'];
					$("#beginTime")[0].value = value['beginTime'];
					$("#endTime")[0].value = value['endTime'];
					$("#brief")[0].value = value['brief'];
					$("#others")[0].value = value['others'];
				}
			});
		});
	});
}

function createClub(){
	$("#contentClub").load('/form/createClub.html', function (){
	});
}

function createEvent1(){
	console.debug('createEvent');
	$("#contentEvent").load('/form/createEvent.html', function (){
		cmd = {"cmd":"describe_orgs", "owner": $.cookie('email')};
		req = $.toJSON(cmd) ;
		$.post(url,req, function (data, textStatus, jqXHR){
			var orgs = $("#org_select") ;
			var html = '<select id="org_id" name="org_id">' ;
			$.each(data,function(n,value){
				html = html + '<option value="' + value['id'] + '">' + value['name'] + '</option>' ;
			});
			html = html + '</select>' ;
			console.debug(html);
			orgs.append(html);
		});
	});
}

function submitCreateClub(){
	var email = $.cookie('email');
	var password = $.cookie('password');
	var name = $("#name")[0].value ;
	var intro = $("#intro")[0].value ;
	if(name == ""){
		alert("请填写俱乐部名称!") ;
		return false ;
	}
	if(intro == ""){
		alert("请填写俱乐部描述!") ;
		return false ;
	}
	cmd = {"cmd":"create_org",
				"email":email,
				"password":password,
				"name": name,
				"org_type_id": "1",
				"intro": intro
	};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){  
		location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function submitCreateEvent(){
	var email = $.cookie('email');
	var password = $.cookie('password');
	var title = $("#title")[0].value ;
	var org = $("#org_id").find("option:selected").val();
	var place = $("#place")[0].value ;
	var speaker = $("#speaker")[0].value ;
	var speakerInfo = $("#speakerInfo")[0].value ;
	var sponsor = $("#sponsor")[0].value ;
	var undertaker = $("#undertaker")[0].value ;
	var cooperater = $("#cooperater")[0].value ;
	var seat = $("#seat")[0].value ;
	var beginTime = $("#beginTime")[0].value ;
	var endTime = $("#endTime")[0].value ;
	var brief = $("#brief")[0].value ;
	var others = $("#others")[0].value ;
	
	if(title == ""){
		alert("请填写活动名称!") ;
		return false ;
	}
	
	cmd = {
		"cmd":"create_event",
		"email":email,
		"password":password,
		"title": title,
		"org": org,
		"place": place,
		"speaker": speaker,
		"speakerInfo": speakerInfo,
		"sponsor": sponsor,
		"undertaker": undertaker,
		"cooperater": cooperater,
		"seat": seat,
		"beginTime": beginTime,
		"endTime": endTime,
		"brief": brief,
		"others": others
	};
	
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){  
		location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
	
}

function submitModifyClub(){
	var email = $.cookie('email');
	var password = $.cookie('password');
	var orgId = $("#orgId")[0].value ;
	var name = $("#name")[0].value ;
	var intro = $("#intro")[0].value ;
	if(name == ""){
		alert("请填写俱乐部名称!") ;
		return false ;
	}
	if(intro == ""){
		alert("请填写俱乐部描述!") ;
		return false ;
	}
	cmd = {"cmd":"modify_org",
				"email":email,
				"password":password,
				"name": name,
				"intro": intro,
				"orgId": orgId
	};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){  
		location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function submitModifyEvent(){
	var email = $.cookie('email');
	var password = $.cookie('password');
	var eventId = $("#eventId")[0].value ;
	var title = $("#title")[0].value ;
	var place = $("#place")[0].value ;
	var speaker = $("#speaker")[0].value ;
	var speakerInfo = $("#speakerInfo")[0].value ;
	var sponsor = $("#sponsor")[0].value ;
	var undertaker = $("#undertaker")[0].value ;
	var cooperater = $("#cooperater")[0].value ;
	var seat = $("#seat")[0].value ;
	var beginTime = $("#beginTime")[0].value ;
	var endTime = $("#endTime")[0].value ;
	var brief = $("#brief")[0].value ;
	var others = $("#others")[0].value ;
	
	if(title == ""){
		alert("请填写活动名称!") ;
		return false ;
	}
	
	cmd = {
		"cmd":"modify_event",
		"email":email,
		"password":password,
		"eventId":eventId,
		"title": title,
		"place": place,
		"speaker": speaker,
		"speakerInfo": speakerInfo,
		"sponsor": sponsor,
		"undertaker": undertaker,
		"cooperater": cooperater,
		"seat": seat,
		"beginTime": beginTime,
		"endTime": endTime,
		"brief": brief,
		"others": others
	};
	
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}


function closeClub(){
	$("#contentClub").load('/form/empty.html', function (){
	});
}

function closeEvent(){
	$("#contentEvent").load('/form/empty.html', function (){
	});
}


function toIndex(){
	$.cookie('page','index', { path: '/', expires: date });
	location.href="/";
	
}

function toLogin(){
	$.cookie('page','login', { path: '/', expires: date });
	location.href="/";
}

function toRegister(){
	$.cookie('page','register', { path: '/', expires: date });
	location.href="/";
}

function toHome(){
	$.cookie('page','home', { path: '/', expires: date });
	location.href="/";
}

function toEditProfile(){
	$.cookie('page','editProfile', { path: '/', expires: date });
	location.href="/";
}

function showBanner(){
	if($.cookie('email') && $.cookie('email').split != ""){
		$("#banner").append('<ul class="top-nav logged_out"> \
					<li class="login"><a href="#" onclick="toIndex()">首页</a></li> \
					<li class="login"><a href="#" onclick="toHome()">' + $.cookie('name') + '</a></li> \
       		<li class="login"><a href="#" onclick="toLogout()">注销</a></li> \
       	</ul>'
    )
	}else{
		$("#banner").append('<ul class="top-nav logged_out"> \
					<li class="login"><a href="#" onclick="toIndex()">首页</a></li> \
       		<li class="login"><a href="#" onclick="toRegister()">注册</a></li> \
       		<li class="login"><a href="#" onclick="toLogin()">登陆</a></li> \
    		</ul>'
    )
	}
}

function toLogout(){
	$.cookie('page',null, {path: '/'}); 
	$.cookie('email',null, {path: '/'}); 
	$.cookie('name',null, {path: '/'}); 
	$.cookie('password',null, {path: '/'}); 
	location.href="/";
}

function showMyEvents(list) {
	cmd = {"cmd":"describe_user", "email":$.cookie('email'), "password":$.cookie('password'), "getEvents":"true"};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		console.debug(data);
		data = data[0][list];
		var $table=$("#myevents");
		$table.html('');
		$.each(data,function(n,value){ 
			var html = '<tr class="alt"> \
	            			<td class="content">' + value['school_name'] + '</td> \
	            			<td class="content">' + value['org_name'] + '</td> \
	            			<td class="content">' + value['title'] + '</td> \
	            			<td class="content">' + value['place'] + '</td> \
	            			<td class="content">' + value['beginTime'] + '</td> \
	            			<td class="content">' + value['speaker'] + '</td> \
	            			<td class="content">14/30</td>' ;
	  	if(list == 'follow_events'){
	  		html = html + '<td class="content"><a href="#" onclick="unfollowEvent(' + value['event_id'] + '); return false;">取消关注</a> \
	            			<a href="#" onclick="joinEvent(' + value['event_id'] + '); return false;">报名</a></td>' ;
	  	}else if (list == 'join_events'){
	  		html = html + '<td class="content"><a href="#" onclick="exitEvent(' + value['event_id'] + '); return false;">取消报名</a></td>';
	  	}
	  	html = html + '</tr>' ;
	  	$table.append(html);
		});
	},"json");
}

function showMyOrgs(list) {
	cmd = {"cmd":"describe_user", "email":$.cookie('email'), "password":$.cookie('password'), "getOrgs":"true"};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		console.debug(data);
		data = data[0][list];
		var $table=$("#myorgs");
		$table.html('');
		$.each(data,function(n,value){ 
			var html = '<tr class="alt"> \
	            			<td class="content">' + value['school_name'] + '</td> \
	            			<td class="content">' + value['name'] + '</td> \
	            			<td class="content">' + value['events'] + '</td> \
	            			<td class="content">' + value['joined'] + '</td> \
	            			<td class="content">' + value['followed'] + '</td>' ;
	  	if(list == 'follow_orgs'){
	  		html = html + '<td class="content"><a href="#" onclick="unfollowClub(' + value['org_id'] + '); return false;">取消关注</a> \
	            			<a href="#" onclick="joinClub(' + value['event_id'] + '); return false;">加入</a></td>' ;
	  	}else if (list == 'join_orgs'){
	  		html = html + '<td class="content"><a href="#" onclick="exitClub(' + value['org_id'] + '); return false;">退出</a></td>';
	  	}
	  	html = html + '</tr>' ;
	  	$table.append(html);
		});
	},"json");
}


function showEvents() {
	url = '/webservice/query' ;
	cmd = {"cmd":"describe_events"};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		$.each(data,function(n,value){
			//if(n > 5) return ;
			var $table=$("#events"); 
			$table.append('<tr class="alt"> \
	            			<td class="content">' + value['school_name'] + '</td> \
	            			<td class="content">' + value['org_name'] + '</td> \
	            			<td class="content">' + value['title'] + '</td> \
	            			<td class="content">' + value['place'] + '</td> \
	            			<td class="content">' + value['beginTime'] + '</td> \
	            			<td class="content">' + value['speaker'] + '</td> \
	            			<td class="content">14/30</td> \
	            			<td class="content"><a href="#" onclick="joinEvent(' + value['id'] + '); return false;">抢座</a></td> \
	            			<td class="content"><a href="#" onclick="followEvent(' + value['id'] + '); return false;">关注</a></td> \
	        				</tr>');
		});
	},"json");
}

function showOrgs() {
	url = '/webservice/query' ;
	cmd = {"cmd":"describe_orgs"};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		$.each(data,function(n,value){
			console.debug(value);
			//if(n > 5) return ;
			var $table=$("#orgs"); 
			$table.append('<tr class="alt"> \
            <td class="content">' + value['school_name'] + '</td> \
            <td class="content">' + value['name'] + '</td> \
            <td class="content">' + value['events'] + '</td> \
            <td class="content">' + value['joined'] + '</td> \
            <td class="content">' + value['followed'] + '</td> \
            <td class="content"><a href="#" onclick="joinClub(' + value['id'] + '); return false;">加入</a></td></td> \
            <td class="content"><a href="#" onclick="followClub(' + value['id'] + '); return false;">关注</a></td> \
          </tr>');
		});
	},"json");
}

function submitLoginForm(email,pwd) {
	url = '/webservice/query' ;
	password = $.md5(pwd);
	cmd = {"cmd":"describe_user","email":email,"password":password};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		if(data[0].password == password){
	   	$.cookie('email',email, { path: '/', expires: date }); 
			$.cookie('password',password, { path: '/', expires: date }); 
			$.cookie('name',data[0].name, { path: '/', expires: date });
			$.cookie('page','index', { path: '/', expires: date });
			location.href="/";
		}else{
			alert("用户名或密码错误!")
			return false ;
		}
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function validateLoginForm() {
	var email = $("#email")[0].value ;
	var password = $("#password")[0].value ;
	submitLoginForm(email,password);
}

function submitRegisterForm(email,name,password) {
	url = '/webservice/query' ;
	password = $.md5(password)
	cmd = {"cmd":"register_user","email":email,"name":name,"password":password};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){  
   	$.cookie('email',email, { path: '/', expires: date }); 
		$.cookie('password',password, { path: '/', expires: date }); 
		$.cookie('name',name, { path: '/', expires: date });
		$.cookie('page','index', { path: '/', expires: date });
		location.href="/";
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function validateRegisterForm() {
	var email = $("#email")[0].value ;
	var name = $("#name")[0].value ;
	var password = $("#password")[0].value ;
	var check_password = $("#check_password")[0].value ;
	
	var search_str = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
	
	if(!search_str.test(email)){
		alert("邮箱格式不正确！");
		return false ;
	}
	
	if (password.length < 8){
		alert("密码长度必须大于八位");
		return false ;
	}
	
	if (password != check_password){
		alert("两次输入密码不一致！");
		return false ;
	}
	
	submitRegisterForm(email,name,password);

}

function joinEvent(event_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"join_event", "email": $.cookie('email'), "password": $.cookie('password'), "eventId": event_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showJoinEvents();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function followEvent(event_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"follow_event", "email": $.cookie('email'), "password": $.cookie('password'), "eventId": event_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showFollowEvents();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function unfollowEvent(event_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"unfollow_event", "email": $.cookie('email'), "password": $.cookie('password'), "eventId": event_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showFollowEvents();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function exitEvent(event_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"exit_event", "email": $.cookie('email'), "password": $.cookie('password'), "eventId": event_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showFollowEvents();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function joinClub(club_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"join_org", "email": $.cookie('email'), "password": $.cookie('password'), "orgId": club_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showJoinClubs();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function followClub(club_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"follow_org", "email": $.cookie('email'), "password": $.cookie('password'), "orgId": club_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showFollowClubs();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function unfollowClub(club_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"unfollow_org", "email": $.cookie('email'), "password": $.cookie('password'), "orgId": club_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showFollowClubs();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function exitClub(club_id){
	if($.cookie('email') == null){
		toLogin();
		return false ;
	}
	cmd = {"cmd":"exit_org", "email": $.cookie('email'), "password": $.cookie('password'), "orgId": club_id};
	req = $.toJSON(cmd) ;
	
	$.post(url,req, function (data, textStatus, jqXHR){  
		showJoinClubs();
	},"json").error(function (xhr, ajaxOptions, thrownError) {
		console.error(xhr.status);
		error = $.evalJSON(xhr.responseText);
		if($.type(error) === 'array'){
			alert(error[0]['error']);
		}else{
			alert(error['error']);
		}
	});
}

function showJoinEvents(){
	$("#joinE").attr("class","selected") ;	
	$("#followE").attr("class","") ;
	showMyEvents('join_events');	
}

function showFollowEvents(){
	$("#followE").attr("class","selected") ;	
	$("#joinE").attr("class","") ;
	showMyEvents('follow_events');
}

function showJoinClubs(){
	$("#joinC").attr("class","selected") ;	
	$("#followC").attr("class","") ;	
	showMyOrgs('join_orgs');
}

function showFollowClubs(){
	$("#followC").attr("class","selected") ;	
	$("#joinC").attr("class","") ;
	showMyOrgs('follow_orgs');
}
