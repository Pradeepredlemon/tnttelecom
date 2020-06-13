
import UIKit
import Alamofire
import MapKit

class AdminAddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    @IBAction func onclickrepeat(_ sender: Any) {
        
    }
    //    TextField Outlet
    
    @IBOutlet weak var tblviewrepeat: UITableView!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldUserAssigned: UITextField!
    @IBOutlet weak var textFieldContactPerson: UITextField!
    @IBOutlet weak var textFieldContactTelephone: UITextField!
    @IBOutlet weak var repeatstay: UIButton!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPropertyName: UITextField!
    @IBOutlet weak var textFieldForm: UITextField!
    
     @IBOutlet weak var textFieldChooseOption: UITextField!
    //    TextView Outlet
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var textfieldTo: UITextField!
    @IBOutlet weak var textViewIssue: UITextView!
    
    @IBOutlet weak var textFieldAlert: UITextField!
    
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    
    @IBOutlet weak var onOffSwitch: UISwitch!
    //    Button Outlet
    @IBOutlet weak var buttonActive: UIButton!
    @IBOutlet weak var buttonInActive: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    
    
    
    fileprivate var myPickerView = UIPickerView()
    var userAssignedId = String()
    var userAssigned = String()
    var repositoryUserList = [Repository]()
    
    var latitudeValue = Double()
    var longitudeValue = Double()
    
    var buttonStatus = String()
    
    var datePickerValueSelection = String()
    var timePickerValueSelection = String()
    
    var globalTextfield:UITextField?
    
    var pickArray = [String]()
    var repeatlist = ["none","Every_Day","Every_Week","Every_2Week","Every_Month","Every_Year"]
    var alertarray = ["1","5","10","60","24","2","7"]
    var onOffBoolValue = "0"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerLayout()
        timePickerLayout()
        
        self.textFieldUserAssigned.delegate = self
        self.textFieldAddress.delegate = self
        
        self.textFieldUserAssigned.text = userAssigned
        
        self.textViewIssue.layer.borderColor = UIColor.lightGray.cgColor
        self.textViewIssue.layer.cornerRadius = 5
        self.textViewIssue.layer.borderWidth = 0.5
        
        buttonSave.buttonLayout()
        apiUserList()
        self.title = "Add Task"
        
        buttonStatus = "1"
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

