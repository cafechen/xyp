function initPage(){
	if($.cookie('email') && $.cookie('email').split != ""){
		$("#banner").append('<ul class="top-nav logged_out"> \
					<li class="login"><a href="#">' + $.cookie('name') + '</a></li> \
       		<li class="login"><a href="#" onclick="logout()">注销</a></li> \
       		<li class="login"><a href="/">首页</a></li> \
    		</ul>'
    )
    $("#login").append('<p align="center">请先注销!</p>');
	}else{
		$("#banner").append('<ul class="top-nav logged_out"> \
       		<li class="login"><a href="/register.html">注册</a></li> \
       		<li class="login"><a href="/">首页</a></li> \
    		</ul>'
    )
    $("#login").load('/form/login.html');
	}
}

function submitForm(email,password) {
	url = '/webservice/query' ;
	password = $.md5(password)
	cmd = {"cmd":"describe_user","email":email,"password":password};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		var date = new Date();
		date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));  
   	$.cookie('email',email, { path: '/', expires: date }); 
		$.cookie('password',password, { path: '/', expires: date }); 
		$.cookie('name',data[0].name, { path: '/', expires: date });
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

function validate() {
	var email = $("#email")[0].value ;
	var password = $("#password")[0].value ;
	submitForm(email,password);
}

function logout(){
	$.cookie('email',null, {path: '/'}); 
	$.cookie('name',null, {path: '/'}); 
	$.cookie('password',null, {path: '/'}); 
	location.href="/";
}
