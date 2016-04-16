/*
 * SEARCH ENGINES
*/
var searchEngines = {
    "Google" : [
    {"tag": "google",   "url": "https://www.google.com/search?q=",  "default": "true"}
    ],
    "DuckDuckGo": [
    {"tag": "ddg",      "url": "https://duckduckgo.com/?q=",        "default": "false"}
    ],
    "GitHub": [
    {"tag": "gh",       "url": "https://github.com/search?q=",      "default": "false"}
    ],
    "IMDB": [
    {"tag": "imdb",     "url": "https://www.imdb.com/find?s=all&q=", "default": "false"}
    ],
    "Wikipedia": [
    {"tag": "wiki",     "url": "https://en.wikipedia.org/wiki/Special:Search?search=", "default": "false"}
    ],
    "ArchWiki": [
    {"tag": "archwiki", "url": "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=", "default": "false"}
    ],
    "YouTube": [
    {"tag": "yt",       "url": "https://youtube.com/results?search_query=", "default": "false"}
    ],
    "Reddit": [
    {"tag": "rdt",      "url": "https://www.reddit.com/search?q=", "default": "false"}
    ],
    "StackOverflow": [
    {"tag": "so",       "url": "https://www.stackoverflow.com/search?q=", "default": "false"}
    ],
    "RARBG" : [
    {"tag": "rarbg",    "url": "https://rarbg.to/torrents.php?search=", "default": "false"}
    ],
    "The Pirate Bay": [
    {"tag": "tpb",      "url": "https://thepiratebay.se/search/", "default": "false"}
    ],
    "KickAss Torrents": [
    {"tag": "kat",      "url": "https://kat.cr/usearch/", "default": "false"}
    ]
};
/*
 * BOOKMARKED SITES
*/
var bookmarks = {
    "Torrents" : [
    {"sitename": "RARBG",               "url": "https://rarbg.to"},
    {"sitename": "The Pirate Bay",      "url": "https://thepiratebay.se"},
    {"sitename": "Skidrow Reloaded",    "url": "https://www.skidrowreloaded.com"},
    {"sitename": "KickAss Torrents",    "url": "https://kat.cr"}
    ],
    "Linux" : [
    {"sitename": "Github",              "url": "https://www.github.com"},
    {"sitename": "ArchWiki",            "url": "https://wiki.archlinux.org"},
    {"sitename": "Opensource.com",      "url": "https://opensource.com"}
    ],
    "Resources" : [
    {"sitename": "Wolfram Alpha",       "url": "https://www.wolframalpha.com"},
    {"sitename": "DZone",               "url": "https://www.dzone.com"},
    {"sitename": "Rosetta Code",        "url": "https://rosettacode.org"}
    ],
    "Social Media" : [
    {"sitename": "Facebook",            "url": "https://www.facebook.com"},
    {"sitename": "Reddit",              "url": "https://www.reddit.com"}
    ]
};

/*
 * DO NOT REMOVE OR EDIT THESE LINES
 * Unless you want to break everything.
 */
var searchKeys = Object.keys(searchEngines);
var bookmarkkeys = Object.keys(bookmarks);
