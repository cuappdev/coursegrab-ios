# CourseGrab - Get in to the Courses That You Want

<p align="center"><img src=https://raw.githubusercontent.com/cuappdev/coursegrab-ios/master/    CourseGrab/Supporting/Assets.xcassets/Logos/coursegrab-readme.imageset/coursegrab-readme.png width=210 /></p>

CourseGrab is one of the latest applications by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Currently catering to Cornell University’s class roster, CourseGrab enhances the student enrollment experience by notifying students of available spots in courses they wish to enroll in. 

## Development

### 1. Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, clone the project, and run `pod install` in the project directory.

### 2. Configuration
1. We use [Firebase](https://firebase.google.com) for our user analytics. You will have to retrieve a `GoogleService-Info.plist` from Firebase and then place it inside the `CourseGrab/Supporting/` directory.

    For AppDev members, this file is also pinned in the `#coursegrab-ios` channel. 

    If you aren't an AppDev member, you can plug in your own `GoogleService-Info.plist` by generating one by following these [instructions](https://support.google.com/firebase/answer/7015592?hl=en). You will need to create a project within Firebase to this.

2. To build the project  you need a `Supporting/Keys.plist` file in the project.

```xml
?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>server-host</key>
    <string>INSERT_API_KEY</string>
    <key>google-client-id</key>
    <string>INSERT_GOOGLE_CLIENT_ID</string>
    <key>announcements-scheme</key>
    <string>INSERT_SCHEMEs</string>
    <key>announcements-host</key>
    <string>INSERT_HOST</string>
    <key>announcements-common-path</key>
    <string>INSERT_COMMON_PATH</string>
    <key>announcements-path</key>
    <string>INSERT_PATH</string>
</dict>

```
For AppDev members, the `Supporting/Keys.plist` file is pinned in the `#coursegrab-ios` channel. 

Finally, open `CourseGrab.xcworkspace` and enjoy CourseGrab!
