//
//  JFFliterSectionCell.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterSectionCell: UITableViewCell {
    
    deinit {
        print(#function)
    }
    
    // MARK: Life Circle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.didInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.JFFliter_width > 0.00001 else {
            return
        }
        self.didLayoutSubviews()
    }

    // MARK: Public Methods
    open func didInit() {
        self.backgroundColor = UIColor.clear
        guard JFFliterAppearceManager.shared.separateLineStyle != .None else {
            return
        }
        self.sepLine.backgroundColor = JFFliterAppearceManager.shared.separateLineStyle == .Black ? UIColor.JFFliter_colorWithHexString(hex: "#030404") : UIColor.JFFliter_colorWithHexString(hex: "#fcfbfb")
        self.addSubview(self.sepLine)
    }
    
    open func didLayoutSubviews() {
        guard JFFliterAppearceManager.shared.separateLineStyle != .None else {
            return
        }
        let sepHeight : CGFloat = 1.0
        self.sepLine.frame = CGRect.init(x: 0, y: self.JFFliter_height - sepHeight, width: self.JFFliter_width, height: sepHeight)
    }
    
    // MARK: Public Property
    var cellItem : JFFliterItem? {
        didSet {
    
        }
    }
    
    // MARK: Private Property
    private lazy var sepLine: UIView = {
        let line = UIView()
        return line
    }()
}
