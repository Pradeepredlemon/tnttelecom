
import UIKit
import Speech
import EPSignature
import OpalImagePicker
import MobileCoreServices

class EstimatesViewController: UIViewController, SFSpeechRecognizerDelegate, EPSignatureDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, OpalImagePickerControllerDelegate {
    
    var multipleImageArray = [UIImage]()
    var singleVideoArray = [URL]()
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var isRecording = false
    
    // TextView Outlet
    @IBOutlet weak var textViewDescriptionOutlet: UITextView!
    @IBOutlet weak var textViewDescriptionDataOutlet: UITextView!
    @IBOutlet weak var textViewUseAnyMaterial: UITextView!
    
    // TextField Outlet
    @IBOutlet weak var textFieldUserNameOutlet: UITextField!
    @IBOutlet weak var texTFieldEmailIdOutlet: UITextField!
    @IBOutlet weak var textFieldPhoneNumberOutlet: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldTimeOutlet: UITextField!
    @IBOutlet weak var textFieldPropertyNameOutlet: UITextField!
    @IBOutlet weak var textFieldPropertyAddressOutlet: UITextField!
    
    // Button Outlet
    @IBOutlet weak var buttonSpeechToTextOutlet: UIButton!
    @IBOutlet weak var buttonOpenSignatureOutlet: UIButton!
    @IBOutlet weak var buttonSaveOutlet: UIButton!
    @IBOutlet weak var buttonUploadImagesOutlet: UIButton!
    @IBOutlet weak var buttonUploadVideosOutlet: UIButton!
    
    // ImageView Outlet
    @IBOutlet weak var imageSignatureOutlet: UIImageView!
    
    // UIView Outlet
    @IBOutlet weak var viewOutlet: UIView!
    
    //UILabel Outlet
    @IBOutlet weak var labelUploadImageCount: UILabel!
    
    var datePickerValueSelection = String()
    var timePickerValueSelection = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Estimates"
        
        datePickerLayout()
        timePickerLayout()
        
        // Do any additional setup after loading the view.
        self.requestSpeechAuthorization()
        
        buttonOpenSignatureOutlet.isHidden = false
        viewOutlet.isHidden = true
        buttonSaveOutlet.isHidden = true
        
        buttonSaveOutlet.buttonLayout()
        buttonSpeechToTextOutlet.buttonLayout()
        
        buttonSpeechToTextOutlet.setTitle("Start", for: .normal)
        
        textViewDescriptionOutlet.textCornerSide()
        textViewDescriptionDataOutlet.textCornerSide()
        textViewUseAnyMaterial.textCornerSide()
        
        viewOutlet.viewCornerRadius()
        
        textViewDescriptionOutlet.text = "Description"
        textViewDescriptionOutlet.delegate = self
        textViewDescriptionOutlet.textColor = UIColor.lightGray
        
        textViewDescriptionDataOutlet.text = "Speech-To-Text"
        textViewDescriptionDataOutlet.delegate = self
        textViewDescriptionDataOutlet.textColor = UIColor.lightGray
        
        textViewUseAnyMaterial.text = "Enter Text"
        textViewUseAnyMaterial.delegate = self
        textViewUseAnyMaterial.textColor = UIColor.lightGray
        
