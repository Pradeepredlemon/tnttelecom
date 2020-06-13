
import UIKit

import Alamofire

class ServiceManager: NSObject {
    
    //  Method for POST request
    
    class func POSTServerRequest(_ queryString: String,andParameters payload: [String: String], success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
        let urlString = String(format:"%@", formattedSearchString)
        let parameters = payload
        
        print("urlString-----",urlString)
        print("parameters-----",parameters)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //            multipartFormData.append(UIImageJPEGRepresentation(self.capturedImage, 0.5)!, withName: "pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to:urlString)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    //                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    //                    success(JSON as AnyObject?)
                    //
                    //                }
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary {
                            
                            success(jsonResult )
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                failure(encodingError as NSError?)
                
            }
        }
    }
    
    
    
    //  Method for Get request
    
    class func methodGETServerRequest(_ queryString: String, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
        let urlString = String(format:"%@",formattedSearchString)
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                    
                case .success:
                    print(response)
                    print(response.timeline)
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? AnyObject {
                            
                            success(jsonResult )
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    
                    failure(error as NSError?)
                    
                }
        }
    }
    
    
    
    // Method for post request with image
    
    class func POSTServerRequestWithImage(_ queryString: String, andParameters payload: [String: String],andImage uploadImage:(UIImage), andArrayImage uploadArrayImage: [UIImage], andArrayVideo uploadArrayVideo: [URL],success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
        let urlString = String(format:"%@", formattedSearchString)
        let parameters = payload
        var imageParam : String? = nil
        
        print("urlString-----",urlString)
        print("parameters-----",parameters)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(uploadImage.jpegData(compressionQuality: 0.5)!, withName: "signature", fileName: "MenuNavigationBar", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
//            multipartFormData.append(uploadImage.jpegData(compressionQuality: 0.5)!, withName: "other_images", fileName: "MenuNavigationBar", mimeType: "image/jpeg")
            for i in 0..<uploadArrayImage.count{
                let imageData1 = uploadArrayImage[i].jpegData(compressionQuality: 1.0)!
                multipartFormData.append(imageData1, withName: "other_images[\(i)]" , fileName: "photo" + String(i) + ".jpg", mimeType: "image/jpeg")
            }
            for i in 0..<uploadArrayVideo.count{
                multipartFormData.append(uploadArrayVideo[i], withName: "other_videos", fileName: "video.mp4", mimeType: "video/mp4")
//                multipartFormData.append((uploadArrayVideo[i].data(using: String.Encoding.utf8, allowLossyConversion: false)), withName: "Type")

                for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }

//                multipartFormData.append(uploadArrayVideo[i].data)//data(using: String.Encoding.utf8))
            }
        }
            
            , to:urlString)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    
                    //                    print(response.request ?? String())  // original URL request
                    //                    print(response.response ?? String()) // URL response
                    //                    print(response.data ?? String())     // server data
                    //                    print(response.result )   // result of response serialization
                    
                    //                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    //                    success(JSON as AnyObject?)
                    //
                    //                }
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary {
                            
                            success(jsonResult )
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                failure(encodingError as NSError?)
                
            }
        }
    }
    
    
    class func methodGETWithHeaderServerRequest(_ queryString: String, andParameters payload: [String: AnyObject],andHeaders header:String, success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
        let urlString = String(format:"%@",formattedSearchString)
        
        print("queryString------",queryString);
        print("stringAccessToken------",header);
        
        var headers: NSDictionary = NSDictionary()
        headers = [
            "Accept": "application/json",
            "Authorization": String(format:"Bearer %@",header)
        ]
        
        Alamofire.request(urlString, headers: headers as? HTTPHeaders )
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                    
                case .success:
                    print(response)
                    print(response.timeline)
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? AnyObject {
                            print("jsonResult-------",jsonResult)
                            success(jsonResult )
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    
                    failure(error as NSError?)
                    
                }
        }
    }
    
    /*
     class func POSTServerRequestWithVideoUrl(_ queryString: String,andParameters payload: [String: String],andVideoURL uploadVideo:(URL), success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
     
     let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
     let urlString = String(format:"%@", formattedSearchString)
     let parameters = payload
     
     print("urlString-----",urlString)
     print("parameters-----",parameters)
     
     Alamofire.upload(multipartFormData: { (multipartFormData) in
     
     let videoPathUrl = NSURL(fileURLWithPath: "")
     
     //    multipartFormData.append(fileURL:videoPathUrl, name: "image")
     // multipartFormData.append(videoPathUrl, withName: "image")
     
     for (key, value) in parameters {
     multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
     }
     
     }, to:urlString)
     { (result) in
     switch result {
     case .success(let upload, _, _):
     
     upload.uploadProgress(closure: { (Progress) in
     print("Upload Progress: \(Progress.fractionCompleted)")
     })
     
     upload.responseJSON { response in
     //self.delegate?.showSuccessAlert()
     
     //                    print(response.request ?? String())  // original URL request
     //                    print(response.response ?? String()) // URL response
     //                    print(response.data ?? String())     // server data
     //                    print(response.result )   // result of response serialization
     
     //                if let JSON = response.result.value {
     //                    print("JSON: \(JSON)")
     //                    success(JSON as AnyObject?)
     //
     //                }
     
     do {
     if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary {
     
     success(jsonResult )
     
     }
     } catch let error as NSError {
     print(error.localizedDescription)
     }
     }
     
     case .failure(let encodingError):
     //self.delegate?.showFailAlert()
     print(encodingError)
     failure(encodingError as NSError?)
     
     }
     }
     }
     
     
     class func POSTServerRequest(_ queryString: String,andParameters payload: [String: String], success: @escaping (_ response: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
     let formattedSearchString = queryString.replacingOccurrences(of: " ", with:"")
     let urlString = String(format:"%@", formattedSearchString)
     let parameters = payload
     
     print("urlString-----",urlString)
     print("parameters-----",parameters)
     
     Alamofire.upload(multipartFormData: { (multipartFormData) in
     //            multipartFormData.append(UIImageJPEGRepresentation(self.capturedImage, 0.5)!, withName: "pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
     for (key, value) in parameters {
     multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
     }
     
     }, to:urlString)
     { (result) in
     switch result {
     case .success(let upload, _, _):
     
     upload.uploadProgress(closure: { (Progress) in
     print("Upload Progress: \(Progress.fractionCompleted)")
     })
     
     upload.responseJSON { response in
     //self.delegate?.showSuccessAlert()
     
     //                print(response.request)  // original URL request
     //                print(response.response) // URL response
     //                print(response.data)     // server data
     //                print(response.result)   // result of response serialization
     
     //                if let JSON = response.result.value {
     //                    print("JSON: \(JSON)")
     //                    success(JSON as AnyObject?)
     //
     //                }
     
     do {
     if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary {
     
     success(jsonResult )
     print(jsonResult)
     print("Result: \(jsonResult)")
     
     }
     } catch let error as NSError {
     print("Error: \(error.localizedDescription)")
     
     }
     }
     
     case .failure(let encodingError):
     //self.delegate?.showFailAlert()
     print(encodingError)
     failure(encodingError as NSError?)
     
     }
     }
     }  */
    
}
