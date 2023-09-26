# TABULA (RASA)

The app "Tabula" was created during a seven week AI app challenge by Adrian & Klaus.

The app enables user to learn languages more effective. AI generates collections of index cards based on your needs (given categories). Play a collection as you would swipe on Tinder.

In this state the app acts more like a prototype, we are planing to develop the app further [see Roadmap](#roadmap). More to come ;)

We see the repository as a place for everyone to feel free to play around with the app, fork the project etc.

https://github.com/kprueger/tabula/assets/39732702/23846476-5947-4fd3-b9a1-32aea9abae2b


[Feature Screenshots tbd]

## Install

On how to build the app for your device see [official flutter.dev doc](https://docs.flutter.dev/deployment/android#building-the-app-for-release)

## Roadmap

### Technical

1. CI/CD Pipeline for ios and android app building
2. CI/CD test automation

### Features

1. Refactor custom Dialog Widget
2. add future builder for collection view and create collection list view
   1. see https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
3. Introduce block architecture
4. collections of collection view showing count of index cards
5. play Session: pattern matching the translation by user input
6. Cache translations/collections for quicker response
7. Breakup Condition of fetching (like 60 seconds)
8. Rework request sentence for more reliable response
9. Introduce more languages
10. Process more viraty of response JSON formats like data, words, other labels etc.
11. bring the create collection view screen back
12. Bring quick and random play session back (+ subtitle indication the play session)
13. support more languages
14. Favorite collection
15. user statistics
16. login
17. Create collection via foto

## Development

### (chatGPT) API KEY

1. Add your AI API key to the .env file
   1. OPEN_AI_API_KEY=\<YOUR-API-KEY\>
2. Generate your models
   1. flutter packages pub run build_runner build

### flutter_card_swiper library

In order to be able to compile and run the project you need to replace the flutter_card_swiper library with out custom version.

Move in the following path:
`[Drive:\Users\username]\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_card_swiper-6.0.0\lib\src`

Replace the `card_swiper.dart` and `typedefs.dart` files with the custom once, found in the repository under **tabula/changes_card_swiper**

## Material

- future builder https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
- material icon https://fonts.google.com/icons?icon.set=Material+Icons&selected=Material+Icons+Outlined:translate:&icon.query=translate&icon.platform=flutter
- GUI element demo https://flutter.github.io/samples/web/material_3_demo/#/
- chatGPT Request https://dartling.dev/building-a-chatgpt-client-app-with-flutter
- TypeAdapter (Hive DB) https://medium.flutterdevs.com/hive-database-with-typeadapter-in-flutter-7390d0e515fa
- DB (Hive) https://docs.hivedb.dev/#/

## USED LIBRARIES

- dart_openai flutter pub add dart_openai
- envied flutter pub add envied
- build_runner COMMAND: flutter packages pub run build_runner build / flutter pub run build_runner build
- flutter pub add --dev envied_generator
- dart pub add --dev build_runner
- hive (DB): flutter pub add hive
- hive flutter: flutter pub add hive_flutter
- hive generator: flutter pub add hive_generator
- flutter card swiper*custom version 6.0.0: flutter pub add flutter_card_swiper
