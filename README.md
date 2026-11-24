<div align="center">

# DarDeal

**Find your home in Egypt. Buy, rent, and list properties, all in one app.**

A real estate mobile app built with Flutter, created as a graduation project.

</div>

---

## Overview

DarDeal is a real estate marketplace app for Fayoum, Egypt. Seekers can browse and search property listings, chat with owners, make offers, and pay securely through an escrow-style handover. Owners can list their properties, manage rentals, and track their contracts and wallet. An AI assistant, DarBot, is built in to help users along the way.

## Features

- **Browse and search listings** - explore properties for sale or rent with filters and location-based search on an interactive map
- **Offers and negotiations** - send offers to owners and track offer requests
- **Secure payments** - pay through Paymob with an escrow-style flow: the payment is held and released only at handover
- **DarBot AI assistant** - an in-app AI chatbot that answers questions and helps users navigate the app, with voice input support
- **Add-property wizard** - owners list a property step by step, with photos, video, map location, and details
- **Real-time chat** - seeker-owner messaging built into the app
- **Favorites** - save listings to revisit later
- **Contracts and rentals** - track active rentals, contracts, and rental management
- **Wallet** - owners track their earnings from completed deals
- **Verification and documentation** - identity and document verification flow
- **Localization** - Arabic and English support

## Tech Stack

- **Flutter** (Dart 3) - cross-platform mobile app
- **flutter_bloc** - state management
- **Dio** - networking
- **get_it** - dependency injection
- **Paymob** - payment processing
- **flutter_map + geolocator** - maps and location
- **shared_preferences** - local storage
- **Google Sign-In** - social authentication
- **speech_to_text** - voice input for DarBot
- **intl / flutter_localizations** - localization

## Screenshots and Demo

<!-- Screenshots and demo coming soon -->

**Demo video:** coming soon.

## Getting Started

### Prerequisites

- Flutter SDK (Dart 3.10 or later)
- Android Studio or VS Code with the Flutter extension
- An emulator or a physical device

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/selenasameh31-ux/DARDEAL.git
   cd DARDEAL
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/            # Shared utilities, styles, widgets, and networking
├── features/        # App features (auth, offers, payments, chatbot, and more)
├── l10n/            # Localization
└── main.dart        # App entry point
```

## My Contributions

**Selena Sameh**

- Designed the DarDeal logo and app branding
- Built the complete authentication flow: sign up, sign in, forgot password, and Google sign-in
- Built the profile section end to end, including every page inside it
- Built the settings screens
- Built the seeker-owner chat, the in-app messaging between property seekers and owners

---

<div align="center">
Graduation project - built with Flutter
</div>
