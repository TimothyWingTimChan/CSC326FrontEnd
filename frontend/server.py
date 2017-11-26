from bottle import route, run, request, response, redirect, app, hook
from bottle import static_file
from bottle import template
from oauth2client.client import flow_from_clientsecrets, OAuth2WebServerFlow
from googleapiclient.discovery import build
from beaker.middleware import SessionMiddleware
import bottle
import pickle
import os

bottle.TEMPLATE_PATH.insert(0, './public')

session_opts = {
	'session.type': 'cookie',
	'session.key': '3', #maybe need to encrypt and such........
	'session.secret': 1, #same here.......
    'session.cookie_expires': True,
    'session.auto': True,
	'session.validate_key': True
}

flow = flow_from_clientsecrets('google_secret/google_client_secrets.json',
                                    scope = ['https://www.googleapis.com/auth/plus.me', 'https://www.googleapis.com/auth/plus.profile.emails.read'],
                                    redirect_uri = 'http://0.0.0.0:80/oauth2callback')

main_app = SessionMiddleware(bottle.app(), session_opts)

local_store = {}
local_credentials = {}

def storeAccessToken(credentials):
    s = request.environ.get('beaker.session')
    access_token = credentials.get_access_token()
    s['access_token'] = access_token
    s.save()

def storeUserInformation(authorization_code):
    session = request.environ.get('beaker.session')
    local_store[session['_id']] = (session['access_token'], authorization_code)

def getHtmlfile():
    f = open('./public/index.html', 'r')
    content = f.read()
    return content

# converts python dictionary into html table
def dic_to_table(d, name):
	html_table = '<table id="' + name + '"><tr><th>Word</th><th>Count</th></tr>'
	for word in d:
		html_table = html_table + "<tr><td>" + word[0] +"</td><td>" + str(word[1]) + "</td></tr>"
	html_table = html_table + "</table>"

	return html_table

# converts python list into html table
def list_to_table(l, name):
	html_table = '<table id="' + name + '"><tr><th>Word</th></tr>'
	for i in range(0,len(l)):
		html_table = html_table + "<tr><td>" + l[i] + "</td><td>"
	html_table = html_table + "</table>"

	return html_table

# creates a static file so that the logo can be displayed
@route('/public/<filepath:re:.*\.png>')
def display_logo(filepath):
	return static_file(filepath, root='./public')

@route('/oauth2callback')
def redirect_page():
    session = request.environ.get('beaker.session')
    # get the authorization code and using the authorization code retrieve the credentials
    code = request.query.get('code', '')
    credentials = flow.step2_exchange(code)
    # store the credentials
    local_credentials[session['_id']] = credentials
    # store the access token
    storeAccessToken(credentials)
    # store the user information
    storeUserInformation(code)
    # redirect to home
    redirect('/')

@route('/login')
def login():
    # login through Google OAuth2.0
    session = request.environ.get('beaker.session')
    # set up session var for the login state 
    if not 'logged_in' in session:
        session['logged_in'] = True
    elif session['logged_in'] == True:

        if session['_id'] in local_store:
            
            # if logged in check for the token expiration and if expired refresh token
            if session['_id'] in local_credentials and local_credentials[session['_id']].access_token_expired:
                google_access_token = local_credentials[session['_id']].get_access_token()
                local_store[session['_id']] = google_access_token 
                session['access_token'] = google_access_token

            # compare tokens
            server_token = local_store[session['_id']][0][0]
            client_token = session['access_token'][0] 

            # redirect if tokens are valid, logout if not valid 
            if server_token == client_token:
                redirect('/')
            else:
                redirect('/logout')
            return

    # redirect to the Google OAuth2.0 url
    uri = flow.step1_get_authorize_url()
    redirect(str(uri))

@route('/logout')
def logout():
    session  = request.environ.get('beaker.session')
    # delete saved status of each user before logging out
    if session['_id'] in local_credentials:
        del local_credentials[session['_id']]
    if session['_id'] in local_store:
        del local_store[session['_id']]
    session.invalidate()
    # reset the variables
    name = None
    email = None
    user_name = None
    redirect('/')

