### Basic Yelp client

This is a headless example of how to implement an OAuth 1.0a Yelp API client. The Yelp API provides an application token that allows applications to make unauthenticated requests to their search API.

###Search results page

   * Table rows should be dynamic height according to the content height   - (**Completed**)
   * Custom cells should have the proper Auto Layout constraints - (**Completed**)
   * Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does). -(**Completed**)
   * Optional: infinite scroll for restaurant results - (**Completed**)
   * Optional: Implement map view of restaurant results - (**Completed**)

###Filter page. Unfortunately, not all the filters are supported in the Yelp API.

   * The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off). - (**Completed**)
   * The filters table should be organized into sections as in the mock. - (**Completed**)
   * You can use the default UISwitch for on/off states. Optional: implement a custom switch - (Implemented customizing the uiswitch)
   * Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings. - (**Completed**)
   * Optional: Radius filter should expand as in the real Yelp app - (**Completed**)
   * Optional: Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.) - (**Completed**)
   * Optional: Implement the restaurant detail page. - (**Completed**)
