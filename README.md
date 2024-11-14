# Integrating the Mooncake Module into a Flutter Host App

This document outlines the steps required to integrate the `Mooncake` module into a Flutter host app and enable communication between them.


---

## Setup Guide

### 1. Add the Mooncake Module as a Dependency
In the host app’s `pubspec.yaml`:

1. Add the `Mooncake` module as a dependency using either:
   - **Local path**: Point to the location where the Mooncake module is located.
   - **Git repository**: If hosted on a version control system, provide the URL and branch.

2. Run `flutter pub get` to install the dependencies.

---

### 2. Import the Mooncake Module
In the host app’s Dart files, import the `Mooncake` module to make its components accessible.

---

### 3. Launch the Mooncake Module from the Host App
Use the **Flutter Navigator** to push the Mooncake module onto the navigation stack. This allows the user to interact with the module and return data back to the host app.

---

### 4. Handle Data Returned from the Mooncake Module
When the user completes an action in the Mooncake module, the module will send data back to the host app. Ensure the host app:
- Receives the data via **`Navigator.pop()`**.
- Updates the user interface to reflect the returned data.

---

### 5. Run the Host App
- Use `flutter run` to build and launch the host app.
- Trigger the Mooncake module from the host app to verify:
  1. The module opens as expected.
  2. The user can input data in the module.
  3. Data returns correctly to the host app upon closing the module.

---

## Troubleshooting
- **Dependency issues**: Ensure paths or Git URLs are correct in `pubspec.yaml`.
- **Navigation issues**: Confirm that the host app properly pushes the Mooncake module using `Navigator`.
- **Null return values**: Handle cases where no data is returned from the module (e.g., user cancels input).

---

## Summary
This setup allows the host app to trigger the Mooncake module and retrieve user input or other data seamlessly, ensuring smooth communication between the two.# mooncake_plugin
