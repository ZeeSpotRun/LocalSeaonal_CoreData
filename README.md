LocalSeaonal_CoreData
=====================

A sample app with several views, CoreData/Favorites and email functionality

HOME PAGE

The Home page contains a gradient, a circular button with an image, and an animation of a radiating circle around the button to invite the user to press.

LIST

The user then enters a TableViewController where there is (for now) a truncated list of produce in season.

The cells have backgrounds of an image that is blurred and then set to aspect-fill so that each cell contains a slither of the blurred image. The font is chosen to be casual yet have a clarity and brightness that shows against the blurred color-scheme.

The navigation buttons move the user through the year - month by month - while the list of "in season" items changes. For now, this is limited to the initial data.

The list is imported into a simple core data arrangement and stored there.

PRODUCE LIST

Anotherview list the months that the item is in season and a link to a recipes on the web.

WEBVIEW

Clicking on recipes lead to a webpage with recipes for that item. This page as the option to send the webpage as a link via email.
