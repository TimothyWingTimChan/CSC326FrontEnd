from pymongo import MongoClient
from pymongo.errors import BulkWriteError

db = None
table_list = ['lexicon', 'scores', 'inverted_index', 'document_index']

def initialize():
    client = MongoClient('localhost', 27017)   # imported in mongodb.py in this directory
    global db
    db = client.searchresult
    return db

def insertData(tableName = None, insert_data = None):
    print insert_data
    if tableName == None or insert_data == None:
        return None

    if tableName not in table_list:
       return None

    # num = len(insert_data)

    # if num == 1:
    #     result = db[tableName].insert_one(insert_data)
    #
    # if num > 1:
    # if(tableName in db.collection_names()):
    # try:
    result = db[tableName].insert_many(insert_data)
    # for element in insert_data:
    #     result = db[tableName].insert_one(element)
    #     print "Inserted the data with: {0}".format(result)
    # except BulkWriteError as exc:
    #     exc.details

    print "Inserted the data with: {0}".format(result)

def getData(tableName= None, queryParam = None):
    if tableName == None or queryParam == None:
        return None

    if tableName not in table_list:
       return None

    # if num == 1:
    #     result = db[tableName].find_one(queryParam)
    #     # print "found the data:\n {0}".format(result)
    #     return result

    # if tableName in db.collection_names():
    result = list(db[tableName].find(queryParam))
    return result
    # else:
    #     print "table does not exist in the db!!!!!"
    #     return None

def deleteData(tableName = None, queryParam = None, num = 0):
    if tableName == None or queryParam == None or num == 0:
        return None

    if tableName not in table_list:
       return None

    if num == 1:
        result = db[tableName].delete_one(queryParam)

    if num > 1:
        result = db[tableName].delete_many(queryParam)

    print "Delete operation {0} and deleted {1} items".format(result.acknowledged, result.deleted_count)

def updateData(tableName = None, queryParam = None, updateData = None, append_field = False, num = 0):
    if tableName == None or queryParam == None or updateData == None or num == 0:
        return None

    if tableName not in table_list:
       return None

    updateQuery = {
        '$set': updateData
    }
    # print True if append_field == True else False
    multi_val = True if num > 1 else False

    result = db[tableName].update(queryParam, updateQuery, upsert=append_field, multi = multi_val)
    print updateQuery
    # print result
    print "updated query data: {0}".format(result)


'''
This is the example way of running the database
'''

# for x in xrange(1, 10):
#     business = {
#         'name' : names[randint(0, (len(names)-1))] + ' ' + names[randint(0, (len(names)-1))]  + ' ' + company_type[randint(0, (len(company_type)-1))],
#         'rating' : randint(1, 5),
#         'cuisine' : company_cuisine[randint(0, (len(company_cuisine)-1))]
#     }
#     #Step 3: Insert business object directly into MongoDB via isnert_one
#     # result=db.reviews.insert_one(business)
#     result = insertData('lexicon', business, num=1)
#     #Step 4: Print to the console the ObjectID of the new document
#     # print('Created {0} of 100 as {1}'.format(x,result.inserted_id))
# #Step 5: Tell us that you are done
#
# # fivestar = db.reviews.find_one({'rating': 5})
# fivestar = getData('lexicon', {'rating': 5}, num=1)
# print(fivestar)
#
#
# updateData('lexicon', {'rating': 5}, {'rating': 3}, num = 1)

# fivestar = getData('lexicon', {'rating': 5}, num = 1)
# print('finished creating 100 business reviews')
