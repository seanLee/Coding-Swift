//
//  NetAPIClient.swift
//  Coding-Swift
//
//  Created by sean on 16/4/29.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation
import Alamofire

class NetAPIClient: NSObject {
    // MARK: - Manage
    private static var _netAPIClient: NetAPIClient?
    
    var manager : Manager?
    
    // MARK: - Singleton
    class func sharedInstance() -> NetAPIClient {
        var onceToken:dispatch_once_t = 0
        dispatch_once(&onceToken) {
            _netAPIClient = NetAPIClient.init()
        }
        return _netAPIClient!
    }
    
    override init() {
        super.init()
        self.manager = Manager.sharedInstance
    }
    
    func requestData(router: Router, completionHandler: (AnyObject?, NSError?) -> Void) {
        Alamofire.request(router).responseJSON { response in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            if let error = self.handleResponse((response.result.value as! [String: AnyObject])) {
                completionHandler(nil, error)
            } else {
                completionHandler(response.result.value, nil)
            }
        }
    }
}

// MARK: - Router
enum RequestMethod {
    case Post(String, [String: AnyObject])
    case Get(String, [String: AnyObject])
    case Update(String, [String: AnyObject])
    case Delete(String, [String: AnyObject])
}

struct Router: URLRequestConvertible {
    static let baseURLString = "https://coding.net/"
    static var OAuthToken: String?
    
    var requestMethod: RequestMethod
    
    var method: Alamofire.Method {
        switch self.requestMethod {
        case .Post:
            return .POST
        case .Get:
            return .GET
        case .Update:
            return .PUT
        case .Delete:
            return .DELETE
        }
    }
    
    var path: String {
        switch self.requestMethod {
        case .Post(let param):
            return param.0
        case .Get(let param):
            return param.0
        case .Update(let param):
            return param.0
        case .Delete(let param):
            return param.0
        }
    }
    
    // MARK: URLRequestConvertible
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = self.method.rawValue
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue(URL.absoluteString, forHTTPHeaderField: "Referer")
        
        switch self.requestMethod {
        case .Get(let param):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: param.1).0
        case .Post(let param):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: param.1).0
        case .Update(let param):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: param.1).0
        default:
            return mutableURLRequest
        }
    }
}
