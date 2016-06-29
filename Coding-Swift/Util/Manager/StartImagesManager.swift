//
//  StartImagesManager.swift
//  Coding-Swift
//
//  Created by sean on 16/5/5.
//  Copyright © 2016年 sean. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

private let kStartImageName = "start_image_name"

class StartImagesManager: NSObject {
    static let shareManager = StartImagesManager()
    
    private var imageLoadedArray = [StartImage]()
    private var startImage: StartImage?
    
    override init() {
        super.init()
        createFolder(self.downloadPath)
        loadStartImages()
    }
    
    private func createFolder(path: String) -> Bool {
        var isDir: ObjCBool = false
        let fileManager = NSFileManager.defaultManager()
        let existed = fileManager.fileExistsAtPath(path, isDirectory: &isDir)
        var isCreated: Bool = false
        if !(isDir.boolValue && existed)  {
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return false
            }
            isCreated = true
        } else {
            isCreated = true
        }
        if isCreated {
            NSURL.addSkipBackupAttributeToItemAtURL(NSURL(fileURLWithPath: path, isDirectory: true))
        }
        return isCreated
    }
    
   private var downloadPath: String {
        let mainPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        return mainPath.stringByAppendingPathComponent("Coding_StartImages")
    }
    
    private var pathOfSTPlist: String {
        return (self.downloadPath as NSString).stringByAppendingPathComponent("STARTIMAGE.plist")
    }
    
    func randomImage() -> StartImage {
        let count = imageLoadedArray.count
        if count > 0 {
            let index = Int(arc4random()) % count
            startImage = imageLoadedArray[index]
        } else {
            startImage = StartImage.defautImage()
        }
        
        saveDisplayImageName(startImage!.fileName!)
        refreshImagesPlist()
        return startImage!
    }
    
    var curImage: StartImage {
        if startImage == nil {
            startImage = StartImage.defautImage()
        }
        return startImage!
    }
    
    func handleStartLink() {
        guard Login.isLogin || Login.curLoginUser!.global_key?.length > 0 else {
            return;
        }
        
        let link = self.curImage.group?.link
        guard let _ = link?.hasPrefix("https:") else {
            return
        }
        
        let global_key = Login.curLoginUser!.global_key
        let tipKey = "\(kFunctionTipStr_Prefix)_\(global_key)_\(link)"
        if !FunctionTipsManager.shareManager().needToTip(tipKey) {
            return
        }
        
        let curNav = BaseViewController.presentingVC()
        guard let _ = curNav else {
            return
        }
        
        FunctionTipsManager.shareManager().markTiped(tipKey) //标记
        
    }
    
    private func loadStartImages() {
        let plistArray = NSArray(contentsOfFile: pathOfSTPlist)
        let elementArray = Mapper<StartImage>().mapArray(plistArray)
        
        var imageLoadedArray = [StartImage]()
        let fileManager = NSFileManager.defaultManager()
        
        if let array = elementArray {
            for item in array {
                if fileManager.fileExistsAtPath(item.pathDisk!) {
                    imageLoadedArray.append(item)
                }
            }
        }
    
        let preDisplayImageName = getDisplayImageName()
        if let imageName = preDisplayImageName where preDisplayImageName?.length > 0 {
            let index = imageLoadedArray.indexOf({ (currentItem) -> Bool in
                if currentItem.fileName == imageName {
                    return true
                }
                return false
            })
            if let index = index where
                imageLoadedArray.count > 1 {
                imageLoadedArray.removeAtIndex(index)
            }
        }
        
        self.imageLoadedArray = imageLoadedArray;
    }
    
    private func refreshImagesPlist() {
        let aPath = "api/wallpaper/wallpapers"
        let params = ["type": "3"]
        let router = Router(requestMethod: RequestMethod.Get(aPath, params))
        NetAPIClient.sharedInstance().requestData(router) { (result, error) in
            guard error == nil else {
                return
            }
            let resultA = result?.valueForKey("data") as! NSArray
            if self.createFolder(self.downloadPath) {
                if resultA.writeToFile(self.pathOfSTPlist, atomically: true) {
                    StartImagesManager.shareManager.startDownloadImages()
                }
            }
        }
    }
    
    private func startDownloadImages() {
        let reachabilityManager = NetworkReachabilityManager()
        guard reachabilityManager!.isReachableOnEthernetOrWiFi else {
            return
        }
        
        let plistArray = NSArray(contentsOfFile: pathOfSTPlist)
        let elementArray = Mapper<StartImage>().mapArray(plistArray)!
        
        var needToDownloadArray = [StartImage]()
        let fileManager = NSFileManager.defaultManager()
        
        for item in elementArray {
            if !fileManager.fileExistsAtPath(item.pathDisk!) {
                needToDownloadArray.append(item)
            }
        }
        
        for item in needToDownloadArray {
            item.startDownloadImage()
        }
    }
    
    private func saveDisplayImageName(name: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(name, forKey: kStartImageName)
        defaults.synchronize()
    }
    
    private func getDisplayImageName() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(kStartImageName) as? String
    }
}

