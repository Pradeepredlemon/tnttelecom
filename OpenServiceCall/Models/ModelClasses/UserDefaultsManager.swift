
import UIKit

class UserDefaultsManager: NSObject {

    //Method for save Object in NSUserDefaults as string
    class func methodForSaveStringObjectValue(_ stringObjectName: String, andKey stringKey: String){
        
            UserDefaults.standard.setValue(stringObjectName, forKey:stringKey)
    }
    
    //Method for save Object in NSUserDefaults as dictionary
    class func methodForSaveDictionaryObjectValue(_ dictionaryObjectName: NSDictionary, andKey stringKey: String){
        
        UserDefaults.standard.setValue(dictionaryObjectName, forKey:stringKey)
    }
   
    //Method for fetch Object in NSUserDefaults as dictionary
    class func methodForFetchDictionaryObjectValue(_ dictionaryKey: String)->NSDictionary{
        
        let dictionaryFetchResult = UserDefaults.standard.object(forKey: dictionaryKey) as! NSDictionary
        return dictionaryFetchResult
    }
    
    //Method for fetch Object from NSUserDefaults
    class func methodForFetchStringObjectValue(_ stringKey: String)->String{
        
      let stringFetchResult = UserDefaults.standard.object(forKey: stringKey) as! String
      return stringFetchResult
    }

    //Method for save Boolean in NSUserDefaults
    class func methodForSaveBooleanValue(_ booleanValue: Bool, andKey stringKey: String) {
        
        UserDefaults.standard.set(booleanValue, forKey:stringKey)
        
    }
    
    //Method for fetch Boolean from NSUserDefaults
    class func methodForFetchBooleanValue(_ stringKey: String)-> Bool {
       
        var isBoolValue = Bool()

        if UserDefaults.standard.bool(forKey: stringKey) {
            isBoolValue = true
        }else{
            isBoolValue = false

        }
        return isBoolValue
    }
    
    //Method for remove Object from NSUserDefaults
    class func methodForRemoveObjectValue(_ stringKey: String){
        
        UserDefaults.standard.removeObject(forKey: stringKey)
        
    }

    
}
