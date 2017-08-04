//
//  ViewController.swift
//  GGSwift
//
//  Created by geeksprite on 2017/7/28.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var button : UIButton? = {
       let b = UIButton.init(type: .custom)
        b.backgroundColor = UIColor.red
        b.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        b.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.button!)
    }
    
    func buttonClick(sender : UIButton) {
        var items: [JFFliterItem] = []
        for index in 0..<10 {
            let item = JFFliterItem()
            item.title = "交易类型"
            item.key = "tradeType\(index)"
            if index % 2 == 0 {
                item.type = .Picker
                if arc4random() % 3 == 0 {
                    item.pickerType = .AddressPicker
                }else if arc4random() % 3 == 1 {
                    item.pickerType = .DatePicker
                }else {
                    item.pickerType = .TextField
                }
            }else {
                item.type = .ChooseButton
                item.subTitles = ["C","C++","JAVA","Objective-C","Swift","JavaScript"]
            }
            items.append(item)
        }
        let fliter = JFFliter.init(fliterItems: items) { (dic) in
            
        }
        fliter.delegate = self
        fliter.showWithCompletion { 
            print("======")
        }
    }

}

extension ViewController : JFFliterViewDelegate {
    func shouldConfirm(withResult result: [String : [String]]) -> Bool {
        print(result);
        return true
    }
}

