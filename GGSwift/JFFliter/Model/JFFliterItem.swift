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
    var subTitles : [String]? {
        didSet {
            var dic: [String:Bool] = [:]
            if let subTitles = self.subTitles {
                for index in 0..<Int(subTitles.count) {
                    dic[subTitles[index]] = false
                }
                self.resetDic = dic
                self.chosenDic = dic
            }
        }
    }
    var subTitlesReferences : [String]?
    var allChosenReferences : String?
    var enableMultipleChoose = true {
        didSet {
            if self.enableMultipleChoose {
                self.isAllChosen = true
            }else {
                self.isAllChosen = false
            }
        }
    }
    var isAllChosen = true {
        didSet {
            if self.isAllChosen {
                self.chosenDic = self.resetDic
            }
        }
    }

    // MARK: 选择器
    var sectionSelect = true
    var pickerType = JFFliterPickerType.TextField {
        didSet {
            switch self.pickerType {
            case .TextField:
                self.leftMaxNumber = NSNumber.init(value: 366)
                self.rightMaxNumber = NSNumber.init(value: 366)
            case .DatePicker:
                self.leftMinDate = self.dateByAddMonths(date: Date(), months: -12)
                self.leftMaxDate = Date()
                self.rightMinDate = Date()
                self.rightMaxDate = self.dateByAddMonths(date: Date(), months: 12)
            case .AddressPicker:
                self.sectionSelect = false
                break
            }
        }
    }
    var leftMinDate : Date?
    var leftMaxDate : Date?
    var rightMinDate : Date?
    var rightMaxDate : Date?
    
    var leftMaxNumber : NSNumber?
    var rightMaxNumber : NSNumber?
    
    var leftPlaceHolder : String?
    var rightPlaceHolder: String?
    
    var leftValue : String?
    var rightValue : String?
    var shouldReset  = false
    
    // MARK: 私有
    
    private var chosenDic : [String:Bool]?
    private var resetDic : [String:Bool]?
    
    // MARK: 方法
    
    func setChosen(chosen:Bool, key: String) {
        guard self.type == .ChooseButton else {
            return
        }
        
        if let chosenDic = self.chosenDic {
            if chosenDic.keys.contains(key) {
                self.chosenDic![key] = chosen
            }
        }

    }
    
    func isChosen(key:String) -> Bool {
        guard self.type == .ChooseButton else {
            return false
        }
        var isChosen = false
        if let chosenDic = self.chosenDic {
            if chosenDic.keys.contains(key) {
                isChosen = chosenDic[key]!
            }
        }
        return isChosen
    }
    
    func reset() {
        switch self.type {
        case .ChooseButton:
            self.isAllChosen = true
        case .Picker:
            self.shouldReset = true
        }
    }
    
    private func dateByAddMonths(date: Date,months: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: months, to: date)!
    }
    
}
