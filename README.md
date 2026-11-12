# 🎓 Student Hub - Flutter Academic Portal

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A modern, clean, and beginner-friendly Flutter application built for university and college students. **Student Hub** brings attendance tracking, weekly timetables, homework & assignments, study notes, semester results, and student profiles into a unified, responsive blue-and-white interface.

---

## 📱 Application Screenshots

Here is the complete visual tour of all the application screens:

| 1. Home Dashboard | 2. Attendance Tracker |
|:---:|:---:|
| ![Home Dashboard](assets/screenshots/home_dashboard.png) | ![Attendance Tracker](assets/screenshots/attendance_screen.png) |
| *Hero card, quick actions, schedule preview & campus alerts* | *Circular progress gauge, statistics & subject attendance* |

| 3. Weekly Timetable | 4. Assignments & Tasks |
|:---:|:---:|
| ![Weekly Timetable](assets/screenshots/timetable_screen.png) | ![Assignments & Tasks](assets/screenshots/assignments_screen.png) |
| *Day selector tabs, slot timings, room numbers & faculty* | *Pending vs Completed filters, due dates & status toggle* |

| 5. Study Notes & Materials | 6. Examination Results |
|:---:|:---:|
| ![Study Materials](assets/screenshots/study_materials_screen.png) | ![Examination Results](assets/screenshots/results_screen.png) |
| *PDF notes by subject, search, reader modal & download* | *Semester selector, SGPA, percentage & subject marks* |

| 7. Student Profile | 8. Authentication & Login |
|:---:|:---:|
| ![Student Profile](assets/screenshots/profile_screen.png) | ![Login Screen](assets/screenshots/login_screen.png) |
| *Personal details, department info, edit profile & logout* | *Student sign-in, demo autofill & new registration* |

---

## ✨ Features & Functionality

### 1. 🔐 Authentication & Session
- **Student Sign In**: Login with Student ID/Email and password.
- **Quick Fill Demo**: Instant one-tap button to test without manual typing.
- **New Student Registration**: Form for new students to register with department and semester.
- **Persistent Storage**: Remembers logged-in student status via `shared_preferences`.
- **Sign Out**: Confirmation dialog and secure session clearance.

### 2. 🏠 Home Dashboard
- **Personalized Welcome**: Displays student greeting and active semester.
- **Student Identity Card**: Gradient blue banner displaying Roll Number, Department, Semester, and quick metrics (Attendance %, CGPA, Pending Tasks).
- **Quick Access Grid**: 6 direct access cards to all features with notification badges.
- **Today's Class Preview**: Live preview of today's schedule slots with time and venue.
- **Campus Notice Board**: Real-time university exam and hackathon updates.

### 3. 📊 Attendance Tracker
- **Radial Gauge Indicator**: Visual overall attendance percentage calculation.
- **Eligibility Indicator**: Color-coded safety status (Green for $\ge 75\%$, Red alert for $< 75\%$).
- **Overall Statistics**: Total Classes conducted, Attended, and Absent.
- **Subject-wise Breakdown**: Progress bars, attended vs missed counts, faculty names, and interactive `+ Present` / `+ Absent` live simulation buttons.

### 4. 📅 Weekly Timetable
- **Day Selector Tabs**: Switch between Monday, Tuesday, Wednesday, Thursday, and Friday.
- **Time Slot Badges**: Clearly shows start and end times for each period.
- **Classroom / Venue**: Hall number, laboratory block, and assigned faculty name.
- **Class Type**: Color-coded badges for *Lecture*, *Lab*, and *Tutorial*.

### 5. 📝 Assignments & Homework
- **Status Filter Chips**: Switch between *All*, *Pending*, and *Completed* tasks.
- **Due Date Tracker**: Highlights upcoming submission deadlines.
- **Interactive Checkbox**: Toggle completed status with persistent storage.
- **Assignment Details Modal**: Full problem description, instructions, and simulated file upload submission.
- **Add Custom Task**: Modal dialog to add personal academic deadlines.

### 6. 📚 Study Materials & Notes
- **Subject Search**: Real-time filtering across topics and course titles.
- **Category Chips**: Filter by subject (Algorithms, DBMS, Networks, AI, DevOps).
- **Document Reader Sheet**: Modal preview showing chapter highlights and key revision points.
- **Download Simulation**: One-tap download with visual feedback.

### 7. 🏆 Examination Results & GPA
- **Semester Selector**: Dropdown to view results across Semester 5, Semester 4, and Semester 3.
- **Performance Banner**: Automatically calculates **SGPA** (e.g., `8.82 / 10.0`), **Percentage** (e.g., `87.5%`), and **Total Marks** (e.g., `525 / 600`).
- **Subject Marks Breakdown**: Internal marks (out of 30), external marks (out of 70), total marks, letter grades (O, A+, A), grade points, and credits.
- **Grade Sheet Export**: Option to download grade memo.

### 8. 👤 Student Profile
- **Avatar & Student ID**: Displays student photo avatar, roll number, and department.
- **Academic Details**: University program, current semester, academic year, and student portal ID.
- **Contact Details**: Official email address, phone number, and campus hostel room.
- **Edit Profile**: Modal bottom sheet to update student details in real time with persistent local storage.

