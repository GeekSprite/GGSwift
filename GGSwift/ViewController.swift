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
        for _ in 0..<10 {
            let item = JFFliterItem()
            item.title = "交易类型"
            item.key = "tradeType"
            item.type = .Picker
            item.sectionSelect = arc4random() % 2 == 0
//            item.subTitles = ["贴现","买入","转让"]
//            item.enableMultipleChoose = false
            items.append(item)
        }
        let fliter = JFFliter.init(fliterItems: items) { (dic) in
            
        }
        
        fliter.showWithCompletion { 
            print("======")
        }
    }

}

