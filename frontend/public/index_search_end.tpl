			</div>
			<button id="button-play-ws" type-"button"><i class="material-icons">mic</i></button>
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
<script type="text/javascript">

var final_transcript = '';
var recognizing = false;
var ignore_onend;
var start_timestamp;

//sets the Speech Recognition
window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

//SpeechRecognition is only supported on certain browsers
if (window.SpeechRecognition === null) {
	alert("Speech Recognition cannot be started");
} else {
	//creates the SpeechRecognition object
	var recognition = new window.SpeechRecognition();
	var transcription = document.getElementById('transcription');

	//Speech Recognition configurations
	recognition.continuous = true;
	recognition.interimResults = true;
	recognition.lang = 'en-CA';

	//a callback function when Speech Recognition is started
	recognition.onstart = function () {
		recognition = true;
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
		console.log(error);
	};

	//a callback function when Speech Recognition ended
	recongition.onend = function () {
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
		for (var i = 0; event.results.length; i++) {
			if (event.results[i][0].isFinal) {
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
				alert("Error occured when starting Speech Recognition");
			}
		} else {
			recognition.stop();
			document.getElementsByClassName('material-icons')[0].style.color = '#3b8686'; //change mic back to original color
			// transcription.innerHTML = '';
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
