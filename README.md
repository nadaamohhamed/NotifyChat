# NotifyChat

- NotifyChat is a Flutter app that integrates Firebase Cloud Messaging (FCM) to implement a dynamic notification system where users can subscribe to different channels, receive push notifications in both the foreground and background, and interact within chat rooms managed by Firebase Realtime Database and Firestore 🔔💬.

## 🌟 Features

- **Authentication:**
  - Login and Signup: Users can authenticate using one of three methods:
    - Mobile Number.
    - Google Authentication.
    - Email and Password.
  - Registered Users Only: Access to the app is restricted to authenticated users, ensuring a secure and personalized experience.
- **Push Notifications:**
  - Users can subscribe to various channels.
  - Push notifications can be sent to all users, specific topics (channels), or specific devices.
  - Notifications are handled both in the foreground and background.
  - Users can view all received notifications and dismiss the ones they no longer wish to see, ensuring a clutter-free notification experience.
- **Channel Subscriptions:**
  - Users can subscribe to and unsubscribe from different channels.
  - Channel data & user subscriptions are stored in Firestore for persistence.
- **Channel Management:**
  - Add Channels: Users can create new channels, dynamically adding them to the platform for other users to join and communicate.
  - Remove Channels: Channels can only be deleted by the channel creator or admin to ensure proper management. Deleting a channel removes it from the platform, along with its associated data.
  - List Channels: All available channels can be listed for users to explore and subscribe to. This list is dynamically updated, providing users with the most relevant and active channels to join.
- **Real-time Chat:**
  - For each channel, a chat room is created in the Firebase Realtime Database.
  - Users can send and receive messages in real-time.
- **Event Tracking with Firebase Analytics:**
  - Key user events are logged for better insights and engagement:
    - First-Time Login: Logged when a user logs in for the first time.
    - Channel Subscription: Logged when a user subscribes to a channel.
  - Additional custom events can be added to track other significant user interactions.
- **CI/CD Workflow:**
  - Automated Build and Deployment:
    - The app leverages GitHub Actions and Fastlane for a streamlined CI/CD pipeline.
    - Automated builds are created and distributed using Firebase App Distribution, allowing testers to seamlessly access the latest app versions.

## 🔧 Prerequisites

- Flutter SDK installed on your machine.
- Firebase project set up in [Firebase](https://firebase.google.com/) (Android).
- Firebase Cloud Messaging enabled for your project.
- An Android emulator or a real android device to run the app.

## 📱 How to Use

1. **Authentication:**
   - Use one of the three methods to register and log in:
     - Google Authentication: Seamless login/registration with your Google account.
     - Mobile Number Authentication: Verify your mobile number via OTP.
     - Email and Password Authentication: Traditional email-based registration and login.
2. **Firebase Push Notifications:**
   - You are able to subscribe to channels (topics) to receive targeted notifications.
   - Test notifications can be sent from the Firebase Console to all users, specific topics, or specific devices.
   - Dismiss notifications by dragging the notification tile from end to start.
   - View all the notifications you received with relevant content (e.g., new messages, channel updates) instantly on the notifications page.
3. **Subscription and Unsubscription:**
   - You can subscribe or unsubscribe to channels directly from the UI.
   - The app will handle storing your subscriptions in Firestore for persistence.
4. **Channel Controls:**
   - You can add new channels via a `+` button on the channels page, enabling dynamic channel creation.
   - Only the admin of a channel (the one who created or added it) can remove the channel by dragging the channel tile from end to start, allowing for easy deletion of channels.
   - View all available channels in a list view, which displays all active channels you are subscribed to or can join.
5. **Real-Time Messaging:**
   - Each channel has a chat room created in the Firebase Realtime Database.
   - You have the option to send messages that are immediately visible to other subscribed users who joined the room.

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

3. **Set up Firebase specifically for (Android) and configure it according to the Firebase setup instructions for the Android platform.**
4. **Run the app:**
   ```
   flutter run
   ```

## 🛠️ CI/CD Workflow

**Automated Build and Deployment**

- GitHub Actions:
  - GitHub Actions is configured to automatically trigger builds when changes are pushed to the **main** branch of the repository.
  - The pipeline runs tests, builds the app, and uploads the build to Firebase App Distribution.
- Fastlane:
  - Fastlane handles signing and packaging of the app for Firebase App Distribution.
- Firebase App Distribution:
  - The latest app versions are automatically delivered to testers for seamless access and feedback.
