//
//  JFFliterSectionHeader.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterSectionHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.didInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.width > 0.00001 else {
            return
        }
        self.didLayoutSubviews()
    }
    
    open func didInit() {
        self.backgroundColor = UIColor.clear
        self.headerView.addSubview(self.headerLabel)
        self.addSubview(self.headerView)

    }
    
    open func didLayoutSubviews() {
        self.headerLabel.sizeToFit()
        self.headerView.frame = self.bounds
        self.headerLabel.frame.origin = CGPoint.init(x: JFFliterAppearceManager.shared.sectionPaddingSize.width, y: JFFliterAppearceManager.shared.sectionPaddingSize.height)
        
    }

    open lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 11))
        label.textColor = UIColor.colorWithHexString(hex: "#828282")
        return label
    }()
    
    open lazy var headerView: UIView = {
        return UIView()
    }()

}
