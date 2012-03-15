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
       		<li class="login"><a href="/login.html">登陆</a></li> \
       		<li class="login"><a href="/">首页</a></li> \
    		</ul>'
    )
    $("#login").load('/form/register.html');
	}
}

function submitForm(email,name,password) {
	url = '/webservice/query' ;
	password = $.md5(password)
	cmd = {"cmd":"register_user","email":email,"name":name,"password":password};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		var date = new Date();
		date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));  
   	$.cookie('email',email, { path: '/', expires: date }); 
		$.cookie('password',password, { path: '/', expires: date }); 
		$.cookie('name',name, { path: '/', expires: date });
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
	
	submitForm(email,name,password);

}

function logout(){
	$.cookie('email',null, {path: '/'}); 
	$.cookie('name',null, {path: '/'}); 
	$.cookie('password',null, {path: '/'}); 
	location.href="/";
}
