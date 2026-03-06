# <img width="30" height="30" alt="Biba_B_logo_trimmed" src="https://github.com/user-attachments/assets/90883e7e-11e4-4e9b-b3d9-045eed6143a1" /> Biba (Kto na bibe)
A personal side project: a mobile application designed to simplify party organization and preserve the highlights of your past events.

## 🛠 Tech Stack & Architecture
This project is built with modern mobile development standards in mind:
* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **Backend as a Service:** [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore)
* **State Management:** [`flutter_bloc`](https://pub.dev/packages/flutter_bloc)
* **Architecture:** **MVVM** (Model-View-ViewModel) approach tailored for Bloc to ensure separation of concerns such as backend, state management and UI.

## ✨ Current Features
* **User Authentication:** Login and registration using Email & Password or Google Sign-In.
  <p align="center">
  <img width="230" height="474" alt="login_screen" src="https://github.com/user-attachments/assets/3a7a4fb6-acf1-4a17-b667-b2236c4d9812" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="biba_sign_up_screen" src="https://github.com/user-attachments/assets/a6b8bcda-38a5-4cdc-bda6-89853a6debf4" />
</p>

* **Profile Customization:** Custom avatar color and username.
  <p align="center">
  <img width="230" height="474" alt="profile_screen" src="https://github.com/user-attachments/assets/13ac4b0e-e7a2-4e31-a951-bd5dd68c102b" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="color_selection" src="https://github.com/user-attachments/assets/606de7ca-da5e-40b6-846e-3b81dfb2db82" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="name_selection" src="https://github.com/user-attachments/assets/a14d6d83-9db5-42f5-9554-0a1cd3c31630" />
</p>

* **Friend Management:** Add new friends who you can later invite to parties.
  <p align="center">
  <img width="230" height="474" alt="friends_screen" src="https://github.com/user-attachments/assets/8e1b7e0c-d4b5-4fa5-a8d2-ed00bee04108" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="adding_friend_screen" src="https://github.com/user-attachments/assets/c4ddb023-3b57-4008-baf5-ab45c84adf1b" />
</p>

* **Event Creation:** Organize parties(bibas) by setting up key details such as date, time, and location.
  <p align="center">
  <img width="230" height="474" alt="biba_creation_screen" src="https://github.com/user-attachments/assets/286b7207-65b8-4054-9e16-9606172f89a7" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="biba_screen" src="https://github.com/user-attachments/assets/c54db920-d501-4c70-ac50-fd7e69611cf7" />
  &nbsp; &nbsp;
  <img width="230" height="474" alt="adding_guest" src="https://github.com/user-attachments/assets/63b1fdf7-bdd0-42d0-b972-e02eda397c80" />
</p>  

* **Event History:** Browse through an archive of your past parties and keep track of previous gatherings.
<p align="center">
  <img width="230" height="474" alt="biba_history_screen" src="https://github.com/user-attachments/assets/976b8ff0-5780-4274-b1cb-c75ea34df390" />
</p>

## 🗺 Potential directions of development
* **More customization**: Allow users to upload custom avatar pictures.
* **Bring a List**: A feature where the host can create a checklist of needed items (drinks, snacks, etc.), and guests can claim and declare what they will bring.
* **Event Photo Gallery**: A shared space within an event where all attendees can upload and view photos from the party.
* **Host Announcements**: A dedicated dashboard or notification center where the host can post important updates or messages for all guests.
