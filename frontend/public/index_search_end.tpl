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

window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

if (window.SpeechRecognition === null) {
	alert("Speech Recognition cannot be started");
} else {
	var recognition = new window.SpeechRecognition();
	var transcription = document.getElementById('transcription');

	recognition.continuous = true;
	recognition.interimResults = true;

	recognition.onstart = function () {
		recognition = true;
	};

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

	recongition.onend = function () {
		recognizing = false;
		if (ignore_onend) {
			return;
		}
	};

	recognition.onresult = function (event) {
		var final = "";
		var interim = "";
		for (var i = 0; event.results.length; i++) {
			if (event.results[i][0].isFinal) {
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
				alert("Error occured when starting Speech Recognition");
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
