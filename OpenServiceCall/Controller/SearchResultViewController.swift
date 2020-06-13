
import UIKit
import MapKit

protocol SearchDelegate {
    func searchValue(arrayValue: [NSMutableDictionary])
}

class SearchResultViewController: UIViewController {
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var tableviewSearch: UITableView!
    @IBOutlet weak var constraintSearchIconWidth: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapview: MKMapView!
    var autocompleteResults :[GApiResponse.Autocomplete] = []

    var arrayData = [NSMutableDictionary]()

    var delegateSearchValue: SearchDelegate?

    @IBAction func searchButtonPressed(_ sender: Any) {
        textfieldAddress.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        self.textfieldAddress.delegate = self
        
        let rightButtonItem = UIBarButtonItem.init( title: "DONE", style: .done, target: self, action: #selector(rightButtonSearchAction))
        rightButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func rightButtonSearchAction()
    {
        delegateSearchValue?.searchValue(arrayValue: arrayData)
    
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
    }

    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    self.tableviewSearch.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    
    func hideResults() {
        searchView.isHidden = true
        autocompleteResults.removeAll()
        tableviewSearch.reloadData()
    }
}

extension SearchResultViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideResults() ; return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let fullText = text.replacingCharacters(in: range, with: string)
        if fullText.count > 2 {
            showResults(string:fullText)
        }else{
            hideResults()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        constraintSearchIconWidth.constant = 0.0 ;
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        constraintSearchIconWidth.constant = 38.0 ;
        return true
    }
}
extension SearchResultViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var input = GInput()
        
        self.arrayData.removeAll()
        
        let destination = GLocation.init(latitude: mapview.region.center.latitude, longitude: mapview.region.center.longitude)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async {
                    self.textfieldAddress.text = places.first?.formattedAddress
                    print(places.first?.formattedAddress ?? "")
                    print(places.first?.latitude)
                    
                    let keyValueData = NSMutableDictionary()
                    keyValueData.setValue(places.first?.formattedAddress, forKey: "Address")
                    keyValueData.setValue(places.first?.latitude!, forKey: "Latitude")
                    keyValueData.setValue(places.first?.longitude!, forKey: "Longitude")
                    self.arrayData.append(keyValueData)
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}
extension SearchResultViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = autocompleteResults[indexPath.row].formattedAddress
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        arrayData.removeAll()
        
        textfieldAddress.text = autocompleteResults[indexPath.row].formattedAddress
        textfieldAddress.resignFirstResponder()
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    print(place.formattedAddress)//first.formattedAddress ?? "")
                    
                    let keyValueData = NSMutableDictionary()
                    keyValueData.setValue(place.formattedAddress, forKey: "Address")
                    keyValueData.setValue(place.latitude!, forKey: "Latitude")
                    keyValueData.setValue(place.longitude!, forKey: "Longitude")
                    self.arrayData.append(keyValueData)

                    self.searchView.isHidden = true
                    if let lat = place.latitude, let lng = place.longitude{
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        self.mapview.setRegion(region, animated: true)
                    }
                    self.tableviewSearch.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}