@route('/')
def home():
	name = None
	email = None
	user_name = email
	session = request.environ.get('beaker.session')
	if session['_id'] in local_credentials:
		# retrieve the name and email from the Google Plus API
		plus = build('plus', 'v1', credentials= local_credentials[session['_id']])
		plus_details = plus.people().get(userId='me').execute()
		name = str(plus_details['name']['givenName']) + " " + str(plus_details['name']['familyName']) 
		email = str(plus_details['emails'][0]['value'])
		user_name = email
	# create a global dictionary, h, to contain the count history of every word	
	global saved_h
	global h
	global most_recent
	
	# this part of code simply uses pickle to store search history for unique users
	# it stores this: {'user1' : 'history_of_user1', 'user2' : 'history_of_user2'}
	# change user_name for unique user id
	# user_name = "Alan"
	if os.path.getsize('saved_dictionary.pickle') > 0:
		# load the current dictionary of all users and find the current one
		with open('saved_dictionary.pickle', 'rb') as dict_file:
			saved_h = pickle.load(dict_file)

		if user_name in saved_h:
			h = saved_h[user_name]
		else:
			h = []
	else:
		h = []
		saved_h = {}

	if os.path.getsize('mostrec_dictionary.pickle') > 0:
		# load the current dictionary of all users and find the current one
		with open('mostrec_dictionary.pickle', 'rb') as dict_file:
			most_recent = pickle.load(dict_file)

		if user_name in most_recent:
			mr = most_recent[user_name]
		else:
			mr = []
	else:
		mr = []
		most_recent = {}


	#try:
	#	h
	#except NameError:
	#	global h
	#	h = []

	# parses the input string to generate a dictionary and output results
	# request to get the value 'keywords' from HTML
	if request.params.get('keywords'):
		searchstring = request.params.get('keywords')
		
		# change all input to lowercase
		searchstring = searchstring.lower()
	else:
		searchstring = ""

	# create a dictionary of tuples
	d = []

	for word in searchstring.split():
		if [x for x, y in enumerate(d) if y[0] == word]:
			index=[x for x, y in enumerate(d) if y[0] == word]
			tup = d[index[0]]
			tup[1] = tup[1] + 1
		else:
			d.append([word,1])
		if [x for x, y in enumerate(h) if y[0] == word]:
			index=[x for x, y in enumerate(h) if y[0] == word]
			tup = h[index[0]]
			tup[1] = tup[1] + 1
		else:
			h.append([word,1])
		# update most recent here:
		print word
		try:
			if (mr.index(word)):
				mr.remove(word)
				mr = [word] + mr
			else:
				if len(mr) > 20:
					mr = mr[:-1]
				mr = [word] + mr
		except ValueError:
			if len(mr) > 20:
				mr = mr[:-1]
			mr = [word] + mr
	
	# display the searched string
	html_searched_string = "<p1>Search for \"<i>" + searchstring + "</i>\"</p1>"
	
	# display the history
	html_top_20 = "<p1>Top 20 Searched Words</p1>"
	h_top = sorted(h, key=lambda x:x[1], reverse=True)[:20]

	# get name here (Initially set as None)
	#name = None
	#name = "Joseph"
	# get email here
	#email = "j.taehyun.kim@gmail.com"

	# update history dictionary to pickle file
	saved_h[user_name] = h_top
	html_most_recent = "<p1>Most Recent 20 Words</p1>"

	with open('saved_dictionary.pickle', 'wb') as dict_file:
		pickle.dump(saved_h, dict_file)

	# update most recent
	most_recent[user_name] = mr

	with open('mostrec_dictionary.pickle', 'wb') as dict_file:
		pickle.dump(most_recent, dict_file)

	# if there is a searched string, then output the page with tables
	if len(searchstring):
		#return getHtmlfile() + html_searched_string + dic_to_table(d, 'results') + "<br>" + html_top_20 + dic_to_table(h_top, 'history')
		if name is not None:
			return template('index_search.tpl',user_name = name, user_email = email) + "<div id=content>" + html_searched_string + dic_to_table(d, 'results') + "<br>" + html_top_20 + dic_to_table(h_top, 'history') + "<br>" + html_most_recent + list_to_table(mr,'results') + "</div>" 
		else:
			return template('index_search.tpl',user_name = name, user_email = email) + "<div id=content>" + html_searched_string + dic_to_table(d, 'results') + "<br>"
		
	else:
		# output start page if there is no table to be displayed
		#return getHtmlfile()
		return template('index_initial.tpl',user_name = name, user_email = email)

run(app=main_app, host='0.0.0.0', port=80, debug=True)
