
import Foundation
import MessageUI

extension UIViewController : MFMailComposeViewControllerDelegate {
    
 /*   func methodForSendEmail(_ stringToRecipients:String, stringSubject:String, stringEmailBody:String)  {
        let mailComposeViewController = self.configuredMailComposeViewController(stringToRecipients, stringSubject: stringSubject, stringEmailBody: stringEmailBody)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController(_ stringToRecipients:String, stringSubject:String, stringEmailBody:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([stringToRecipients])
        mailComposerVC.setSubject(stringSubject)
        mailComposerVC.setMessageBody(stringEmailBody, isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
        
        //        self.showEmailMessagesAlert(stringTitle: "Could Not Send Email", stringMessage: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        switch result {
        case MFMailComposeResult.cancelled:
            ModelController.showAlert(kAppName , andMessage: "Mail has been cancelled.", withController: self)
            break
        case MFMailComposeResult.sent:
            ModelController.showAlert(kAppName , andMessage: "Mail has been delivered successfully.", withController: self)
            break
        case MFMailComposeResult.failed:
            ModelController.showAlert("Error" , andMessage: "Failed to send email!", withController: self)
            break
        default:
            break
        }
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }  */
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.characters.count <= 7 && confirmPassword.characters.count <= 7{
            return true
        }else{
            return false
        }
    }
    
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
}
