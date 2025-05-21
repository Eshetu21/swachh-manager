# KabadManager – Admin App for Swachh Kabadi

- KabadManager is the admin-side Flutter application for the Swachh Kabadi platform — an intelligent, modern waste management solution that connects users with local kabadiwalas for efficient and sustainable recycling. While the user app is available on the Google Play Store, this admin app is used by authorized personnel to manage operations, monitor activity, and analyze data in real-time.

## Project Structure & Tech Stack

- This project is built using Flutter with the Clean Architecture pattern and integrates the following technologies:
State Management: BLoC (Business Logic Component)
- Backend Services:
 - Firebase – for authentication, notifications, and real-time database
 - Supabase – for additional data handling, storage, and role-based access
 - Architecture: Clean Architecture for scalable and testable code

## Features
- 📊 Dashboard Overview – Monitor waste pickup requests, active users, registered kabadiwalas
- 👤 User & Kabadiwala Management – Approve, reject, or monitor users and vendors
- 🧾 Request Tracking – View and update status of pickup requests
- 📍 Location Insights – Access location data via Firebase GeoPoint for mapping pickups
- 🔔 Notifications – Push alerts via Firebase Cloud Messaging (FCM)
- 🧠 Real-time Data – Sync data live with Firebase/Supabase
