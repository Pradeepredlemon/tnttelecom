
import UIKit

class Repository {
    
    var uuid: String?
    var title: String?
    var date: String?
    var time: String?
    var loc_number: String?
    var loc_name: String?
    var address: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var contact_person: String?
    var contact_email: String?
    var contact_tel: String?
    var task_status: String?
    var issue: String?
    var start_time: String?
    var end_time: String?
    var locationLat: String?
    var locationLng: String?

    init(getTaskList: NSDictionary) {
        self.uuid                       = getTaskList["uuid"] as? String
        self.title                      = getTaskList["title"] as? String
        self.date                       = getTaskList["date"] as? String
        self.time                       = getTaskList["time"] as? String
        self.loc_number                 = getTaskList["loc_number"] as? String
        self.loc_name                   = getTaskList["loc_name"] as? String
        self.address                    = getTaskList["address"] as? String
        self.city                       = getTaskList["city"] as? String
        self.state                      = getTaskList["state"] as? String
        self.zipcode                    = getTaskList["zipcode"] as? String
        self.contact_person             = getTaskList["contact_person"] as? String
        self.contact_email              = getTaskList["contact_email"] as? String
        self.contact_tel                = getTaskList["contact_tel"] as? String
        self.task_status                = getTaskList["task_status"] as? String
        self.issue                      = getTaskList["issue"] as? String
        self.start_time                 = getTaskList["start_time"] as? String
        self.end_time                   = getTaskList["end_time"] as? String
        self.locationLat                 = getTaskList["lat"] as? String
        self.locationLng                   = getTaskList["lng"] as? String
    }
    
    
    
    var useruuid: String?
    var userUser: NSDictionary?
    var useremail: String?
    var usermobile: String?
    var usercity: String?
    var username: String?
    var userstart_lat: String?
    var userstart_lng: String?
    var userstop_lat: String?
    var userstop_lng: String?
    var user_Id: Int?
    var user_contact_person: String?
    var user_contact_email: String?
    var user_contact_tel: String?
    var user_city: String?
    var user_state: String?
    var user_note: String?
    var user_start_time: String?
    var user_end_time: String?
    var user_totalCost: String?
    var user_diffInHours: String?
    var user_actualHour: String?
    var user_issue: String?
    var user_title: String?
    var task_process: NSDictionary?
    var task_description: String?
    var task_speech_text: String?
    var userEndDate: String?

    
    init(getUserList: NSDictionary) {
        
        self.useruuid                   = getUserList["uuid"] as? String
        self.task_description           = getUserList["task_description"] as? String
        self.task_speech_text           = getUserList["task_speech_text"] as? String
        self.userUser                   = getUserList["user"] as? NSDictionary
        self.task_process               = getUserList["task_process"] as? NSDictionary
        self.useremail                  = getUserList["email"] as? String
        self.usermobile                 = getUserList["mobile"] as? String
        self.usercity                   = getUserList["city"] as? String
        self.username                   = getUserList["firstname"] as? String
        self.userstart_lat              = getUserList["start_lat"] as? String
        self.userstart_lng              = getUserList["start_lng"] as? String
        self.userstop_lat               = getUserList["stop_lat"] as? String
        self.userstop_lng               = getUserList["stop_lng"] as? String
        self.user_Id                    = getUserList["id"] as? Int
        self.user_contact_person        = getUserList["contact_person"] as? String
        self.user_contact_email         = getUserList["contact_email"] as? String
        self.user_contact_tel           = getUserList["contact_tel"] as? String
        self.user_city                  = getUserList["city"] as? String
        self.user_state                 = getUserList["state"] as? String
        self.user_note                  = getUserList["note"] as? String
        self.user_start_time            = getUserList["start_time"] as? String
        self.user_end_time              = getUserList["end_time"] as? String
        self.user_totalCost             = getUserList["totalCost"] as? String
        self.user_diffInHours           = getUserList["diffInHours"] as? String
        self.user_actualHour            = getUserList["actualHour"] as? String
        self.user_issue                 = getUserList["issue"] as? String
        self.user_title                 = getUserList["title"] as? String
        self.userEndDate                 = getUserList["end_date"] as? String

    }
    
    
}
