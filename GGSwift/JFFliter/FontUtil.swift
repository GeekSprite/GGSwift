//
//  FontUtil.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/2.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class FontUtil: NSObject {

    /**
     *  获取当前device screen实际需要的font size
     *
     *  @param size 设计师在4.7inch标的font size
     *
     *  @return 实际需要的font size，根据屏幕宽度比例缩放,用pt换算
     */
    public class func fontSize(size: CGFloat) -> CGFloat {
        
        let kWidth = UIScreen.main.bounds.size.width
        let kheight = UIScreen.main.bounds.size.height
        
        if kWidth == 320.0 && kheight < 568.0 {
            return size * 320.0/375.0
        }else if kWidth == 320.0 {
            return size * 320.0/375.0
        }else if kWidth == 375.0 {
            return size
        }else if kWidth == 414.0 {
            return size * 414.0/375.0
        }
        return size
    }
}
