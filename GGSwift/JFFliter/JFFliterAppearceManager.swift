//
//  JFFliterAppearceManager.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

enum JFFliterSeparateLineStyle {
    case Black
    case White
    case None
}

class JFFliterAppearceManager: NSObject {
    
    static let shared : JFFliterAppearceManager = {
        return JFFliterAppearceManager()
    }()
    
    var sectionPaddingSize = CGSize.init(width: 10.0, height: 8.0)
    var separateLineStyle = JFFliterSeparateLineStyle.Black
    
    var subButtonCount = 3
    var subButtonHeight: CGFloat = 28.0
    var subButtonBackgroundColor = UIColor.JFFliter_colorWithHexString(hex: "#323336")
    var subButtonTextNormalColor = UIColor.JFFliter_colorWithHexString(hex: "#D7D7D7")
    var subButtonTextChoodenColor = UIColor.JFFliter_colorWithHexString(hex: "#FF7700")
    var subButtonFont = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 13))
    
    var pickerHeight: CGFloat = 35.0
    var pickerInsets = UIEdgeInsets.init(top: 5, left: 8, bottom: -5, right: -8)
    var pickerContainerColor = UIColor.JFFliter_colorWithHexString(hex: "#030404")
    var pickerBackgroundColor = UIColor.JFFliter_colorWithHexString(hex: "#232529")
    var pickerTextColor = UIColor.JFFliter_colorWithHexString(hex: "#616161")
    var pickerPlaceHolderColor = UIColor.JFFliter_colorWithHexString(hex: "#4E4E4E")
    var pickerTextFont = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 14))
    var pickerIndicaterColor = UIColor.JFFliter_colorWithHexString(hex: "#FFFFFF")
    var pickerIndicaterSize = CGSize.init(width: 16.0, height: 2.0)

}
