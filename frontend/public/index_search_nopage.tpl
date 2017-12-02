<!DOCTYPE html>
<html lang="en-US">

<head>
<title>TTTSearch</title>
	<base href="http://localhost:8080/">
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"
			integrity="sha256-T0Vest3yCU7pafRw9r+settMBX6JkKN06dqBnpQ8d30="
			crossorigin="anonymous"></script>
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
#background {
	position: fixed;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 120px;
	background-color: #f0f0f0;
}
#background_bot {
	position: fixed;
	bottom: 0px;
	left: 0px;
	width: 100%;
	height: 80px;
	background-color: #f0f0f0;
}
#content {
	position: fixed;
	top: 120px;
	left: 0;
	bottom: 120px;
	width: 100%;
	height: 100%;
	z-index: -1;
}
#content_bot {
	position: fixed;
	bottom: 0px;
	left: 0;
	width: 100%;
	height: 80px;
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
	width: 47.5%;
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
button {
	width: 3%;
	max-width: 525px;
	min-width: 0px;
	height: 35px;
	color: green;
	padding: 7px 10px;
	margin: auto;
	border: 3px solid #f0f0f0;
	background-color: #f0f0f0;
	padding: 1px 0px;
	cursor: pointer;
	position: absolute;
	top: 40px;
	left: 490px;
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
input[type=submit]#page_item {
	display: none;
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
p2 {
	font-family: helvetica;
	position: relative;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	top: 20px;
	left: 0;
	right: 0;
	bottom: 0;
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
.pagination {
    display: inline-block;
}
.pagination button {
    color: black;
    float: left;
	font-size: 13px;
	font-family: helvetica;
    padding: 6px 12px;
    text-decoration: none;
	background-color: white;
	border: none;
	background: none;
}
.pagination button.active {
    background-color: #3b8686;
    color: white;
	border-radius: 5px;
}
#page_div {
	position: absolute;
	bottom: 30px;
	width: 100%;
}
.material-icons {
	vertical-align: middle !important;
	color: #3b8686;
}
</style>
</head>
<body link="#0b486b" vlink="#3b8686" alink="#3b8686">
<title>TTTSearch</title>
<div id="background">
<div id = "image_pos">
	<div id = "logo">
		<a href="http://localhost:8080">
		<img src="/public/csc326-logo.png" alt="ERROR IMAGE NOT FOUND" style="width:225px;height:80px">
		</a>
	</div>
	<div id = "searchbox_pos">
		<form id="search" action="/" method="get">
%if searched_string == None :
			<input id="transcription" type="text" name="keywords" placeholder="Search me up">
%else :
			<input id="transcription" type="text" name="keywords" value="{{searched_string}}">
%end
			<br>
			<div id="background_bot">
			</div>
			<input type="submit" value="Search">
			<button id="button-play-ws" type="button"><i class="material-icons">mic</i></button>
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
<script type="text/javascript">

var final_transcript = '';
var recognizing = false;
var ignore_onend;
var start_timestamp;

window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

if (window.SpeechRecognition === null) {
	alert("Speech Recognition cannot be started");
} else {
	var recognition = new window.SpeechRecognition();
	var transcription = document.getElementById('transcript');
	var log = document.getElementById('log');

	recognition.continuous = true;
	recognition.interimResults = true;

	recognition.onstart = function () {
		recognizing = true;
	};

	recognition.onerror = function (event) {
		if (event.error === 'no-speech') {
			ignore_onend = true;
		}

		if (event.error === 'audio-capture') {
			ignore_onend = true;
		}

		if (event.error === 'not-allowed') {
			if (event.timestamp - start_timestamp < 100) {
				//do nothing
			}
			ignore_onend = true;
		}
		alert('Speech Recognition error!');
	};

	recognition.onerror = function () {
		recognizing = false;
		if (ignore_onend) {
			return;
		}
	};

	recognition.onresult = function (event) {
		var final = "";
		var interim = "";
		for (var i = 0; i < event.results.length; i++) {
			if (event.results[i].isFinal) {
				final += event.results[i][0].transcript;
			} else {
				interim += event.results[i][0].transcript;
			}
		}
		document.getElementById('transcription').value = final;
	};

	var speech_on = true;
	document.getElementById('button-play-ws').addEventListener('click', function () {
		if (speech_on === true) {
			try {
				recognition.start();
				document.getElementsByClassName('material-icons')[0].style.color = '#e60303';
			} catch (ex) {
				alert("Error occurred when starting Speech Recognition");
			}
		} else {
			recognition.stop();
			document.getElementsByClassName('material-icons')[0].style.color = '#3b8686';
			// transcription.innerHTML = '';
		}
		speech_on = !speech_on;
	});
}

$(function() {
	$('#transcription').autocomplete({
		source: "/get_words",
		minLength: 2
	});
});
</script>
</body>
</html>
