<!DOCTYPE html>
<html lang="en-US">

<head>
<title>TTTSearch</title>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"
			integrity="sha256-T0Vest3yCU7pafRw9r+settMBX6JkKN06dqBnpQ8d30="
			crossorigin="anonymous"></script>
<style>
body {
	display: table; 
	margin: 0;
	width: 100%;
	height: 100%;
}
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
	display: table-row;
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
	z-index: 1;
}
#content {
	display: table-row;
	width: 100%;
	height: 100%;
	z-index: -1;
	overflow: auto;
	margin-bottom: 80px;
}
#content_results {
	width: 100%;
	z-index: -1;
	margin-bottom: 120px;
}
#spell_correction {
	width: 100%;
	margin-bottom: 15px;
}
#special_feature {
	width: 100%;
	float: left;
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
	margin-bottom: 20px;
	margin-left: 20px;
	top: 20px;
	left: 0;
	right: 0;
	bottom: 0;
}
p3 {
	font-family: helvetica;
	color: red;
	position: relative;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	top: 20px;
	left: 0;
	right: 0;
	bottom: 0;
}
p4 {
	font-family: helvetica;
	color: black;
	position: relative;
	font-size: 30px;
	padding: 20px 20px;
	float: left;
	border: 2px solid;
	border-color: #f0f0f0;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	margin-right: 20px;
	top: 10px;
	box-shadow: 2px 2px 1px #f9f9f9;
}
p5 {
	font-family: helvetica;
	color: grey;
	position: relative;
	font-size: 22px;
}
p6 {
	font-family: helvetica;
	color: black;
	position: relative;
	font-size: 17px;
	font-weight: bold;
	padding: 20px 20px;
	float: left;
	border: 2px solid;
	border-color: #f0f0f0;
	margin-top: 20px;
	margin-left: 20px;
	margin-bottom: 20px;
	margin-right: 20px;
	top: 10px;
	box-shadow: 2px 2px 1px #f9f9f9;
}
p7 {
	font-family: helvetica;
	color: grey;
	position: relative;
	font-size: 13px;
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
.search_button button {
	color: #3b8686;
	font-family: helvetica;
	font-size: 16px;
    text-decoration: none;
	background-color: transparent;
	border: none;
	background: none;
}
.search_button button:active {
	outline: none;
	border: none;
}
.search_button button:focus {
	outline: 0;
}
.search_button button:hover {
	cursor: pointer;
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
		<a href="/">
		<img src="/static/csc326-logo.png" alt="ERROR IMAGE NOT FOUND" style="width:225px;height:80px">
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

//sets the Speech Recognition
window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

if (window.SpeechRecognition === null) {
	alert("Speech Recognition cannot be started");
} else {
	//creates the SpeechRecognition object
	var recognition = new window.SpeechRecognition();
	var transcription = document.getElementById('transcript');

	//Speech Recognition configurations
	recognition.continuous = true;
	recognition.interimResults = true;
	recognition.lang = 'en-CA';

	//a callback function when Speech Recognition is started
	recognition.onstart = function () {
		recognizing = true;
	};

	//a callback function when Speech Recognition throws an error
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
    console.log(event);
	};

	//a callback function when the Speech Recognition ended
	recognition.onend = function () {
		recognizing = false;
		if (ignore_onend) {
			return;
		}
	};

	//a callback function when the Speech Recognition collects results
	recognition.onresult = function (event) {
		var final = "";
		var interim = "";
		//appends the converted speech string into final and interim
		//string is appended to interim as a continous stream
		//string is appended to final when the results are final
		for (var i = 0; i < event.results.length; i++) {
			if (event.results[i].isFinal) {
				final += event.results[i][0].transcript;
			} else {
				interim += event.results[i][0].transcript;
			}
		}
		//add the converted speech string to the element
		document.getElementById('transcription').value = final;
	};

	var speech_on = true;
	//add a click listener to the button
	document.getElementById('button-play-ws').addEventListener('click', function () {
		if (speech_on === true) {
			try {
				//start the speech recognition
				recognition.start();
				document.getElementsByClassName('material-icons')[0].style.color = '#e60303'; //change the mic to red
			} catch (ex) {
				alert("Error occurred when starting Speech Recognition");
			}
		} else {
			//stop the speech recognition
			recognition.stop();
			document.getElementsByClassName('material-icons')[0].style.color = '#3b8686'; //change mic back to original colour
		}
		speech_on = !speech_on;
	});
}

//jQuery UI automcomplete
$(function() {
	$('#transcription').autocomplete({
		source: "/get_words",
		minLength: 2
	});
});
</script>
</body>
</html>