---

## 🎨 Design & Color Palette

The app adopts a clean, modern **Material 3** blue-and-white theme designed for readability and focus:

| Color Role | Hex Code | Description |
|:---|:---|:---|
| **Primary Blue** | `#1E88E5` | Modern Royal Blue for buttons, active tabs, and primary actions |
| **Dark Navy** | `#0D47A1` | Deep Navy Blue for hero gradients and primary text |
| **Light Ice Blue** | `#E3F2FD` | Soft accent background for badges and icon containers |
| **Accent Sky Blue** | `#0284C7` | Secondary vibrant blue for lab badges and highlights |
| **Scaffold Background** | `#F8FAFC` | Clean off-white surface reducing eye strain |
| **Card Surface** | `#FFFFFF` | Crisp white cards with subtle border `#E2E8F0` |
| **Success Emerald** | `#10B981` | Green badge for passed exams, safe attendance, completed tasks |
| **Danger Rose** | `#EF4444` | Red warning for attendance shortage and overdue dates |

---

## 📂 Project Architecture

```
stdhub/
├── assets/
│   └── screenshots/              # Screenshot images used in README
│       ├── home_dashboard.png
│       ├── attendance_screen.png
│       ├── timetable_screen.png
│       ├── assignments_screen.png
│       ├── study_materials_screen.png
│       ├── results_screen.png
│       ├── profile_screen.png
│       └── login_screen.png
├── lib/
│   ├── main.dart                 # Application entry point & theme initialization
│   ├── models/                   # Clean data models
│   │   ├── student.dart          # Student profile model (with JSON serialization)
│   │   ├── attendance.dart       # Subject attendance & metrics
│   │   ├── timetable.dart        # Day slot, room, instructor model
│   │   ├── assignment.dart       # Assignment item model
│   │   ├── study_material.dart   # PDF / study notes model
│   │   └── result.dart           # Semester results & subject marks
│   ├── services/                 # Services & storage
│   │   ├── demo_data.dart        # Comprehensive mock university data
│   │   └── storage_service.dart  # SharedPreferences persistence for profile, tasks & attendance
│   ├── theme/
│   │   └── app_theme.dart        # Custom blue-and-white Material 3 theme
│   ├── widgets/                  # Reusable components
│   │   ├── custom_card.dart      # Rounded card with subtle border & shadow
│   │   ├── stat_card.dart        # Metric card with icon and value
│   │   ├── section_header.dart   # Clean section heading with action button
│   │   └── status_badge.dart     # Safe / Warning / Danger / Info pills
│   └── screens/
│       ├── splash_screen.dart    # Splash screen with auth session check
│       ├── main_navigation_screen.dart # 5-tab bottom navigation scaffold
│       ├── auth/
│       │   ├── login_screen.dart       # Sign-in & demo credentials fill
│       │   └── register_screen.dart    # Registration form
│       ├── home/
│       │   └── home_screen.dart        # Dashboard, quick actions & notices
│       ├── attendance/
│       │   └── attendance_screen.dart  # Radial gauge & subject breakdown
│       ├── timetable/
│       │   └── timetable_screen.dart   # Weekly day tabs & period slots
│       ├── assignments/
│       │   └── assignments_screen.dart # Homework filters & status toggles
│       ├── study_materials/
│       │   └── study_materials_screen.dart # PDF notes, search & download
│       ├── results/
│       │   └── results_screen.dart     # Semester marks & SGPA calculator
│       └── profile/
│           └── profile_screen.dart     # Student details & edit dialog
├── test/
│   └── widget_test.dart          # Automated widget tests (100% passing)
├── pubspec.yaml                  # Flutter package dependencies & assets
└── README.md                     # Documentation with screenshots
```

---

## 🚀 How to Run the Project

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.19 or later).
2. Install Android Studio, Xcode, or have Chrome/Edge/Windows desktop enabled.
3. Verify your Flutter installation:
   ```bash
   flutter doctor
   ```

### Step-by-Step Setup

1. **Clone or Navigate to the Project**:
   ```bash
   cd stdhub
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Code Health**:
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

4. **Run Unit & Smoke Tests**:
   ```bash
   flutter test
   ```
   *(Expected output: `All tests passed!`)*

5. **Launch the Application**:
   - To run on an Android / iOS emulator or connected device:
     ```bash
     flutter run
     ```
   - To run on Chrome / Web:
     ```bash
     flutter run -d chrome
     ```
   - To run on Windows Desktop:
     ```bash
     flutter run -d windows
     ```

---

## 🔑 Demo Account Credentials

You can log in directly using the **"Quick Fill Demo Account"** button on the Login Screen, or type manually:

- **Student ID / Email**: `alex.johnson@studenthub.edu` (or `21CS1045`)
- **Password**: `student123`

You can also click **"Register Here"** to create a custom profile with your own name, roll number, department, and semester.

---

## 🧪 Testing Summary

- `flutter analyze`: **0 issues found** (Clean code, zero warnings, zero deprecations).
- `flutter test`: **100% passed** (Covers widget tree initialization, storage mocks, and splash transitions).

---

## 📄 License
This project is open-source under the [MIT License](LICENSE). Feel free to use it for university projects, personal study, or student organization apps!
