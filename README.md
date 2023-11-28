# The Weather App🚀

![weather icons](https://i.imgur.com/CzZNbV0.jpg)

A weather map made with [Flutter](https://flutter.dev) and a design provided by [heyflutter.com](https://heyflutter.com) as a coding challenge.
For quick installation check [releases](https://github.com/akbng/heyflutter-challenge-ii/releases) - the Android apk will be attached to it.

## Features

- Get the current location.
- Show the current weather based on the location.
- Show the weather forecast for the next 4 days.
- Search for different locations i.e. cities and save them.
- Let the user choose custom images for their chosen location.
- Show the current weather and forecast for that location.
- Search from the saved location.
- Let the user update the location background.
- Deleting a saved location.

## Screen Recordings

https://github.com/akbng/heyflutter-challenge-ii/assets/91788199/078e64f2-c802-49f2-9b61-17543135b6ed

If the video is not playing, try to download and run it locally.

## Known Issues/Bugs

- [x] Duplicate location can be added by the user if the image is different.
- [x] The Current location was saved twice.
- [x] Adding a new location does not appear immediately on the drawer.
- [x] No error messages were shown to the user.
- [x] Image searching sometimes gets stuck in the loading state.
- [ ] The codebase is super messy and deliberately needs a refactor.

## Possible Enhancements

- UX improvements on the add location screen.
- Better loading indicators while weather information is fetched - like skeleton animations.
- The initial loading screen.

## Build Instructions

I have only tested the app on Browser and Android platforms only. So, it might not behave properly on other platforms. To Build the APK from this repo follow the below instructions:

- Clone this repo: `git clone https://github.com/akbng/heyflutter-challenge-ii.git && cd heyflutter-challenge-ii`

- Get the API key from [Weather API](https://www.weatherapi.com/my/) for weather information
- Create a new project and copy the client ID from [Unsplash.com](https://unsplash.com/documentation#getting-started) for image searching.
- Create a `.env` file in the _root of the project directory_ and save the API keys with the following name: <br> `UNSPLASH_CLIENT_ID` & `WEATHER_API_KEY` <br> Or paste the following in the terminal: <br>

```sh
echo 'WEATHER_API_KEY=<PASTE_YOUR_KEY' >> .env
echo 'UNSPLASH_CLIENT_ID=<PASTE_YOUR_KEY' >> .env
```

- Now run the app using: `flutter run`
- If everything is working fine (which hopefully should), Run: `flutter build apk`
- Finally: `flutter install` to install the APK on a connected device or Install manually from `build/app/outputs/flutter-apk/app-release.apk`
