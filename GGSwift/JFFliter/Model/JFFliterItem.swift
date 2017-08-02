//
//  JFFliterItem.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

let JFFliterAllChosenKey = "全部"
let JFFliterDateFormter = "yyyy-MM-dd"

enum JFFliterPickerType {
    case TextField
    case DatePicker
    case AddressPicker
}

enum JFFliterItemType {
    case ChooseButton
    case Picker
}

class JFFliterItem: NSObject {

    // MARK: 通用属性
    var title : String!
    var key : String!
    var type = JFFliterItemType.ChooseButton
    {
        didSet {
            switch type {
            case .ChooseButton:
                self.enableMultipleChoose = true
                self.isAllChosen = true
            case .Picker:
                self.sectionSelect = true
                self.pickerType = .TextField
                self.shouldReset = false
            }
        }
    }
    var cacheCellHeight : CGFloat = -1.0
    var cacheHeaderHeight: CGFloat = -1.0
    
    // MARK: 多选按钮
    var subTitles : [String]?
    var subTitlesReferences : [String]?
    var allChosenReferences : String?
    var enableMultipleChoose = true
    var isAllChosen = true

    // MARK: 选择器
    var sectionSelect = true
    var pickerType = JFFliterPickerType.TextField
    var leftMinDate : NSDate?
    var leftMaxDate : NSDate?
    var rightMinDate : NSDate?
    var rightMaxDate : NSDate?
    
    var leftMaxNumber : NSNumber?
    var rightMaxNumber : NSNumber?
    
    var leftPlaceHolder : String?
    var rightPlaceHolder: String?
    
    var leftValue : String?
    var rightValue : String?
    var shouldReset  = false
    
    // MARK: 私有
    
    private var chosenDic : [String:NSObject]?
    private var resetDic : [String:NSObject]?
    
    // MARK: 方法
    
    func setChosen(chosen:Bool, key: String) {
        
    }
    
    func isChosen(key:String) -> Bool {
     
        return false
    }
    
    func reset() {
        
    }
    
    
    
}
