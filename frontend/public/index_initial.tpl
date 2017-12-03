<!DOCTYPE html>
<html lang="en-US">

<head>
<title>TTTSearch</title>
	<base href="http://localhost:8080/">
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<link rel="stylesheet"
			href="https://cdn.jsdelivr.net/npm/animate.css@3.5.2/animate.min.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"
			integrity="sha256-T0Vest3yCU7pafRw9r+settMBX6JkKN06dqBnpQ8d30="
			crossorigin="anonymous"></script>
<style>
#search_items {
	position: absolute;
	width: 450px;
	height: 300px;
    top: 40%;
    left: 50%;
    transform: translateX(-50%) translateY(-40%);
}
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
	/*left: 50%;*/
	transform: translateX(-50%)
}
input[type=submit]{
	width: 100%;
	max-width: 410px;
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
	left: 0%;
	right: 0;
	bottom: 30px;
}
button {
	width: 10%;
	max-width: 35px;
	min-width: 0px;
	height: 35px;
	/*color: #3b8686;*/
	padding: 1px 2px;
	margin: auto;
	border: 3px solid white;
	border-radius: 10px;
	cursor: pointer;
	position: relative;
	margin: auto;
	top: 0;
	left: 0%;
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
	width: 100%;
	max-width: 430px;
	min-width: 300px;
	height: 30px;
	padding: 1px 10px;
	border: 1px solid gray;
	border-radius: 4px;
	position: relative;
	margin: auto;
	top: 0;
	left: 0%;
	right: 50px;
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
.material-icons {
	vertical-align: middle !important;
	color: #3b8686;
}
</style>
</head>

<body>

<title>TTTSearch</title>
<div id="search_items">
	<a href="localhost:8080">
		<img class="animated fadeInDown" src="/public/csc326-logo.png" alt="ERROR IMAGE NOT FOUND" style="width:400px;height:142px">
	</a>
	<form name="search" action="/" method="get">
		<input id="transcription" type="text" name="keywords" placeholder="Search me up">
		<!-- <button id="button-play-ws" type="button"><i class="material-icons">mic</i>Speech To Text</button> -->
		<!-- <br> -->
		<input type="submit" value="Search">
		<button id="button-play-ws" type="button"><i class="material-icons">mic</i></button>
	</form>

</div>
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
	var transcription = document.getElementById('transcription');
	var log = document.getElementById('log');

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
			if (event.timeStamp - start_timestamp < 100) {
				//do nothing
			}
			ignore_onend = true;
		}
		alert('Speech Recognition error!');
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
		//string is appended to interim as a continuous stream
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
	document.getElementById('button-play-ws').addEventListener('click', function()
	{
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
			document.getElementsByClassName('material-icons')[0].style.color = '#3b8686'; //change the mic back to original colour
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
