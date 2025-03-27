# Qolshatyr
## Introduction
Your personal safety app. For more detailed information please contact me.

## Features
Brief summary of the mian functions.

1. [x] **Real-time Location Tracking**
   
2. [x] **Polyline generation:** Uses GeoJSON to draw and store user routes.
   
4. [x] **Timer Activation:** A timer feature based on the expected arrival time to track journey progress.
   
5. [x] **Emergency Alert System:** Uses Telegram API to send emergency alerts and precise geolocation.
   
6. [x] **Check-In Notifications:** Send reminders to users 10 and 5 minutes before the expected arrival time to confirm their location and minimize the risk of missing check-ins. Requires photo conirmation in it.

7. [x] **Localization:** Supports three languages: English, Kazakh, and Russian.

8. [x] **Video-Recording:** Records user surroundings + check in photo and upload it to the Firebase. Then the emergency photos can access it through the Telegram Bot.

9. [x] **Voice Recognition:** Uses dart package to recognize custom SOS commands.
   
## Installation
To get started with Qolshatyr, follow these steps:

1. Clone the repository:

```bash
git clone https://github.com/assanbayg/qolshatyr_mobile.git
cd qolshatyr_mobile
```

2. Install dependencies:

```bash
flutter pub get
```
3. Add config files. Perhaps there are more since the update, so please contact me for more details.

```bash
- firebase.json: ./
- google-services.json: ./android/app/
- firebase_options.dart: ./lib/
- local.properties: ./android/local.properties
- env.dart: ./lib/features/common/services/
```

4. Run the app:

```bash
flutter run
```
