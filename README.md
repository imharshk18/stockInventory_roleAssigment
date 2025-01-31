# Stock Inventory and Role Assignment

This is a desktop application designed for local apartment managers to manage stock inventory and assign roles efficiently. The app is built using Flutter, and the setup instructions are provided below.

## Prerequisites

- [Visual Studio 2019](https://visualstudio.microsoft.com/vs/)
- [Visual Studio Code 2019](https://code.visualstudio.com/)
- [Flutter](https://flutter.dev/docs/get-started/install)

## Setup Instructions

Follow these steps to set up and run the application:

### 1. Download and Install Required Software

1. Download and install [Visual Studio 2019](https://visualstudio.microsoft.com/vs/).
2. Download and install [Visual Studio Code 2019](https://code.visualstudio.com/).
3. Ensure Flutter is installed and configured on your system. Follow the installation guide [here](https://flutter.dev/docs/get-started/install).

### 2. Create a New Flutter Project

1. Open Visual Studio Code.
2. Create a new Flutter project by running the following command in the terminal:
```bash
flutter create stock_inventory_role_assignment
```

3. Navigate to the project directory:
```bash
cd stock_inventory_role_assignment
```

### 3. Replace Project Files
1. Replace the default `main.dart` file in the 'lib' directory with the `main.dart` file provided in the `Product` folder in Forms.
2. Add the `globals.dart` file from the `Product` folder to the `lib` directory.
3. Replace the default `pubspec.yaml` file in the root directory with the `pubspec.yaml` file provided in the `Product` folder in Forms.
### 4. Add Sample Data
1. In the `Documents` folder on your system, create a new folder named `locked`.
2. Copy all the `.TXT` files provided in the `Product` folder in Forms into the `locked` folder. These files contain the sample data required for the application.
### 5. Run the Application
1. Open the project in Visual Studio Code.
2. Run the application by pressing `F5` or by running the following command in the terminal:
```bash
flutter run
```
### Notes
- This application is currently in development using Flutter's desktop support, which is in alpha testing. Therefore, a standalone `.exe` file cannot be provided at this time.
- All data is saved and persisted even when running the application through Visual Studio.
- Once Flutter completes its testing for desktop support, an `.exe` file will be delivered to the client.

### License
This project is licensed under the MIT License