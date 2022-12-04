# Tagify 💬

<p align="center">
  <img src="https://user-images.githubusercontent.com/37345795/205490455-f2794cab-7197-428d-8a53-b9b829f29e29.png"/>
</p>

<p  align="center">
<a  href="https://flutter.dev"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487266-9604e883-3bd3-45a5-b172-f4617d911ee3.png"  alt="Flutter Logo"></a> <a>&nbsp;&nbsp;&nbsp;</a>
<a  href="https://dart.dev/"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487289-bd04321b-3f3a-431d-9c29-7e8e4a22d43f.png"  alt="Flutter Logo"></a> <a>&nbsp;&nbsp;&nbsp;</a>
<a  href="https://firebase.google.com/"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487145-a7ad5e40-71e1-46d5-a828-ef82ee168885.png"  alt="Appwrite Logo"></a>
</p>

Tagify enables the user to create and manage groups with ease. It lets the user find the right set of people and communicate relevant information with them.
- After creating an account, users can assign themselves tags, for e.g. appdev, rajasthan, burger, etc.
- Say we want to address everyone who is in Rajasthan and likes Burger or is in Assam and likes Fish, then we can simply create a group with this logic: `(rajasthan AND burger) OR (assam AND fish)` which is equivalent to `(rajasthan & burger) | (assam & fish)` and a group with those people will automatically be made!
- To enter the logic for a group, we are using a bunch of buckets, there can be any number of buckets, and each bucket can contain any number of tags. The tags inside a bucket are `AND`ed, and then the buckets are `OR`ed together.
- Here is a [presentation](https://drive.google.com/file/d/1HFzEsUJGfNh_XIjrI4xhybGDt-T39Ijp/view) explaining the working of the app with screenshots.
- Here is a [video](https://drive.google.com/file/d/1ia9vZDcWBGl6M7pMer5KGyFjOuaQ4fOu/view?usp=share_link) demonstrating the app.

## Setting up the project in your local environment💻

<p align="center">
    <img src="https://user-images.githubusercontent.com/74055102/141175363-4c00515a-2658-475e-b510-394110d43ec5.png" height=400/>
</p>

1. [Fork](https://github.com/letsintegreat/Tagify/fork) this repository.
2. Clone the **forked** repository:
```
git clone https://github.com/<your username>/Tagify
cd Tagify
```
3. Add a remote to the upstream repository:
```
# Typing the command below should show you only 1 remote named origin with the URL of your forked repository
git remote -v
# Adding a remote for the upstream repository
git remote add upstream https://github.com/letsintegreat/Tagify
```
4. Get [Flutter](https://docs.flutter.dev/get-started/install) and [Firebase CLI](https://firebase.google.com/docs/cli?authuser=0&hl=en#install_the_firebase_cli) if you don't already have them.
5. Run `flutter pub get` to get the dependencies.
6. If you have not yet logged into `Firebase CLI` and activate `FlutterFire CLI` globally:
```
firebase login
dart pub global activate flutterfire_cli
```
7. Create a new project on [Firebase Console](https://console.firebase.google.com/), activate Google Sign In, and activate Firebase Firestore in **test mode**.
8. Configure your flutter app with the newly created project on firebase console:
```
flutterfire configure
```

This automatically registers your per-platform apps with Firebase and adds a `lib/firebase_options.dart` configuration file to your Flutter project.

9. Finally, run the app:
```
flutter run
```

## Contributing to the project 🛠

<p align="center">
    <img src="https://user-images.githubusercontent.com/74055102/141175911-fbefae23-d381-44b3-bcfb-d369cfb66659.png" height=400/>
</p>

Now that you have the project set up in your local environment, follow the steps below to contribute!

1. Take up an already existing issue or create a new (but a valid) one via [issue tracker](https://github.com/letsintegreat/Tagify/issues).
2. Pull the latest code in.
```
# Make sure you are on the main branch
git pull upstream main
```
3. Create a new branch.
```
# Replace xx with the issue number you are working on and give your branch a good name
git checkout -b issue-xx-a-good-name
```
4. Make your changes!
5. Once done with a particular feature, bug fix, or a documentation part, add your changes to the staging area. *Please don't add `lib/firebase_options.dart` file to your commit, it is meant to be kept as a secret.*
```
git add .
```
6. Review and commit your changes.
```
# The message should be in present tense, for ex - "Added feature x" is not ideal but "Add feature X" is
git commit -m "a meaningful message"
```
7. Push your changes!
```
git push --set-upstream origin <your-branch-name>
```
8. Create a pull request from GitHub and wait for the review!

**Contributions of any kind welcome!**

# Authors

This project was developed under a hackathon by

- [Harshit Seksaria](https://github.com/letsintegreat/)
- [Priyanshu Srivastava](https://github.com/GeekyPS)
- [Nishchay Nilabh](https://github.com/Rockhopper130)

<p align="center">
  <img src="https://user-images.githubusercontent.com/37345795/205490374-3b0bcefd-c48c-46f3-82ea-4db8c7afa98e.png"/>
</p>
