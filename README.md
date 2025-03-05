# Cape Town Festival 2025

## Overview
A web application built with Flutter and Firebase for managing the Cape Town Festival 2025. The platform enables visitor registration, event RSVPs, and feedback collection while providing administrators with comprehensive analysis and management tools.

## Features
### User Features
- **View RSVP Dialog**: Users can view a list of events they have RSVP'd to, including status and creation date.
- **Make RSVP Dialog**: Users can select an event and confirm their attendance, updating their RSVP status in the database.
- **Real-time Data**: The application fetches event data and user RSVPs in real-time using Firebase Firestore.
- **Responsive Design**: The application is designed to work on various screen sizes.
- **User Authentication**: Users can sign in using their Google account and access personalized features.
- **User Registration**: Users can register for the platform using their email address and password.
- **Event Browsing**: Users can browse festival events and view detailed information about each event.
- **Feedback System**: Users can provide feedback on events, including ratings and comments.
- **Event Ratings**: Users can rate events using a 5-star system.
- **Event Comments**: Users can leave comments on events, which are displayed on the event details page.

### Admin Features
- **Admin Dashboard**: Administrators can view analytics dashboards and manage events using the Firebase console.
- **Event Management**: Administrators can create and edit event details, including name, description, date, time, and location.
- **Analytics Dashboards**: Administrators can access dashboards to view visitor demographics, event attendance metrics, and individual event performance.
- **Visitor Demographics**: Administrators can view festival-wide visitor demographics.
- **Event Attendance**: Administrators can track attendance for specific events and view metrics.
- **Feedback Analysis**: Administrators can analyze attendee feedback, including ratings and comments, to gain insights into event performance.
- 
### For Visitors
- User registration and authentication
- Browse festival events and information  
- RSVP for events
- Provide event ratings (5-star system)
- Leave event feedback and comments
- View RSVP status and event history


### For Administrators
- Event management (create, edit, achieve)
- View festival attendee lists
- Track event-specific attendance
- Access analytics dashboards:
  - Festival-wide visitor demographics
  - Event attendance metrics
  - Individual event performance
  - Attendee feedback analysis
  - Event ratings and comments

## Technical Stack

### Frontend
- **Flutter**: The framework used for building the mobile application.
- **Dart programming language**

### Backend & Services
- **Firebase Suite:**
  - Firestore Database
  - Firestore Realtime
  - Authentication
  - Hosting
  - Riverpod: A state management solution for managing the app's state.
  - Intl: A package for internationalization and formatting dates.
  - Cloudinary: A cloud-based image and video management service.
  

### Development
- Version Control: GitHub

## Getting Started
To run this project locally, follow these steps:

### Prerequisites
- Flutter SDK
- Firebase CLI
- Git

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/[mulalorasivhaga]/cape_town_festival.git
cd cape_town_festival
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up Firebase**:
  - Create a Firebase project and configure it for your Flutter app.
  - Add the necessary Firebase configuration files to your project.

4. Run the application
```bash
flutter run -d chrome
```

## Hosting
The application is hosted at [CT Festival](https://ct-festival.web.app).

## Project Structure
```
lib/
├── models/         # Data models
├── view /          # UI screens
├── controller/     # Firebase services
├── widgets/        # Reusable widgets
└── main.dart       # Entry point
```

## Event Categories
1. Music & Performance
2. Workshops & Talks
3. Arts & Culture
4. Food & Drinks
5. Technology & Innovation

## Acknowledgments

- This project in an assignment for the Department of Information Systems (INF4027W) at the University of Cape Town.
- Thanks to the Flutter and Firebase communities for their resources and support.

## Contact
For support or queries, please contact:
[mulalorasivhaga@icloud.com] or alternatively [RSVMUL002@myuct.ac.za]

---

**Note:** This is a work in progress. Features and implementation details may change during development.
