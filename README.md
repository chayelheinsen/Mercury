
![Mercury](http://i.imgur.com/E6Y23nG.jpg)

**Mercury is a simple and robust in-app notification system for iOS written in Swift.**  It supports posting Notifications with styled or unstyled text, an icon, sound, color, and an action closure.  You can easily build your own notification template and add any number of attributes and features to a MercuryNotification.

Mercury shows all queued up notifications at once, with an easy way to swipe through them (and will animate through them automatically if you don't touch any notifications for 3 seconds)

##Installation
###Cocoapods Installation
Mercury is available on CocoaPods. Just add the following to your project Podfile:

```
pod 'Mercury'
```

###Non-Cocoapods Installation
You can drop Mercury files directly into your project, or drag the Mercury project into your workspace.

###Usage
Import in **Swift**
```swift
import Mercury
```
or **Objective-C**
```objective-c
#import <Mercury/Mercury.h>
```

##Getting Started
###Components
- **Mercury** (public)

  You will use Mercury.sharedInstance to post Notifications.  You can tell Mercury when to *wait()* and collect notifications and when to *go()* and post notifications as soon as Mercury has any.
  
- **Notification** (public, extendable)

  A Notification is a model that has attributes like text, image, sound, and color. You can extend or subclass Notifications and use them in custom NotificationViews
  
- **NotificationView** (public, extendable)

  A NotificationView is a UIView that displays Notifications.  Mercury lets you subclass and display your own NotificationViews that match your app's style.
  
- **BulletinView** (protected)

  The BulletinView is a UIView that shows 1 or many NotificationViews. Mercury does not let you subclass and use your own BulletinView.

###How to use 
*In two easy steps!*

1. Make one or many Notifications
2. ```mercury.postNotifications([...])```

###Sample code

**Creating Notifications**
```swift
// uses Mercury singleton
let mercury = Mercury.sharedInstance

// 'Upload Complete!' success Notification
let successNotification = MercuryNotification()
successNotification.text = "Upload complete!"
successNotification.image = UIImage(named: "success_icon")
successNotification.color = .greenColor()
successNotification.userInfo = ["key" : "Can use dictionaries"]

// Call self.foo() when the NotificationView for this Notification is tapped
successNotification.action = { notification in
    self.foo() 
}

// 'Upload failed :(' failure Notification
let failureNotification = MercuryNotification()
failureNotification.text = "Upload failed :("
failureNotification.image = UIImage(named: "error_icon")
failureNotification.color = .redColor()
```

### Posting Notifications

#####If you post Notifications while a Bulletin is already showing, it will show all of the new Notifications after the current Bulletin closes
```swift
mercury.postNotification(successNotification)
mercury.postNotification(failureNotification)
```

#####You can tell Mercury to wait and go, to collect a bunch of notifications before showing them 
```swift
// we could do use wait(), which tells Mercury to collect notifications without showing them yet
mercury.wait()

// post both the success and failure notification 
mercury.postNotification(successNotification)
mercury.postNotification(failureNotification)

// this tells Mercury to post all of the notifications in the queue
mercury.go()
```

#####Or, you can post an array of notifications that Mercury will show immediately
```swift
// we could have also done the above code by simply using postNotifications
mercury.postNotifications([successNotification, failureNotification])
```

###Subclassing MercuryNotificationView
Subclassing MercuryNotificationView is very easy, and gives you the freedom to make the view as simple or complicated as you want.
```swift
class CustomNotificationView: MercuryNotificationView {
  override var notification: MercuryNotification? {
    didSet {
      // update your view
    }
  }
}
```

Next you need is to implement the MercuryDelegate like this:
```swift
mercury.delegate = self
```

And the delegate method:
```swift
func mercuryNotificationViewForNotification(#mercury: Mercury, notification: MercuryNotification) -> MercuryNotificationView? {
        if notification.tag == kCustomNotificationTag {
            return CustomNotificationView()
        }
        return nil
    }
```
You can tag MercuryNotifications to help with determining which custom MercuryNotificationView to use, or just always return your custom notification view. This is up to you!
