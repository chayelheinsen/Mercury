/*

import UIKit
import Mercury

class ViewController: UIViewController, MercuryDelegate {
  let mercury = Mercury.sharedInstance

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .whiteColor()
    mercury.delegate = self
    
    let notification1 = MercuryNotification()
    notification1.text = "Upload complete! Tap here to show an alert!"
    notification1.image = UIImage(named: "logo")
    notification1.color = .greenColor()
    notification1.userInfo = [
        "key" : "This is from the dictionary!",
    ]
    notification1.action = { notification in
        
        if let title =  notification1.userInfo?["key"] as? String {
            let alert = UIAlertView(title: title, message: "Mercury notifications are actionable", delegate: nil, cancelButtonTitle: "Close")
            alert.show()
        } else {
            let alert = UIAlertView(title: "Success", message: "Mercury notifications are actionable", delegate: nil, cancelButtonTitle: "Close")
            alert.show()
        }
        
    }
    notification1.soundPath = NSBundle.mainBundle().pathForResource("notify", ofType: "wav")
    
    let notification2 = MercuryNotification()
    
    let attributedText = NSMutableAttributedString(string: "Alan ")
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, attributedText.length))
    attributedText.addAttribute(NSFontAttributeName , value: UIFont(name: "Helvetica-Bold", size: 14)!, range: NSMakeRange(0, attributedText.length))
    attributedText.appendAttributedString(NSAttributedString(string: "commented on your "))
    
    let imageText = NSMutableAttributedString(string: "image")
    imageText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(0, imageText.length))
    imageText.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica-Bold", size: 15)!, range: NSMakeRange(0, imageText.length))
    
    attributedText.appendAttributedString(imageText)
    
    notification2.attributedText = attributedText
    notification2.image = UIImage(named: "logo")
    notification2.color = .redColor()
    
    let notification3 = MercuryNotification()
    notification3.text = "ATTN: There is a major update to your app!  Please go to the app store now and download it! Also, this message is purposely really long."
    notification3.image = UIImage(named: "logo")
    notification3.color = .yellowColor()

    
    var delayTime = dispatch_time(DISPATCH_TIME_NOW,
      Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.mercury.postNotifications([notification1, notification2, notification3, notification1, notification2, notification3])
    }
    
    delayTime = dispatch_time(DISPATCH_TIME_NOW,
      Int64(4 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.mercury.postNotifications([notification1, notification2, notification3, notification1, notification2, notification3])
    }
  }
  
  // MARK: - MercuryDelegate
  func mercuryNotificationViewForNotification(mercury mercury: Mercury, notification: MercuryNotification) -> MercuryNotificationView? {
    // You can create your own MercuryNotificationView subclass and return it here :D (or return nil for the default notification view)
    return nil
  }
}
*/
