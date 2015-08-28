#! /usr/bin/env python

import urllib.request
import json

prompt = "> "
titlePrompt = "Enter Movie/TV Show Title: "
typePrompt = "Enter media type to search for (movie/series/episode): "

#
# main menu
#
def mainMenu():
    print ("\n################################\n")
    print ("1. Get Movie/TV information (Known title/year)")
    print ("2. Search for Movie/TV information")
    print ("0. Quit")
    print ("\n################################\n")

#
# get known movie/tv info
#
def getMovieTv():
    print ("\n************************************")
    print ("\nGet Movie/Tv information: \n")

    title = input(titlePrompt)
    while(title == ""):
        title = input(titlePrompt)

    year = input(title.capitalize() + " year (if known): ")

    # format IMDBAPI url (add '+' between title spaces)
    url = "http://www.omdbapi.com/?t=" + title.replace(" ", "+") + "&y=" + year + "&plot=long&r=json"

    # assign create dict of json object
    jobject = serialiseResponse(url)

    if checkResponse(jobject) == True:

        title = jobject["Title"] + " [" + jobject["Year"] + "]" + " - " + jobject["Genre"]
        language = "Language: " + jobject["Language"]
        plot = jobject["Plot"]
        link = "\n\tIMDB link: http://www.imdb.com/title/" + jobject["imdbID"]

        print("\n" + title + "\n")
        print(language + "\n")
        print(plot + link)

    repeat = input("\nSearch Again (y/n): ")
    if repeat == 'y':
        getMovieTv()

#
# do a movie/tv search
#
def searchMovieTv():
    print ("\n************************************")
    print ("\nSearch Movie/Tv info: \n")

    title = input(titlePrompt + "\n" + prompt)
    while(title == ""):
        title = input(titlePrompt + "\n" + prompt)

    print (title + " year (if known): ")
    year = input(prompt)

    # format IMDBAPI url (add '+' between title spaces)
    url = "http://www.omdbapi.com/?s=" + title.replace(" ", "+") + "&y=" + year + "&r=json"

    # assign create dict of json object
    jobject = serialiseResponse(url)

    # error check result
    if 'Error' in jobject:
        print ("Error: " + title + " not found!")
    else:
        # iterate through and print required information
        for res in jobject["Search"]:

            mediaType = res["Type"].capitalize() + ": "
            title = res["Title"]
            year = res["Year"]
            link = "\n\tIMDB link: http://www.imdb.com/title/" + res["imdbID"]

            print(mediaType + title + " [" + year + "]" + link)

    repeat = input("\nSearch Again (y/n): ")
    if repeat == 'y':
        searchMovieTv()

#
# serialise the json into dict
#
def serialiseResponse(url):
    response = urllib.request.urlopen(url)

    jstring = json.dumps(json.loads(response.readall().decode('utf-8')), sort_keys=True, indent=4)

    #print(jstring)
    return json.loads(jstring)

#
# check response code
#
def checkResponse(jobject):
    # check for existence of movie name
    if jobject["Response"] == 'False':
        print("\nError: " + jobject["Error"] + "\nMaybe search again with/without specific year")
    else:
        return True

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
