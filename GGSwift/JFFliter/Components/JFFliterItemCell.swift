//
//  JFFliterItemCell.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterItemCell: UICollectionViewCell {
    
    open lazy var chooseButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = JFFliterAppearceManager.shared.subButtonFont
        button.backgroundColor = JFFliterAppearceManager.shared.subButtonBackgroundColor
        button.setTitleColor(JFFliterAppearceManager.shared.subButtonTextNormalColor, for: .normal)
        button.setTitleColor(JFFliterAppearceManager.shared.subButtonTextChoodenColor, for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var chooseImgView: UIImageView = {
        let imgView = UIImageView()
        let path = Bundle.main.path(forResource: "gouxuan", ofType: "png")
        imgView.image = UIImage.init(contentsOfFile: path!)
        return imgView
    }()
    
    open var chosen: Bool? {
        didSet{
            self.chooseButton.isSelected = self.chosen!
            self.chooseImgView.isHidden = !(self.chosen!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.didInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.width > 0.00001 {
            self.didLayoutSubviews()
        }
    }
    func didInit() {
        self.addSubview(self.chooseButton)
        self.addSubview(self.chooseImgView)
    }
    
    func didLayoutSubviews() {
        self.chooseButton.frame = self.bounds
        self.chooseImgView.frame = CGRect.init(x: self.width - 20.0, y: self.height - 13.0, width: 20.0, height: 13.0)
    }
}
