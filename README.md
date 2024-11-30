# NotifyChat

- NotifyChat is a Flutter app that integrates Firebase Cloud Messaging (FCM) to implement a dynamic notification system where users can subscribe to different channels, receive push notifications in both the foreground and background, and interact within chat rooms managed by Firebase Realtime Database and Firestore 🔔💬.

## 🌟 Features

- **Push Notifications:**
  - Users can subscribe to various channels.
  - Push notifications can be sent to all users, specific topics (channels), or specific devices.
  - Notifications are handled both in the foreground and background.
- **Channel Subscriptions:**
  - Users can subscribe to and unsubscribe from different channels.
  - Channel data is stored in Firestore for persistence.
- **Real-time Chat:**
  - For each channel, a chat room is created in the Firebase Realtime Database.
  - Users can send and receive messages in real-time.

## 🔧 Prerequisites

- Flutter SDK installed on your machine.
- Firebase project set up in [Firebase](https://firebase.google.com/).
- Firebase Cloud Messaging enabled for your project.
- An Android emulator / IOS simulator, or a real device to run the app.

## 📱 How to Use

1. **Firebase Push Notifications:**
   - You are able to subscribe to channels (topics) to receive targeted notifications.
   - Test notifications can be sent from the Firebase Console to all users, specific topics, or specific devices.
2. **Subscription and Unsubscription:**
   - You can subscribe or unsubscribe to channels directly from the UI.
   - The app will handle storing your subscriptions in Firestore for persistence.
3. **Foreground and Background Notifications:**
   - Push notifications are handled when the app is in the foreground and when it’s minimized in the background.
   - Notifications are displayed with relevant content (e.g., new messages, channel updates) for you instantly.
4. **Real-Time Messaging:**
   - Each channel has a chat room created in the Firebase Realtime Database.
   - You have the option to send messages that are immediately visible to other subscribed users.

## 🚀 How to Run

1. **Clone the repository:**
   ```
   git clone https://github.com/nadaamohhamed/NotifyChat.git
   cd notifychat
   ```
2. **Install dependencies:**

   ```
   flutter pub get
   ```

3. **Set up Firebase for your platform (Android, iOS, or Web) and configure it according to the Firebase setup instructions.**
4. **Run the app:**
   ```
   flutter run
   ```
