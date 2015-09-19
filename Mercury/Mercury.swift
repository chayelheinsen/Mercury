import UIKit
import AVFoundation

@objc public protocol MercuryDelegate {
    /**
    - parameter mercury: The Mercury instance
    - parameter notification: the notification being made
    - returns: the notification view, or nil to use MercuryDefaultNotificationView
    */
    optional func mercuryNotificationViewForNotification(mercury mercury: Mercury, notification: MercuryNotification) -> MercuryNotificationView?
    
    /**
    - parameter mercury: The Mercury instance
    - parameter explicit: is true if the user closed the bulletin with their finger, instead of relying on autoclose
    - parameter notification: the notification that was showing when Mercury was closed
    */
    optional func mercuryDidClose(mercury: Mercury, explicit: Bool, notification: MercuryNotification)
}

/**
Mercury is an in-app notification system that has a simple interface and can work with just about any sort of notification you can think of.
Examples include, but are not limited to:

- Success alerts
- Failure alerts
- Push Notifications
- Social Notifications (someone just commented on your post!)

Notes:

- Currently, this library only works well when you keep your app in one orientation.  Switching between portrait and landscape causes some gnarly
bugs and still needs to be handled.
*/

@objc public enum MercuryStyle : Int {
    case Dark, Light
}

public class Mercury: NSObject, MercuryBulletinViewDelegate {
    // MARK: - Public variables
    // MARK: - Singleton
    /**
    You typically will never need to use more than one instance of Mercury
    */
    public static let sharedInstance = Mercury()
    public var style: MercuryStyle = .Dark
    
    // MARK: -
    weak public var delegate: MercuryDelegate?
    
    // MARK: - private variables
    private var bulletinView: MercuryBulletinView?
    private var notifications = [MercuryNotification]()
    
    var audioPlayer: AVAudioPlayer?
    
    /**
    When Mercury is waiting, he will collect all of your notifications. Use wait() and go() to tell Mercury when to collect and when to deliver notifications
    */
    private var waiting = false {
        didSet {
            
            if !waiting {
                showNotifications()
            }
        }
    }
    
    // MARK: - Public methods
    
    /**
    Give Mercury one notification to post. If waiting == false, you'll see this notification right away
    
    - parameter notification: The notification you want Mercury to post
    */
    public func postNotification(notification: MercuryNotification) {
        postNotifications([notification])
    }
    
    /**
    Give Mercury an array of notifications to post. If waiting == false, you'll see these notifications right away
    
    - parameter notifications: The notifications you want Mercury to post
    */
    public func postNotifications(notifications: [MercuryNotification]) {
        self.notifications += notifications
        
        if let firstNotification = self.notifications.first {
            
            if firstNotification.soundPath != nil {
                prepareSound(path: firstNotification.soundPath!)
            }
        }
        
        showNotifications()
    }
    
    /**
    Tell Mercury to wait and you can queue up multiple notifications
    */
    public func wait() {
        waiting = true
    }
    
    /**
    Done queuing up those notifications? Tell Mercury to go!
    */
    public func go() {
        waiting = false
        showNotifications()
    }
    
    public func close() {
        bulletinView?.close(explicit: false)
    }
    
    public func containsNotification(notification: MercuryNotification) -> Bool {
        
        if let bulletinView = self.bulletinView {
            return bulletinView.notifications.contains(notification)
        }
        
        return false
    }
    
    // MARK: - private methods
    
    /**
    This method will attempt to show all currently queued up notifications.  If Mercury has waiting set to true,
    or if there are not notifications, this method will do nothing
    */
    private func showNotifications() {
        
        if waiting || notifications.count == 0 || bulletinView != nil {
            return
        }
        
        bulletinView = MercuryBulletinView()
        
        switch style {
        case .Dark:
            bulletinView!.blurEffectStyle = .Dark
        case .Light:
            bulletinView!.blurEffectStyle = .ExtraLight
        }
        
        bulletinView!.delegate = self
        bulletinView!.notifications = notifications
        bulletinView!.show()
        audioPlayer?.play()
        
        notifications.removeAll(keepCapacity: true)
    }
    
    // Initial setup
    func prepareSound(path path: String) {
        let sound = NSURL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: sound)
        audioPlayer!.prepareToPlay()
    }
    
    // MARK: - MercuryBulletinViewDelegate
    
    func bulletinViewDidClose(bulletinView: MercuryBulletinView, explicit: Bool) {
        delegate?.mercuryDidClose?(self, explicit: explicit, notification: bulletinView.currentNotification)
        self.bulletinView = nil
        showNotifications()
    }
    
    func bulletinViewNotificationViewForNotification(notification: MercuryNotification) -> MercuryNotificationView? {
        return delegate?.mercuryNotificationViewForNotification?(mercury: self, notification: notification)
    }
}