        let dateValueSelection = Date()
        let formatterDateValueSelection = DateFormatter()
        formatterDateValueSelection.dateFormat = "MM-dd-yyyy"
        let result = formatterDateValueSelection.string(from: dateValueSelection)
        datePickerValueSelection = result
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print("\(hour)"+"\(":")"+"\(minutes)")
        timePickerValueSelection = "\(hour)"+"\(":")"+"\(minutes)"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 101 {
            self.textFieldDate.text = datePickerValueSelection
        }
        if textField.tag == 102 {
            self.textFieldTimeOutlet.text = timePickerValueSelection
        }
    }
    
    func datePickerLayout()
    {
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        // DatePicker Mode
        datePicker.datePickerMode = .date
        datePicker.minimumDate = NSDate() as Date
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(EstimatesViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.textFieldDate.inputView = datePicker
    }
    
    func timePickerLayout()
    {
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        // DatePicker Mode
        datePicker.datePickerMode = .time
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(EstimatesViewController.timePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.textFieldTimeOutlet.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        self.textFieldDate.text = selectedDate
        datePickerValueSelection = selectedDate
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "HH:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        self.textFieldTimeOutlet.text = selectedDate
        timePickerValueSelection = selectedDate
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewDescriptionDataOutlet.text.isEmpty {
            textViewDescriptionDataOutlet.text = "Speech-To-Text"
            textViewDescriptionDataOutlet.textColor = UIColor.lightGray
        }
        if textViewDescriptionOutlet.text.isEmpty {
            textViewDescriptionOutlet.text = "Description"
            textViewDescriptionOutlet.textColor = UIColor.lightGray
        }
        if textViewUseAnyMaterial.text.isEmpty {
            textViewUseAnyMaterial.text = "Enter Text"
            textViewUseAnyMaterial.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func buttonUploadVideoClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.videoClicked()
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.videoPickerFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func videoClicked() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: {})
    }
    
    func videoPickerFromGallery() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
        
    }

    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        buttonUploadImagesOutlet.setTitle("Uploaded", for: .normal)
        
        multipleImageArray = images
        print("Multiple Image Array :-" ,multipleImageArray)
        
        //        labelUploadImageCount.text = String(images.count)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonUploadImagesClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.imageOpal()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //Example Instantiating OpalImagePickerController with Closures
        /*        let imagePicker = OpalImagePickerController()
         imagePicker.imagePickerDelegate = self
         present(imagePicker, animated: true, completion: nil)   */
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            //            imagePickerController.mediaTypes = ["public.image"]
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType  == "public.image" {
                print("Image Selected")
                
                multipleImageArray.removeAll()
                
                if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    
                    buttonUploadImagesOutlet.setTitle("Uploaded", for: .normal)
                    multipleImageArray.append(pickedImage)
                }
            }
            
            if mediaType == "public.movie" {
                print("Video Selected")
                
                singleVideoArray.removeAll()
                
                if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    
                    buttonUploadVideosOutlet.setTitle("Uploaded", for: .normal)
                    singleVideoArray.append(pickedVideo)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imageOpal()  {
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func buttonSppechToTextClicked(_ sender: UIButton) {
        if isRecording == true {
            cancelRecording()
            isRecording = false
            buttonSpeechToTextOutlet.setTitle("Start", for: .normal)//.titleLabel?.text = "Start"
            buttonSpeechToTextOutlet.backgroundColor = UIColor.lightGray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            buttonSpeechToTextOutlet.setTitle("Stop", for: .normal)//.titleLabel?.text = "Stop"
            buttonSpeechToTextOutlet.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func buttonOpenSignatureViewClicked(_ sender: Any) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "Sign Here"
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonEditOpenSignatureViewClicked(_ sender: Any) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "Sign Here"
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        apiSendVoiceWithSignature()
    }
    
    func apiSendVoiceWithSignature()
    {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        if self.textFieldUserNameOutlet.text != "" && self.texTFieldEmailIdOutlet.text != "" && self.textFieldPhoneNumberOutlet.text != "" && self.textFieldDate.text != "" && self.textFieldTimeOutlet.text != "" && self.textFieldPropertyNameOutlet.text != "" && self.textFieldPropertyAddressOutlet.text != "" && self.textViewDescriptionOutlet.text != "Description" && self.textViewDescriptionDataOutlet.text != "Speech-To-Text" && self.textViewUseAnyMaterial.text != "Enter Text"
        {
            if !validateEmail(enteredEmail: texTFieldEmailIdOutlet.text!)
            {
                self.view.makeToast(kEmailMessage)
            }
            else
            {
                if Reachability.isConnectedToNetwork() == true
                {
                    showHud()
                    let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!, "description": self.textViewDescriptionOutlet.text!, "speech_text": self.textViewDescriptionDataOutlet.text!, "name": self.textFieldUserNameOutlet.text!, "email": self.texTFieldEmailIdOutlet.text!, "phone": self.textFieldPhoneNumberOutlet.text!, "signature": "", "other_images": "", "date": self.textFieldDate.text!, "other_text": self.textViewUseAnyMaterial.text!, "time": self.textFieldTimeOutlet.text!, "property_name": self.textFieldPropertyNameOutlet.text!, "property_address": self.textFieldPropertyAddressOutlet.text!] as [String : Any]
                    print(params)
                    
                    ServiceManager.POSTServerRequestWithImage(kAddEstimateUrl, andParameters: params as! [String : String], andImage: self.imageSignatureOutlet.image!,andArrayImage: multipleImageArray, andArrayVideo: singleVideoArray, success: {
                        response in
                        print("response----->",response ?? AnyObject.self)
                        
                        if response is NSDictionary
                        {
                            self.hideHUD()
                            
                            appDelegate.methodForUserLogin()
                        }
                    }
                        ,failure:
                        {
                            error in
                            self.hideHUD()
                    })
                }
                else{
                    self.view.makeToast(kNetworkError)
                }
            }
        }
        else
        {
            self.view.makeToast(kRegistrationWarningMessage)
        }
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                print(bestString)
                self.textViewDescriptionDataOutlet.text = bestString
                self.textViewDescriptionDataOutlet.textColor = UIColor.black
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                    //                    self.textViewDescriptionDataOutlet.text = lastString
                }
                //                self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.buttonSpeechToTextOutlet.isEnabled = true
                case .denied:
                    self.buttonSpeechToTextOutlet.isEnabled = false
                    self.textViewDescriptionDataOutlet.text = "User denied access to speech recognition"
                case .restricted:
                    self.buttonSpeechToTextOutlet.isEnabled = false
                    self.textViewDescriptionDataOutlet.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.buttonSpeechToTextOutlet.isEnabled = false
                    self.textViewDescriptionDataOutlet.text = "Speech recognition not yet authorized"
                @unknown default:
                    return
                }
            }
        }
    }
    
    //MARK: - Alert
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        print("User canceled")
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        //        imgViewSignature.image = signatureImage
        imageSignatureOutlet.image = signatureImage
        
        buttonOpenSignatureOutlet.isHidden = true
        viewOutlet.isHidden = false
        buttonSaveOutlet.isHidden = false
        
        //        imgWidthConstraint.constant = boundingRect.size.width
        //        imgHeightConstraint.constant = boundingRect.size.height
    }
    
}
