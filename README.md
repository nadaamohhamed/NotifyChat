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

## 📲 App Preview

<div align="center">
  <video src="https://github.com/user-attachments/assets/8532fc6d-4385-4e25-94e7-e9677d8e7c2e" />
</div>
