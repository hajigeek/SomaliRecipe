## YURECIPE
Welcome to YURECIPE, the recipe app that helps you discover new and delicious Somali meals!

## Features
Browse a variety of recipes from around the world
Search for recipes based on ingredients or cuisine type
Save your favorite recipes to a personal recipe book
Get recommendations for recipes based on your ratings and preferences

Sure, here's an updated version of the installation process for YURECIPE that includes Firebase Firestore as the backend:

## Installation

### 1. Install Flutter

To install Flutter, follow the official installation guide for your operating system: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).

### 2. Install Git

Git is a version control system that we will use to manage our project's codebase. To install Git, follow the official installation guide for your operating system: [https://git-scm.com/book/en/v2/Getting-Started-Installing-Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

### 3. Create a Firebase project

YURECIPE uses Firebase Firestore as its backend to store recipe data. To create a new Firebase project, follow these steps:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click "Add project" or select an existing project.
3. Enter a name for your project and select your country/region.
4. Click "Create project".
5. Once your project is created, click "Continue" to go to the project overview page.

### 4. Add Firestore to your Firebase project

Firestore is a NoSQL document database that we will use to store recipe data. To add Firestore to your Firebase project, follow these steps:

1. From the project overview page, click "Firestore Database" to start the setup process.
2. Select "Start in test mode" and click "Next".
3. Choose a region and click "Done".
4. Your Firestore database is now ready to use.

### 5. Clone the YURECIPE repository

To clone the YURECIPE repository, run the following command in your terminal:

```
git clone https://github.com/hajigeek/SomaliRecipe.git
```



### 6. Add your Firebase configuration files

To connect YURECIPE to your Firebase project, you need to add your Firebase configuration files to the app. To do this, follow these steps:

1. Go to the Firebase Console and select your project.
2. Click the gear icon in the top left corner and select "Project settings".
3. In the "Your apps" section, click the "Add app" button (the icon with the Android logo).
4. Enter a nickname for your app and click "Register app".
5. Follow the instructions to download the `google-services.json` file and add it to the `android/app/` directory in your YURECIPE project.
6. Repeat steps 3-5 for the iOS platform and add the downloaded `GoogleService-Info.plist` file to the `ios/Runner/` directory in your YURECIPE project.

### 7. Run YURECIPE

To run YURECIPE, connect your mobile device or start an emulator, and run the following command in your terminal:

```
flutter run
```

This will build and run the YURECIPE app on your device or emulator. You should now be able to see the YURECIPE home screen and start exploring recipes!

## Usage
Once you've installed YURECIPE, you can start browsing recipes right away. Use the search function to find recipes based on ingredients or cuisine type, or browse our selection of popular recipes.

When you find a recipe you like, you can save it to your personal recipe book for future reference. You can also rate recipes based on your experience, which will help us provide better recommendations in the future.

## Credits
YURECIPE was developed by Haji from ZJNU as a Bachelor's thesis project. We'd like to thank our advisors and colleagues for their support and guidance throughout the development process.



## Contact
If you have any questions or feedback about YURECIPE, please don't hesitate to get in touch. You can reach me at xiaopinhaji@gmail.com.