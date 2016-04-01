# Custom Start Page

A custom start page made primarily for Firefox.

If there is interest I could be persuaded to make it work with other browsers.
I will even make it fully responsive at some point in the future.

## Default View

The exciting default view shows the search bar, clock and list of bookmarks.

![Screenshot0](/scripts/startpage/public/img/screenshots/2016-03-31-091905_1920x1080_scrot.png?raw=true "Default view")

## Bookmarks Highlight

Text effect on bookmarks rollover. Now we're getting exciting.

![Screenshot1](/scripts/startpage/public/img/screenshots/2016-03-31-092507_1920x1080_scrot.png?raw=true "Bookmarks highlight")

## Search Bar

Having difficulty remembering the tag for your desired search. Never fear, with
this handy drop down you can get a dynamic list of all your configured search
engines.

![Screenshot2](/scripts/startpage/public/img/screenshots/2016-04-01-152020_1920x1080_scrot.png?raw=true "Search Engines DropDown")

You can even roll-over the entries and the search box will automatically show you
the correct tag.

![Screenshot3](/scripts/startpage/public/img/screenshots/2016-04-01-135649_1920x1080_scrot.png?raw=true "Search Engines DropDown with tags")

Find the one you want and click on it to be taken to search box
and access the knowledge of the world.

If you don't specify a search tag not to worry as it will fallback to a default
user configurable search engine *see below*.

**Update**: The search box is now smart enough to recognise the site name you
configured if you don't want to remember the tag; *and* it's case insensitive.

![Screenshot4](/scripts/startpage/public/img/screenshots/2016-04-01-140601_1920x1080_scrot.png?raw=true "Search Box Site Name")

The search box can even recognise urls so rather than searching for the url it
will take you directly to the site.

![Screenshot5](/scripts/startpage/public/img/screenshots/2016-04-01-153146_1920x1080_scrot.png?raw=true "Search Box URL")

The search strings will be fully url encoded *AND* if you need to search for
something using the *:* delimiter you can rest easy in the knowledge that your
query will be sent as you intended.

![Screenshot6](/scripts/startpage/public/img/screenshots/2016-04-01-135222_1920x1080_scrot.png?raw=true "Search Box Tomfoolery")

## Configuring Bookmarks and Search Engines

Search engine and bookmark preferences are easily customisable and updateable.
All you need to do is edit [lists.js](https://github.com/siidney/dotfiles/blob/master/scripts/startpage/public/js/lists.js) to include *your* favourite site or search engine.

**Update**: The way search engines are stored has been redesigned for your
convenience so as now to include custom tags and a title for the link.

## Known Issues

**Search Bar**
The about config pages from firefox cannot be opened programmatically
(security feature). So in order to access them you need to manually invoke the url bar as before.
