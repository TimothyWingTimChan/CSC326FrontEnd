<!DOCTYPE html>
<html lang="en-US">

<head>
<title>TTTSearch</title>
	<base href="http://localhost:8080/">
<meta charset="UTF-8">
<style>
#signout {
	position: absolute;
	float: right;
	bottom: 50px;
	right: 67px;
	top: 70px;
}
#user_info {
	position: absolute;
    float: right;
	margin-top: 10px;
	right: 50px;
}
img {
	position: relative;
	margin-top: 10%;
	top: 0;
	left: 39%;
	right: 0;
	bottom: 0;
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
	cursor: pointer;
	position: relative;
	margin: auto;
	top: 0;
	left: 36%;
	right: 0;
	bottom: 30px;
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
	position: relative;
	margin: auto;
	top: 0;
	left: 36%;
	right: 0;
	bottom: 0%;
	font-family: helvetica;
}
th, td {
	border-bottom: 1px solid #ddd;
	font-family: helvetica;
	table-layout: auto;
}
#results {
	position: relative;
	left: 39%;
	top: 32px;
}
#history {
	position: relative;
	left: 39%;
	top: 32px;
	margin-bottom: 100px;
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
p1 {
	font-family: helvetica;
	position: relative;
	margin: auto;
	top: 30px;
	bottom: 30px;
	left: 36%;
}
#background {
	position: fixed;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 13%;
	background-color: transparent;
}
</style>
</head>

<body>

<title>TTTSearch</title>
<a href="localhost:8080">
<img src="/public/csc326-logo.png" alt="ERROR IMAGE NOT FOUND" style="width:400px;height:142px">
</a>
<form name="search" action="/" method="get">
	<input type="text" name="keywords" placeholder="Search me up">
	<br>
	<input type="submit" value="Search">
</form>
<div id="background">
	<div id = "image_pos">
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
