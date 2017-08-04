//
//  FontUtil.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/2.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class FontUtil: NSObject {
    
    public class func fontSize(size: CGFloat) -> CGFloat {
        
        let JFFliter_kWidth = UIScreen.main.bounds.size.width
        let kheight = UIScreen.main.bounds.size.height
        
        if JFFliter_kWidth == 320.0 && kheight < 568.0 {
            return size * 320.0/375.0
        }else if JFFliter_kWidth == 320.0 {
            return size * 320.0/375.0
        }else if JFFliter_kWidth == 375.0 {
            return size
        }else if JFFliter_kWidth == 414.0 {
            return size * 414.0/375.0
        }
        return size
    }
}
