# 🤝 Civic Campaign Management System — Volunteer Teams App 📱

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green?style=for-the-badge)
![State Management](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)

## 📌 Overview

This project is the dedicated mobile client for **Volunteer Teams & Charitable Associations** as part of the **Damascus Governorate Community Campaign Management Platform**.

The application empowers organization leads and managers to easily publish, govern, and maintain social impact campaigns, handle volunteer enrollment requests, set up funding parameters, and monitor campaign progression through a structured lifecycle.

---

## 💡 System Architecture Overview & Team Contribution

The overall ecosystem consists of two core mobile applications and web management portals:

1. **Volunteer Teams Application** *(Current Repository Focus)*: Designed specifically for volunteer groups and NGOs to manage their campaigns, volunteers, and funding options.
2. **Citizen Application** *(Co-developed / Contributed)*: Empowers community members to file urban complaints, propose initiative ideas, vote on campaigns, join volunteer drives, and donate.

---

## ⚡ Key Features (Volunteer Teams App)

- 🔐 **Authentication & Account Management**
  - Secure login and profile data updating for authorized volunteer team leads and associations.
- 📢 **Campaign Publishing & Management**
  - Publish new volunteer campaigns defining category, target location, required volunteer slots, and material/financial goals.
  - Track active, in-progress, and completed campaigns.
  - Update campaign status to **"Completed" (منجزة)** upon goal fulfillment.
- 👥 **Volunteer Applications Workflow**
  - Receive and inspect incoming volunteer join requests.
  - Approve or reject applications based on campaign requirements.
  - Track live counts of enrolled volunteers.
- 💳 **Donation & Payment Setup**
  - Configure payment channels and methods for financial campaign support.
  - Real-time updates on funding status upon reaching target donation amounts.

---

## 🌐 Ecosystem Integration (Citizen App Features Highlights)

*To highlight cross-team coordination, the app seamlessly integrates with features built on the Citizen application side:*
- **Complaint Submission & Tracking**: Citizen complaint filing with image uploads and AI-driven priority evaluation (BERT / Keyword scoring).
- **Initiative Proposal & Voting**: Community proposal submission, voting mechanics, and official municipality approval workflows.
- **Geo-Location Recommendations**: Content-based recommendation engines (using FAISS vector indexing) to suggest nearby campaigns to users.

---

## 🛠 Tech Stack

> Strict engineering constraints and stack requirements adhered to across the codebase:

| Concern | Package / Library |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **State Management** | `bloc` / `flutter_bloc` |
| **Networking** | `http` |
| **Local Storage** | `shared_preferences` |
| **Dependency Injection** | `get_it` (Registered via `lib/injection_container.dart` as `sl`) |
| **Functional Error Handling** | `dartz` (`Either<Failure, T>`) |
| **Typography & Fonts** | `google_fonts` |

---

## 📐 Project Architecture & Structure

The codebase strictly adopts **Clean Architecture** organized under a **Feature-First** directory layout:

```text
lib/
├── core/                       # Shared utilities, common widgets, errors, network info
│   ├── errors/                 # Failures and Exception classes
│   ├── usecases/               # Base UseCase interface
│   └── utils/                  # Color constants, theme, route helpers
├── features/
│   └── <feature_name>/         # (e.g., auth, campaign_management, volunteers)
│       ├── data/               # Data Layer: Data sources, API models
│       ├── domain/             # Domain Layer: Entities, Contracts, UseCases
│       └── presentation/       # Presentation Layer: BLoCs, Pages, UI Widgets
└── injection_container.dart    # Service Locator (GetIt initialization)
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable Version)
- Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/volunteer-teams-app.git
   cd volunteer-teams-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 👥 Authors & Acknowledgments

Developed as part of the **Graduation Project: Damascus Governorate Community Campaign Management System** at Damascus University, Faculty of Information Technology Engineering.
