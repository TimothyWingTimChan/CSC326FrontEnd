<!DOCTYPE html>
<html lang="en-US">

<head>
<title>TTTSearch</title>
<meta charset="UTF-8">
<style>
#image_pos {
	position: relative;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
}
#searchbox_pos {
	position: absolute;
	top: 0;
	left: 250px;
	right: 0;
	bottom: 0;
}
#logo {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
}
#content {
	position: relative;
	margin-top: 20px;
	margin-left: 0px;
	margin-bottom: 0px;
	top: 100px;
	left: 0;
	right: 0;
	bottom: 0;
	z-index: -1;
}
#signout {
	position: absolute;
	float: right;
	bottom: 50px;
	right: 100px;
	top: 20px;
}
#user_info {
	position: absolute;
    float: right;
	margin-top: 0px;
	right: 50px;
}
input[type=submit] {
	width: 53%;
	max-width: 525px;
	min-width: 325px;
	height: 35px;
	background-color: #3b8686;
	color: white;
	padding: 7px 10px;
	margin: auto;
	border: 3px solid white;
	border-radius: 10px;
	border-color: transparent;
	cursor: pointer;
	position: absolute;
	top: 40px;
}
input[type=submit]#login_out {
	max-width: 50px;
	min-width: 50px;
	height: 20px;
	background-color: #3b8686;
	color: white;
	padding: 1px 1px;
	margin: auto;
	border: 1px solid white;
	border-radius: 5px;
	border-color: transparent;
	cursor: pointer;
	font-size: 10px;
}
input[type=text], select {
	width: 50%;
	max-width: 500px;
	min-width: 300px;
	height: 30px;
	padding: 1px 10px;
	border: 1px solid gray;
	border-radius: 4px;
	border-color: transparent;
	font-family: helvetica;
}
th, td {
	border-bottom: 1px solid #ddd;
	font-family: helvetica;
	table-layout: auto;
	color: #3a3a3a;
}
#results {
	position: relative;
	margin-top: 10px;
	margin-left: 20px;
	top: 10px;
	left: 0;
	right: 0;
	bottom: 0;
}
#history {
	position: relative;
	margin-top: 10px;
	margin-left: 20px;
	top: 10px;
	left: 0;
	right: 0;
	bottom: 0;
}
p1 {
	font-family: helvetica;
	position: relative;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	top: 10px;
	left: 0;
	right: 0;
	bottom: 0;
	color: #3a3a3a;
}
td1 {
	display: block;
	font-family: helvetica;
	text-align:right;
	top: 30px;
	color: #3a3a3a;
}
td2 {
	display: block;
	font-size: 20px;
	font-family: helvetica;
	text-align: right;
	color: #3a3a3a;
}
#background {
	position: fixed;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 13%;
	background-color: #f0f0f0;
}

</style>
</head>

<body>

<title>TTTSearch</title>
<div id="background">
<div id = "image_pos">
	<div id = "logo">
		<a href="/">
		<img src="/public/csc326-logo.png" alt="ERROR IMAGE NOT FOUND" style="width:225px;height:80px">
		</a>
	</div>
	<div id = "searchbox_pos">
		<form name="search" action="/" method="get">
			<input type="text" name="keywords" placeholder="Search me up">
			<br>
			<input type="submit" value="Search">
		</form>
	</div>
%if user_name is not None:
	<div id = "signout">
		<form action="/logout">
			<input id="login_out" type="submit" name="signout" value="Sign out">
		</form>
	</div>
	<div id = "user_info">
		<td2>{{user_name}}</td2>
		<td1>{{user_email}}</td1>
	</div>
%else:
	<div id = "signout">
		<form action="/login">
			<input id="login_out" type="submit" name="signin" value="Sign in">
		</form>
	</div>
%end
</div>
</div>
</body>
</html>
