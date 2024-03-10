
# WebAppify

<img src="WebAppify/Assets.xcassets/AppIcon.appiconset/Icon.png" alt="Icon" width="200"/> 


Webappify is an App that was originally designed to be a mostly working replacement for PWAs after Apple planned to remove them in iOS 17.4 for EU-users. 
Unfortunately for my bank-account but fortunately for everyone else, Apple got enough backlash to re-add support.

Since this App is no longer needed, it's now open source. I might add more docs/comments in the future but currently its in a pretty half-baked state.
That said, if you'd like an example for working configurable Widgets without SwiftData/CoreData, lots of in-app links, shortcut integration or share-extensions, feel free to check it out.
Everything regarding StoreKit is still very much unfinished and will require some setup (and maybe some adjustments) to be fully functional though.

### Using the App
The intended use for this App is for the user to enter several sites they'd like to use. The user would then either configure a widget with the sites they'd like to access or do the same for a shortcut and add that shortcut to their Homescreen. Tapping the site on the Widget or the shortcut will launch the App with a URI that will immediately open a full-screen cover with the website. Currently tapping the same Widget/Shortcut again will reopen the site from its initial state but this could probably be fixed by assigning WKWebViews to each website instead of opening all links on the same one. The app will keep displaying the current website until it's either force-closed or the user selects the 'list-sites' option when long-pressing the App.