class StartImage: Mappable {
    var url: String?
    var group: Group?
    private var _fileName       : String?
    private var _pathDisk       : String?
    private var _descriptionStr : String?
    
    // MARK: - Mappable
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        url     <- map["url"]
        group   <- map["group"]
    }
    
    init() {
        
    }
    
    var fileName: String? {
        set {
            _fileName = newValue
        }
        get {
            if _fileName == nil && url?.length > 0 {
                _fileName = url?.componentsSeparatedByString("/").last
            }
            return _fileName
        }
    }
    
    var pathDisk: String? {
        set {
            _pathDisk = newValue
        }
        get {
            if _pathDisk == nil && url?.length > 0 {
                let mainPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
                _pathDisk = (mainPath.stringByAppendingPathComponent("Coding_StartImages") as NSString).stringByAppendingPathComponent(self.fileName!)
            }
            return _pathDisk
        }
    }
    
    var descriptionStr: String {
        set {
            _descriptionStr = newValue
        }
        get {
            var groupName: String, groupAuthor: String
            
            if let tempGroupName = self.group?.name {
                groupName = tempGroupName
            } else {
                groupName = "今天天气不错"
            }
            
            if let tempGroupAuthor = self.group?.author {
                groupAuthor = tempGroupAuthor
            } else {
                groupAuthor = "作者"
            }
            
            _descriptionStr = "\"\(groupName)\" © \(groupAuthor)"
            
            return _descriptionStr!
        }
    }
    
    class func defautImage() -> StartImage {
        let startImage = StartImage()
        startImage.descriptionStr = "\"Light Returning\" © 十一步"
        startImage.fileName = "STARTIMAGE.jpg"
        startImage.pathDisk = NSBundle.mainBundle().pathForResource("STARTIMAGE", ofType: "jpg")
        return startImage
    }
    
    class func midAutumnImage() -> StartImage {
        let startImage = StartImage()
        startImage.descriptionStr = "\"中秋快乐\" © Mango"
        startImage.fileName = "MIDAUTUMNIMAGE.jpg"
        startImage.pathDisk = NSBundle.mainBundle().pathForResource("MIDAUTUMNIMAGE", ofType: "jpg")
        return startImage
    }
    
    var image: UIImage {
        return UIImage(contentsOfFile: self.pathDisk!)!
    }
    
    func startDownloadImage() {
        Alamofire.download(.GET, self.url!) { (temporaryURL, response) -> NSURL in
            let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
            let pathDisk = (documentPath.stringByAppendingPathComponent("Coding_StartImages") as NSString).stringByAppendingPathComponent(response.suggestedFilename!)
            return NSURL(fileURLWithPath: pathDisk)
            }.response { (_, _, _, error) in
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Downloaded file successfully")
                }
        }
    }
}

class Group: Mappable {
    var name: String?
    var author: String?
    var link: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["name"]
        author  <- map["author"]
        link    <- map["link"]
    }
}
