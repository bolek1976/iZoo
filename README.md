# iZoo
This small projects it's a demo App that demonstrate how to interact with web service using NSURLSession (no 3rd party libraries) and keep ui responsive
it also use SplitViewController, usefull when the app run on big screens. The app focus its design on showing results in the proper way,
indicating progress while downloading. The data is hosted on firebase and the app does not use coredata, the model its just in memory class.

When the image is downloaded its cached and if the request is made again, the service check if exist on the cache and does not make the
web service call again. Its very simple cache system, and it does not provide more functionality than a "simple cache" using the url 
as key.
