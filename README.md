# Qolshatyr

## Introduction
Qolshatyr addresses a critical personal safety concern by offering users more than just an application; it provides a reliable digital companion for journeys. The application allows users to input detailed information about their location, destination, and expected arrival time before departure. Once activated, the application continuously tracks the user's location in real-time. Users can specify their mode of transportation, including transportation details, and select departure and destination points on the map, enabling the application to save the route and streets traversed in history. Upon setting departure and expected arrival times, the application initiates a timer. If the user fails to confirm their arrival within 5 minutes of the planned time, the application notifies emergency contacts via message and call. In case of delays, such as traffic or additional stops, users can update the time information to avoid false alarms. Qolshatyr also reminds users to confirm their location 10 and 5 minutes before the expected arrival time, minimizing the risk of missing check-ins.

## Features to Implement
1. [x] **Real-time Location Tracking:**
   - Utilize Flutter packages for real-time location tracking.
   
2. [ ] **Journey Information Input:**
   - Allow users to input detailed journey information such as location, destination, mode of transportation, and departure/arrival times.
   
3. [ ] **Route Saving:**
   - Implement functionality to save routes and streets traversed during the journey.
   
4. [ ] **Timer Activation:**
   - Develop a timer feature based on the expected arrival time to track journey progress.
   
5. [ ] **Delay Notifications:**
   - Enable users to update time information in case of delays to prevent false alarms.
   
6. [ ] **Emergency Alert System:**
   - Implement emergency contact notification via message and call if the user fails to confirm arrival within 5 minutes of the planned time.
   
7. [ ] **Reminder Notifications:**
   - Send reminders to users 10 and 5 minutes before the expected arrival time to confirm their location and minimize the risk of missing check-ins.
   
8. [ ] **UI Design:**
   - Design user interface screens to facilitate easy interaction with the application, considering the features mentioned above.

## Database Solution
For the database solution, consider using:
- **Hive**: For local storage of user data and journey history.
- **Firebase Firestore**: For real-time synchronization and storage of user information, emergency contacts, and journey data.

## Flutter Packages
Use the following Flutter packages to facilitate development:
- [x] **google_maps_flutter**: For integrating interactive maps and displaying routes.
- [x] **location**: For accessing device location and implementing real-time location tracking.
- **flutter_local_notifications**: For sending reminder notifications to users.
- **firebase_core** and **cloud_firestore**: For integrating Firebase services such as authentication and real-time database storage.
- **riverpod**: For dependency injection and state management.