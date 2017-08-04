//
//  JFSelectAddressPickerView.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/4.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

private let PROVINCE_COMPONENT  = 0
private let CITY_COMPONENT      = 1
private let DISTRICT_COMPONENT  = 2

class JFSelectAddressPickerView: UIView {

    fileprivate var datas: [[String:AnyObject]] = []
    fileprivate var citys: [[String:String]] = []
    
    var callBack: ((String?,String?)->Void)?
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        picker.selectRow(0, inComponent: 0, animated: true)
        return picker
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        var data: Data?
        
        do {
            let path = Bundle.main.path(forResource: "china_provinces_cities", ofType: ".json")
            try data = Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        } catch {
            return
        }

        self.datas = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String:AnyObject]]
        
        self.citys = self.datas[0]["cities"] as! [[String : String]]
        
        self.frame = CGRect.init(x: 0, y: JFFliter_kHeight - (JFFliter_kHeight/3 + 40), width: JFFliter_kWidth, height: JFFliter_kHeight/3 + 40)
        self.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "232529")

        self.pickerView.frame = CGRect.init(x: 0, y: 40, width: JFFliter_kWidth, height: JFFliter_kHeight / 3.0)
        self.addSubview(self.pickerView)

        let buttonView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: JFFliter_kWidth, height: 40))
        self.addSubview(buttonView)

        let title = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: JFFliter_kWidth, height: 40))
        title.text = "请选择城市"
        title.textColor = UIColor.JFFliter_colorWithHexString(hex: "D7D7D7")
        title.font = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 14))
        title.textAlignment = .center
        buttonView.addSubview(title)
        
        let leftButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        leftButton.setTitle("取消", for: .normal)
        leftButton.titleLabel?.font = title.font
        leftButton.setTitleColor(UIColor.JFFliter_colorWithHexString(hex: "D7D7D7"), for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        
        buttonView.addSubview(leftButton)
        
        let rightButton = UIButton.init(frame: CGRect.init(x: JFFliter_kWidth - 100, y: 0, width: 100, height: 40))
        rightButton.setTitle("确定", for: .normal)
        rightButton.titleLabel?.font = title.font
        rightButton.setTitleColor(UIColor.JFFliter_colorWithHexString(hex: "D7D7D7"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        
        buttonView.addSubview(rightButton)

        
        let topLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: JFFliter_kWidth, height: 0.5))
        let bottomLine = UIView.init(frame: CGRect.init(x: 0, y: 40, width: JFFliter_kWidth, height: 0.5))
        topLine.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "020303")
        bottomLine.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "020303")
        self.addSubview(topLine)
        self.addSubview(bottomLine)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func leftButtonClick() {
        if let block = self.callBack {
            block(nil,nil)
        }
    }
    
    func rightButtonClick() {
        let provinceIndex = pickerView.selectedRow(inComponent: PROVINCE_COMPONENT)
        let cityIndex = pickerView.selectedRow(inComponent: CITY_COMPONENT)
        
        let province = self.datas[provinceIndex]["name"]
        let city = self.citys[cityIndex]["name"]
        
        if let block = self.callBack {
            block(province as? String,city)
        }
    }


}

extension JFSelectAddressPickerView : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == PROVINCE_COMPONENT {
            return self.datas.count
        }else {
            return self.citys.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == PROVINCE_COMPONENT {
            return self.datas[row]["name"] as? String
        }else {
            return self.citys[row]["name"]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == PROVINCE_COMPONENT {
            self.citys = self.datas[row]["cities"] as! [[String : String]]
            pickerView.selectRow(0, inComponent: CITY_COMPONENT, animated: true)
            pickerView.reloadComponent(CITY_COMPONENT)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return JFFliter_width / 3.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for singleLine in pickerView.subviews {
            if singleLine.JFFliter_height < 1.0 {
                singleLine.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "1C1E21")
            }
        }
        
        let myView = UILabel()
        myView.textAlignment = .center
        myView.font = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 14))
        myView.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "232529")
        myView.textColor = UIColor.JFFliter_colorWithHexString(hex: "D7D7D7")
        
        if component == PROVINCE_COMPONENT {
            myView.text = self.datas[row]["name"] as? String
        }else {
            myView.text = self.citys[row]["name"]
        }
        return myView
    }
}
            