//        textFieldAddress.delegate = self
    }
    
    
    @IBAction func onOffMethod(_ sender: UISwitch) {
        if sender.isOn == true
        {
            self.onOffBoolValue = "1"
            fromDateLbl.isHidden = true
            toDateLbl.isHidden = true
            textfieldTo.isHidden = true
            textFieldForm.isHidden = true
        }
        else if sender.isOn == false
        {
            self.onOffBoolValue = "0"
            fromDateLbl.isHidden = false
            toDateLbl.isHidden = false
            textfieldTo.isHidden = false
            textFieldForm.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.textFieldTitle.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppDelegate.sharedSegmentValue.sharedUserAssignedValue = 101
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
        //datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AdminAddTaskViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        
       
         self.textFieldDate.inputView = datePicker
      
        self.textFieldForm.inputView = datePicker
        
        
    }
    
    func toDatePickerView( _ textField:UITextField)
    {
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        // DatePicker Mode
        datePicker.datePickerMode = .date
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AdminAddTaskViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
       textField.inputView = datePicker
        //        self.textFieldDate.addSubview(datePicker)
        
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
        datePicker.addTarget(self, action: #selector(AdminAddTaskViewController.timePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.textFieldTime.inputView = datePicker
        //        self.textFieldDate.addSubview(datePicker)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        if self.globalTextfield == textFieldDate
        {
            self.textFieldDate.text = selectedDate
        }
        else if self.globalTextfield == textFieldForm
        {
            self.textFieldForm.text = selectedDate
        }
        else if self.globalTextfield == textfieldTo
        {
            self.textfieldTo.text = selectedDate
        }
        
        
        //datePickerValueSelection = selectedDate
    }
    
    @objc func datePickerValueChanged1(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        
        self.textFieldForm.text = selectedDate
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
        
        self.textFieldTime.text = selectedDate
        timePickerValueSelection = selectedDate
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self as UIPickerViewDelegate
        self.myPickerView.dataSource = self as UIPickerViewDataSource
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AdminAddTaskViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AdminAddTaskViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return repositoryUserList.count
        
        return pickArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return repositoryUserList[row].username
        return pickArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if globalTextfield == textFieldChooseOption {
            textFieldChooseOption.text = pickArray[row]
        }
        else if globalTextfield == textFieldAlert {
            textFieldAlert.text = pickArray[row]
        }
        
       // self.textFieldUserAssigned.text = repositoryUserList[row].username
//        userAssignedId = repositoryUserList[row].useruuid ?? "123"
    }
    func alertpicView(){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 10 {
            if AppDelegate.sharedSegmentValue.sharedUserAssignedValue == 101 {
                textField.isUserInteractionEnabled = true
//                self.pickUp(textFieldUserAssigned)
                
                let objAdminSideUserListViewController = kStoryBoard.instantiateViewController(withIdentifier: "AdminSideUserListViewController") as? AdminSideUserListViewController
                objAdminSideUserListViewController?.repositoryTaskList = repositoryUserList
                objAdminSideUserListViewController?.delegateValue = self
                navigationController?.pushViewController(objAdminSideUserListViewController!, animated: true)
            }
            else {
                textField.isUserInteractionEnabled = false
            }
        }
        if textField.tag == 7 {            
            let objSearchResultViewController = kStoryBoard.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
            objSearchResultViewController?.delegateSearchValue = self as? SearchDelegate
            navigationController?.pushViewController(objSearchResultViewController!, animated: true)
        }
        
        if textField == textFieldDate {
            self.globalTextfield = textFieldDate
            self.datePickerLayout()
        }
        else if textField == textFieldForm
        {
                        self.globalTextfield = textFieldForm
                        self.datePickerLayout()
            }
        else if textField == textfieldTo
        {
                        self.globalTextfield = textfieldTo
                        self.toDatePickerView(textfieldTo)
        }
        else if textField == textFieldChooseOption
        {
                self.globalTextfield = textFieldChooseOption
                self.pickArray.removeAll()
                self.pickArray.append(contentsOf: repeatlist)
                self.pickUp(textFieldChooseOption)
        }
        else if textField == textFieldAlert
        {
                self.globalTextfield = textFieldAlert
                self.pickArray.removeAll()
                self.pickArray.append(contentsOf: alertarray)
                self.pickUp(textFieldAlert)
        }
       
    }
    
    @IBAction func buttonActiveInactiveClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            buttonActive.setImage(UIImage(named: "CircleFilledLogo"), for: .normal)
            buttonInActive.setImage(UIImage(named: "CircleLogo"), for: .normal)
            buttonStatus = "1"
        }
        else {
            buttonActive.setImage(UIImage(named: "CircleLogo"), for: .normal)
            buttonInActive.setImage(UIImage(named: "CircleFilledLogo"), for: .normal)
            buttonStatus = "0"
        }
    }
    
    @objc func doneClick() {
        textFieldUserAssigned.resignFirstResponder()
        globalTextfield?.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        textFieldUserAssigned.resignFirstResponder()
        globalTextfield?.resignFirstResponder()
    }
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        apiAddTask()
    }
    
    func apiAddTask()
    {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        if self.textViewIssue.text != "" && self.textFieldDate.text != "" && self.textFieldEmail.text != "" && self.textFieldTitle.text != "" && self.textFieldContactPerson.text != "" && self.textFieldAddress.text != "" && self.textFieldContactTelephone.text != "" && self.textFieldUserAssigned.text != "" && self.textFieldPropertyName.text != "" &&
            self.textFieldChooseOption.text != "" &&
            self.textFieldAlert.text != ""
        {
            if !validateEmail(enteredEmail: textFieldEmail.text!)
            {
                self.view.makeToast(kEmailMessage)
            }
            else
            {
                if Reachability.isConnectedToNetwork() == true
                {
                    showHud()
                    
                    print(userAssignedId)
                    
                    let params = ["user_uuid":  userAssignedId, "title": self.textFieldTitle.text!, "issue": self.textViewIssue.text!, "lat": String(latitudeValue), "lng": String(longitudeValue), "date": self.textFieldDate.text!, "time": self.textFieldTime.text!, "property_name": self.textFieldPropertyName.text!, "address": self.textFieldAddress.text!, "contact_person": self.textFieldContactPerson.text! , "status": buttonStatus, "contact_email": self.textFieldEmail.text!, "contact_tel": self.textFieldContactTelephone.text!,"stay_from": self.textFieldForm.text!,"stay_to": self.textfieldTo.text!,"task_repeat": self.textFieldChooseOption.text!,"alert": self.textFieldAlert.text!, "all_stays": self.onOffBoolValue,"admin_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!] as [String : Any]
                    print(params)
                    
                    ServiceManager.POSTServerRequest(kAddEvent, andParameters: params as! [String : String], success:
                        {
                            response in
                            print("response----->",response ?? AnyObject.self)
                            
                            if response is NSDictionary
                            {
                                self.hideHUD()
                                
                                let statusString = response?["success"] as! Bool
                                let messageString = response?["display_msg"] as! String
                                
                                guard statusString == true
                                    else
                                {
                                    self.view.makeToast(messageString)
                                    return
                                }
                                //                                self.view.makeToast(messageString)
                                let ref = Constants.refs.databaseRoot.child("users").child(self.userAssignedId)
                                ref.updateChildValues(["status": 1])
                                
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
            self.view.makeToast(kFillFieldsWarningMessage)
        }
        
    }
    
    func apiUserList()
    {
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            
            ServiceManager.methodGETServerRequest(kUserLists , success: { response in
                print("response----->",response ?? AnyObject.self)
                
                if response is NSDictionary
                {
                    self.hideHUD()
                    
                    let statusString = response?["success"] as! Bool
                    let messageString = response?["display_msg"] as! String
                    
                    guard statusString == true
                        else
                    {
                        self.view.makeToast(messageString)
                        return
                    }
                    let data = response?["payload"] as? NSArray
                    print(data ?? AnyObject.self)
                    
                    for dataCategory in data!
                    {
                        self.repositoryUserList.append(Repository(getUserList: dataCategory as! NSDictionary))
                    }
                }
            }, failure: {
                error in
                self.hideHUD()
            })
        }
        else{
            self.view.makeToast(kNetworkError)
        }
    }
        
}

extension AdminAddTaskViewController: UserListDelegate {
    func userList(arrayValue: [NSMutableDictionary]) {
        
        print(arrayValue)
        var arrayUserName = [String]()
        var arrayUserUuid = [String]()
        
        for indexValue in 0..<arrayValue.count {
            arrayUserName.append(arrayValue[indexValue].value(forKey: "UserName") as? String ?? "")
            arrayUserUuid.append(arrayValue[indexValue].value(forKey: "UserUuid") as? String ?? "")

            self.textFieldUserAssigned.text = arrayUserName.joined(separator: ", ")
            userAssignedId = arrayUserUuid.joined(separator: ",")
        }
    }
    
}

extension AdminAddTaskViewController: SearchDelegate {
    func searchValue(arrayValue: [NSMutableDictionary]) {
        
        print(arrayValue)
        
        for indexValue in 0..<1 {
            self.textFieldAddress.text = arrayValue[indexValue].value(forKey: "Address") as? String
            latitudeValue = arrayValue[indexValue].value(forKey: "Latitude") as? Double ?? 0.0
            longitudeValue = arrayValue[indexValue].value(forKey: "Longitude") as? Double ?? 0.0
        }
    }
        
}
extension AdminAddTaskViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return repeatlist.count
    
    
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let Every_day = tableView.dequeueReusableCell(withIdentifier: "Every_day",for:indexPath)
        Every_day.textLabel?.text = repeatlist[indexPath.row]
               return Every_day;
    }
    
}
