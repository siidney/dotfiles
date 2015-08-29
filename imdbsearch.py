#! /usr/bin/env python

#   Filename:       imdbSearch.py
#   Created:        27/08/2015
#   Revision:       None
#   Version:        1.0
#   Author:         Siidney Watson
#   Description:
#
#   A simple Python script to query the imdbAPI and output a python useable
#   serialised version of the returned json.
#
#   Requires an active internet connection to connect to the imdb servers.
#
#   Written (in spite of the fact that the author is not a Python fan) as
#   opening a new tab, going to imdb, clicking the search box and typing in
#   the request is just too much effort.
#
#   LINUX USERS:
#
#   Symlink a copy of this (and any other script you regularly use) into
#   /usr/local/bin/ to run from anywhere and the command line need not be left.
#   A logout/in is needed for autocomplete to work.
#

import urllib.request
import urllib.parse
import json
import operator

prompt = "> "
titlePrompt = "Enter Movie/TV Show Title: "
typePrompt = "Enter media type to search for (movie/series/episode): "

#
# main menu
#
def mainMenu():
    print ("\n################################\n")
    print ("1. Get Movie/TV information (Known title/year)")
    print ("2. Search for Movie/TV information (Sorted by year)")
    print ("0. Quit")
    print ("\n################################\n")

#
# Get known movie/tv info
# Returns a single search result. Useful if the exact title is known.
#
def getMovieTv():
    print ("\n************************************")
    print ("\nGet Movie/Tv show information: \n")

    title = input(titlePrompt)
    while(title == ""):
        title = input(titlePrompt)

    year = input(title.title() + " year (if known): ")

    # format IMDBAPI url (add '+' between title spaces, make url safe if
    # title contains non ASCII chars)
    url = "http://www.omdbapi.com/?t=" + urllib.parse.quote_plus(title)  + "&y=" + year + "&plot=long&r=json"

    # assign create dict of json object
    jobject = serialiseResponse(url)

    if checkResponse(jobject) == True:

        title = jobject["Title"] + " [" + jobject["Year"] + "]"
        meta = jobject["Rated"] + " | " + jobject["Runtime"] + " | " + jobject["Genre"] + " | " + jobject["Released"] + "\n"
        language = "Language: " + jobject["Language"] + "\n"
        rating = "IMDBRating: " + jobject["imdbRating"] + "\n"
        plot = "\n" + jobject["Plot"]
        link = "\n\tIMDB link: http://www.imdb.com/title/" + jobject["imdbID"]

        print ("\n" + title + "\n" + meta + language + rating + plot + link)

    repeat = input("\nSearch Again (y/n): ")
    if repeat == 'y':
        getMovieTv()

#
# Do a movie/tv search
# Uses the search flag in the url to return a list of search results.
#
def searchMovieTv():
    print ("\n************************************")
    print ("\nSearch Movie/Tv info: \n")

    title = input(titlePrompt)
    while(title == ""):
        title = input(titlePrompt + "\n" + prompt)

    year = input(title.title() + " year (if known): ")

    # format IMDBAPI url (add '+' between title spaces, make url safe if
    # contains non ASCII chars)
    url = "http://www.omdbapi.com/?s=" + urllib.parse.quote_plus(title) + "&y=" + year + "&r=json"

    # assign create dict of json object
    jobject = serialiseResponse(url)

    if checkResponse(jobject) == True:
        # sort by year and print required information
        indices = sortResults(jobject["Search"])
        # select year ordered elements from the indices generated above
        for i in indices:
            mediaType = jobject["Search"][i]["Type"].capitalize() + ": "
            title = jobject["Search"][i]["Title"]
            year = jobject["Search"][i]["Year"]
            link = "\n\tIMDB link: http://www.imdb.com/title/" + jobject["Search"][i]["imdbID"]

            print (mediaType + title + " [" + year + "]" + link)

    repeat = input("\nSearch Again (y/n): ")
    if repeat == 'y':
        searchMovieTv()

#
# Serialise the json into dict
# The response received from imdb is in binary format so needs serialising to a
# string and then re-serialising to a python object before use.
#
def serialiseResponse(url):
    # check for active internet connection
    try:
        response = urllib.request.urlopen(url)
    except urllib.error.URLError as e:
        print ("\n****************************")
        if hasattr(e, 'reason'):
            print ("Connection error: Are you connected to the internet?")
            print ("Reason: ", str(e.reason))
        elif hasattr(e, 'code'):
            print ("The server couldn't fulfill the request.")
            print ("Error code: " + e.code )
        print ("\n****************************")

        return
    else:
        # serialise to json formatted string
        jstring = json.dumps(json.loads(response.readall().decode('utf-8')), sort_keys=True, indent=4)

        # deserialise into a python object (dict)
        return json.loads(jstring)

#
# Check response code
# Checks to see if the 'Error' key exists in the jobject. If so prints the
# 'Error' value.
#
def checkResponse(jobject):
    # ensure a proper response received (internet connection)
    if jobject == None:
        return False
    else:
        # check for existence of 'Error' key
        if 'Error' in jobject:
            print ("\nError: " + jobject["Error"] + "\n")
            print ("Check your spelling and/or try searching again with/without specific year.")
        else:
            return True

#
# returns a tuple of dict indices sorted by year
# iterates through the jobject and adds the index and year to a new list
# sorts the list by year, keeping the indices with their original year
# creates a new list of just the newly sorted indices
# returns the indice list a tuple to ensure it cannot be changed
#
def sortResults(jobject):
    resLength = len(jobject)

    years = []
    indices = []
    # create list of indices and years
    for i in range (0, resLength):
        # only get beginning for year to account for ranges (xxxx-xxxx)
        years.append((i, jobject[i]["Year"][:4]))

    # sort the items by year keeping the original indices linked to each year
    years.sort(key=operator.itemgetter(1))

    # create a list of the indices
    for i in range (0, len(years)):
        indices.extend([years[i][0]])

    # return a tuple of indices (immutable)
    return tuple(indices)

#
# MAIN
#
def main():

    menuOptions = {
        '1':getMovieTv,
        '2':searchMovieTv,
    }

    mainMenu()
    choice = input(prompt)

    while choice != '0':
        try:
            menuOptions[choice]()
        except KeyError:
            print ("Incorrect menu option.")

        mainMenu()
        choice = input(prompt)

if __name__ == "__main__":
    main()
