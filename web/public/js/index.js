function initPage(){
	if($.cookie('email') && $.cookie('email').split != ""){
		$("#banner").append('<ul class="top-nav logged_out"> \
					<li class="login"><a href="#">' + $.cookie('name') + '</a></li> \
       		<li class="login"><a href="#" onclick="logout()">注销</a></li> \
       		<li class="login"><a href="/">首页</a></li> \
    		</ul>'
    )
	}else{
		$("#banner").append('<ul class="top-nav logged_out"> \
       		<li class="login"><a href="/register.html">注册</a></li> \
       		<li class="login"><a href="/login.html">登陆</a></li> \
    		</ul>'
    )
	}
}

function logout(){
	$.cookie('email',null, {path: '/'}); 
	$.cookie('name',null, {path: '/'}); 
	$.cookie('password',null, {path: '/'}); 
	location.href="/";
}

function showEvents() {
	url = '/webservice/query' ;
	cmd = {"cmd":"describe_events"};
	req = $.toJSON(cmd) ;
	$.post(url,req, function (data, textStatus, jqXHR){
		$.each(data,function(n,value){
			if(n > 2) return ;
			var $table=$("#events"); 
			$table.append('<tr class="alt"> \
	            			<td class="content">' + value['school_name'] + '</td> \
	            			<td class="content">' + value['org_name'] + '</td> \
	            			<td class="content">' + value['title'] + '</td> \
	            			<td class="content">' + value['place'] + '</td> \
	            			<td class="content">' + value['beginTime'] + '</td> \
	            			<td class="content">' + value['speaker'] + '</td> \
	            			<td class="content">14/30</td> \
	            			<td class="content">抢座</td> \
	            			<td class="content">关注</td> \
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
			if(n > 2) return ;
			var $table=$("#orgs"); 
			$table.append('<tr class="alt"> \
            <td class="content">清华大学</td> \
            <td class="content">创投俱乐部</td> \
            <td class="content">23</td> \
            <td class="content">23</td> \
            <td class="content">23</td> \
            <td class="content">加入</td> \
            <td class="content">关注</td> \
          </tr>');
		});
	},"json");
}

