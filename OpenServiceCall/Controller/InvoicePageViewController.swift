
import UIKit
import MessageUI

class InvoicePageViewController: UIViewController {

    var repositoryInvoiceData = [Repository]()
    var stringTotalCost = String()
    
    // labelOutlet
    @IBOutlet weak var labelTaskId: UILabel!
    @IBOutlet weak var labelPersonName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelContactNumber: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelTotalDuration: UILabel!
    @IBOutlet weak var labelAmountValue: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelNotesOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stringTotalCost = repositoryInvoiceData[0].user_totalCost!
        let stringDifferenceInHours = repositoryInvoiceData[0].user_diffInHours

        self.labelTaskId.text = String(repositoryInvoiceData[0].user_Id as! Int)
        self.labelPersonName.text = repositoryInvoiceData[0].user_contact_person
        self.labelEmail.text = repositoryInvoiceData[0].user_contact_email
        self.labelContactNumber.text = repositoryInvoiceData[0].user_contact_tel
        self.labelStartTime.text = repositoryInvoiceData[0].user_start_time
        self.labelEndTime.text = repositoryInvoiceData[0].user_end_time
        
        self.labelTotalDuration.text = repositoryInvoiceData[0].user_actualHour //(dictionaryInvoiceData["actualHour"] as! String)
        self.labelAmount.text = "$" + stringTotalCost
        self.labelAmountValue.text = "125" + " * " + stringDifferenceInHours!

//        if let stringNotes = (dictionaryInvoiceData["note"] as? String)
//        {
//                self.labelNotesOutlet.text = stringNotes
//        }
////        self.labelNotesOutlet.text = ""
//        self.labelNotesOutlet.sizeToFit()
//
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "MailIconWhite"), style: .plain, target: self, action: #selector(addTapped(sender:)))
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func addTapped(sender: UIBarButtonItem)
    {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        customizeNavigationBarToController()
        self.navigationItem.hidesBackButton = false
        methodNavigationBarBackGroundAndTitleColor(titleString: "Invoice Detail")
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
//        mailComposeVC.setToRecipients(["tfarano@costco.com"])
        mailComposeVC.setSubject("Invoice Detail Of Task.")
        mailComposeVC.setMessageBody("Task Details :-\n\nTask Id - \(String(describing: repositoryInvoiceData[0].user_Id!))\nPerson Name - \(repositoryInvoiceData[0].user_contact_person ?? "")\nEmail - \(repositoryInvoiceData[0].user_contact_email ?? "")\nContact Number - \(repositoryInvoiceData[0].user_contact_tel ?? "")\nAmount - \("$" + stringTotalCost)\n\n", isHTML: false)
        return mailComposeVC
    }
    
    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        //        self.view.makeToast("Successfully Sent")
        controller.dismiss(animated: true, completion: nil)
    }

}
