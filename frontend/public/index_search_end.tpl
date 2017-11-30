			</div>
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
<script>
$(function() {
	$('#search_bar').autocomplete({
		source: '/get_words',
		minLength: 2
	});
});
</script>
</body>
</html>
