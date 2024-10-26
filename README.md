# Qolshatyr
## Introduction
Your personal safety app. For more detailed information please contact me.

## Features
Actually, there are more features! I just don't wanna fill this README.

1. [x] **Real-time Location Tracking**
   
2. [x] **Polyline generation:** Uses GeoJSON.
   
4. [x] **Timer Activation:** A timer feature based on the expected arrival time to track journey progress.
   
5. [x] **Emergency Alert System:** Uses [Twilio](https://www.twilio.com/en-us) for sending emergency alerts via SMS.
   
6. [x] **Check-In Notifications:** Send reminders to users 10 and 5 minutes before the expected arrival time to confirm their location and minimize the risk of missing check-ins. Requires photo conirmation in it.

7. [x] **Localization:** Supports three languages: English, Kazakh, and Russian.

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
3. Add config files

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
