from bottle import route, run, request, response, redirect, app, hook
from bottle import static_file
from bottle import template
from beaker.middleware import SessionMiddleware
import bottle
import pickle
import os
import operator
import json
# import mongodb


# max number of url per page
max_url_len = 5
searchstring = ""

bottle.TEMPLATE_PATH.insert(0, './public')

session_opts = {
	'session.type': 'cookie',
	'session.key': '3', #maybe need to encrypt and such........
	'session.secret': 1, #same here.......
    'session.cookie_expires': True,
    'session.auto': True,
	'session.validate_key': True
}


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

'''
@route('/oauth2callback')
def redirect_page():
    session = request.environ.get('beaker.session')
    # get the authorization code and using the authorization code retrieve the credentials
    code = request.query.get('code', '')
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
'''
@error(404)
def error404(error):
	return template('error.tpl')

@route('/')
def home():
	name = None
	email = None
	user_name = email
	session = request.environ.get('beaker.session')
	if session['_id'] in local_credentials:
		# retrieve the name and email from the Google Plus API

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

	global searchstring
	first_word = ""

	# parses the input string to generate a dictionary and output results
	# request to get the value 'keywords' from HTML
	if (request.params.get('keywords')) :
		searchstring = request.params.get('keywords')
	
		# change all input to lowercase
		searchstring = searchstring.lower()
		string_to_list = searchstring.split()
		first_word = string_to_list[0]
	else :
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

	#=====================================================================================================
	# Lab 3 Fetching from Database implementation
	
	# fetch 3 dictionaries here
	# dict_find_word is the input of the list of urls to print 
	# first_word is the first_word of input string - already exists
	# word_id = function(first_word)
	# dict_url = function(word_id)
	with open('lexicon.json', 'r') as f:
		for item in f:
			item = json.loads(item)
			if item["word"]== first_word:
				print first_word
				keyword_id = item["word_id"]
				break
			else:
				keyword_id = -1
	print keyword_id

	with open('inverted_index.json', 'r') as f:
		for item in f:
			item = json.loads(item)
			print type(keyword_id)
			if item["word_id"]== keyword_id:
				dict_url_list = item["url_list"]
				print dict_url_list
				break
			else:
				dict_url_list = []
	print dict_url_list

	dict_rank = []
	with open('scores.json', 'r') as f:
		for item in f:
			item = json.loads(item) 
			dict_rank.append(item)
	print dict_rank

	dict_doc_id = []
	with open('document_index.json', 'r') as f:
		for item in f:
			item = json.loads(item) 
			dict_doc_id.append(item)
	print dict_doc_id
	
	dict_combined = []

	'''
	mongodb.initialize()
	try:
		keyword_id = mongodb.getData("lexicon", { "word": first_word })[0]["word_id"]
		dict_url_list = mongodb.getData("inverted_index", { "word_id": keyword_id })[0]["url_list"]
		dict_rank = mongodb.getData("scores", {})
		dict_doc_id = mongodb.getData("document_index", {})
		dict_combined = []
		print dict_rank
	except:
		dict_url_list = []
		dict_rank = []
	'''

	if len(dict_url_list) > 0:
		# using dict_rank, get a list of tuples ordered by page rank
		dict_rank_sorted = sorted(dict_rank, key=lambda k: k['score'])
		# using dict_rank_sorted, find the url name corresponding to the doc_id
		# dict_combined is list with INCREASING page rank order
		for item in dict_rank_sorted :
			for temp_dict in dict_doc_id :
				if temp_dict['doc_id'] == item['doc_id'] and item['doc_id'] in dict_url_list:
					dict_combined.append(temp_dict['url'])
	
		# reverse the array
		dict_combined = list(reversed(dict_combined))

		html_pages = ''	
	
		# if length is greater than max_url_len
		# implement static pagination
		#page_no = int(request.params.get('page_no'))
		if request.params.get('page_no') :
			page_no = int(request.params.get('page_no'))
		else :
			page_no = 1;

		if (len(dict_url_list) > max_url_len) :
			page_num,past_page_num = divmod(len(dict_combined),max_url_len)		
			if past_page_num != 0 :
				page_num += 1

			html_pages = '<form id="search" action="/" method="get"><div id="content_bot"><div id="page_div" align="center"><div class="pagination">'
			for page in range(page_num) :
				# this section of code prints maximum 10 pages and when page_no is moved, it moves the pages in the same direction
				if page+1 > page_no + 5:		
					pass
				elif page+1 < page_no - 5:
					pass
				elif page+1 == page_no :
					html_pages += '<button class="active" name="page_no" value="'+ str(page+1) +'">'+str(page+1)+'</button>'
				else :
					html_pages += '<button name="page_no" value="'+ str(page+1) +'">'+str(page+1)+'</button>'
			html_pages += '</div></div></div></form>'
		else :
			html_pages = ''
			pass

		#=====================================================================================================
		# print the actual content of dict_combined
		# page_no is given and is used to print the correct urls
		page,last_page_num = divmod(len(dict_combined),max_url_len)	

		if last_page_num != 0:
			page += 1

		if page_no > page :	
			return error404(404)

		url_print = ""
		html_url = '<div id="content">'
		if page == page_no and last_page_num != 0 :
			# we are on the last page with last_page_num elements
			for i in range(last_page_num):
				url_print = dict_combined[max_url_len*(page_no-1)+i]
				html_url += '<p2><a href="' + url_print + '">' + url_print + '</a></p2></br></br>'
		else :
			# we are on some other page; print max_url_len many urls
			for i in range(max_url_len):
				url_print = dict_combined[max_url_len*(page_no-1)+i]
				html_url += '<p2><a href="' + url_print + '">' + url_print + '</a></p2></br></br>'
	
		html_url += '</div>'
		#=====================================================================================================
	else :
		html_url = '<div id="content"><p2>No results found</a></div>'

	
	# if there is a searched string, then output the page with tables
	if len(searchstring):
		#=====================================================================================================
		# remove the searched & history table temporarily for lab 3
		
		#if name is not None:
		#	return template('index_search.tpl',user_name = name, user_email = email) + "<div id=content>" + html_pages + html_searched_string + dic_to_table(d, 'results') + "<br>" + html_top_20 + dic_to_table(h_top, 'history') + "<br>" + html_most_recent + list_to_table(mr,'results') + "</div>" 
		#else:
		#	return template('index_search.tpl',user_name = name, user_email = email) + "<div id=content>" + html_pages + html_searched_string + dic_to_table(d, 'results') + "<br>"
		#=====================================================================================================
		if len(dict_rank) > 0 and len(dict_combined) > max_url_len :
			return template('index_search.tpl',user_name = name, user_email = email, searched_string = searchstring, page_no = page_no) + html_pages + template('index_search_end.tpl',user_name = name, user_email = email, searched_string = searchstring, page_no = page_no) + html_url
		else :
			return template('index_search_nopage.tpl',user_name = name, user_email = email, searched_string = searchstring) + html_url
			
	else:
		# output start page if there is no table to be displayed
		#return getHtmlfile()
		return template('index_initial.tpl',user_name = name, user_email = email, picture="csc326-logo.png")

run(app=main_app, host='0.0.0.0', port=8080, debug=True)
