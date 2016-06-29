//
//  EaseStartView.swift
//  Coding-Swift
//
//  Created by sean on 16/5/5.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import SnapKit
import NYXImagesKit

class EaseStartView: UIView {
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = kScreen_Bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.alpha = 0.0
        return imageView
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    lazy var descriptionStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(10.0)
        label.textColor = UIColor(white: 1.0, alpha: 0.5)
        label.textAlignment = .Center
        label.alpha = 0.0
        return label
    }()
    
    // MARK: - func
    class func startView() -> EaseStartView {
        let logoIcon = UIImage(named: "logo_coding_top")
        let st = StartImagesManager.shareManager.randomImage()
        return EaseStartView.init(bgImage: st.image, logonIcon: logoIcon!, descriptionStr: st.descriptionStr)
    }
    
    init(bgImage: UIImage, logonIcon: UIImage, descriptionStr: String) {
        super.init(frame: kScreen_Bounds)
        backgroundColor = UIColor.blackColor()
        //bgImage
        self.addSubview(bgImageView)
        //logoImage
        self.addSubview(logoView)
        //label
        self.addSubview(descriptionStrLabel)
        //layout
        descriptionStrLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(10.0)
            make.bottom.equalTo(self.snp_bottom).offset(-15.0)
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
        }
        
        logoView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(kScreen_Height/7.0)
            make.width.equalTo(kScreen_Width*2.0/3.0)
            make.height.equalTo(kScreen_Width/4.0*2.0/3.0)
        }
        
        config(bgImage, logoIcon: logonIcon, description: descriptionStr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func config(bgImage: UIImage, logoIcon: UIImage, description: String) {
        var customImage = bgImage
        customImage = customImage.scaleToSize(bgImageView.doubleSizeOfFrame(), usingMode: NYXResizeModeAspectFill)
        bgImageView.image = customImage
        logoView.image = logoIcon
        descriptionStrLabel.text = description
        updateConstraints()
    }
    
    func startAnimationWithCompletionBlock(completionHandler: EaseStartView -> Void) {
        kKeyWindow?.addSubview(self)
        kKeyWindow?.bringSubviewToFront(self)
        bgImageView.alpha = 0.0
        descriptionStrLabel.alpha = 0.0
        
        UIView.animateWithDuration(2.0, animations: {
            self.bgImageView.alpha = 1.0
            self.descriptionStrLabel.alpha = 1.0
        }) { (finished) in
            UIView.animateWithDuration(0.6, delay: 0.3, options: .CurveEaseIn, animations: {
                self.x = -kScreen_Width
                }, completion: { (finished) in
                    self.removeFromSuperview()
                    completionHandler(self)
            })
        }
    }
}
