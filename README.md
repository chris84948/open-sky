# Open Sky

Open Sky is a Dark Sky inspired weather app created for Android (because Apple has bought the app). The UI was designed with inspiration from Dark Sky with some small changes (mostly due to the data available). In theory, the app is cross-platform, but no work has been made on the iOS part.

It's written in Flutter, using the [OpenWeatherMaps API](https://openweathermap.org/api) and Google Maps API.

It's available here as a fully open-source app. No API keys will be provided.


## Android App On Play Store

This app is available on the Play Store, but users will still have to provide an API key for OpenWeatherMaps. 

Due to the limitations on the free keys (60 calls/minute), all users will need to sign up for the API and enter their own user keys (this is all explained in the app).

- [Android Play Store Link]()
- [OpenWeatherMaps API Sign Up Link](https://home.openweathermap.org/users/sign_in)

## Build
	
To build the app, you'll need to do the following

- Install flutter
- Sign up for a GoogleMaps API key using the Google Cloud Platform and get a free API key for Android/iOS apps. [See instructions here](https://pub.dev/packages/google_maps_flutter)
- Create a file called keys.properties in the main app folder and add the key for google maps in the file in the format
	googleMapsApiKey={APIKEY}
- this will be automatically referenced when building for Android. It's not implemented in iOS right now.
	
This app uses a slightly modified version of the google_maps_flutter package. I did this to add the forecast tile data from OpenWeatherMap. This is included in the project. Because I just wanted to get this running, I didn't properly change the google_maps_flutter repo, and submit a change request, so just ignore the hackery.
