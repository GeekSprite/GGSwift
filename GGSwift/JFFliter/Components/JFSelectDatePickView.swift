//
//  JFSelectDatePickView.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/4.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFSelectDatePickView: UIView {

    var title: String? {
        didSet {
            if let title = self.title {
                self.titleButton.setTitle(title, for: .normal)
            }
        }
    }
    
    var callBack: ((String?,Date?) -> Void)?

    @IBOutlet weak var myPickerView: UIDatePicker!
    
    @IBOutlet weak fileprivate var titleButton: UIButton!
    
    class func instanceView() -> JFSelectDatePickView {
        let datePicker = Bundle.main.loadNibNamed("JFSelectDatePickView", owner: self, options: nil)?.first as! JFSelectDatePickView
        return datePicker
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myPickerView.datePickerMode = .date
        self.myPickerView.maximumDate = Date()
        self.myPickerView.locale = Locale.init(identifier: "zh_CN")
        self.myPickerView.setValue(UIColor.JFFliter_colorWithHexString(hex: "#D7D7D7"), forKeyPath: "textColor")
        self.myPickerView.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "#232529")
    }
    
    @IBAction fileprivate func confirmClick(_ sender: Any) {
        if let block = callBack {
            let date = self.myPickerView.date
            let fmt = DateFormatter()
            fmt.dateFormat = JFFliterDateFormter
            let str = fmt.string(from: date)
            block(str,date)
        }
    }
    @IBAction func cancelClick(_ sender: Any) {
        if let block = callBack {
            block(nil,nil)
        }
    }
}
