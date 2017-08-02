//
//  JFFliterSectionPickerCell.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterSectionPickerCell: JFFliterSectionCell {

    fileprivate lazy var leftTF: UITextField = {
        let tf = UITextField()
        tf.textColor = JFFliterAppearceManager.shared.pickerTextColor
        tf.backgroundColor = JFFliterAppearceManager.shared.pickerBackgroundColor
        tf.borderStyle = .none
        tf.textAlignment = .center
        tf.font = JFFliterAppearceManager.shared.pickerTextFont
        tf.delegate = self
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    fileprivate lazy var rightTF: UITextField = {
        let tf = UITextField()
        tf.textColor = JFFliterAppearceManager.shared.pickerTextColor
        tf.backgroundColor = JFFliterAppearceManager.shared.pickerBackgroundColor
        tf.borderStyle = .none
        tf.textAlignment = .center
        tf.font = JFFliterAppearceManager.shared.pickerTextFont
        tf.delegate = self
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    fileprivate lazy var pickerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = JFFliterAppearceManager.shared.pickerContainerColor
        return view
    }()
    
    fileprivate lazy var indicateView: UIView = {
        let view = UIView()
        view.backgroundColor = JFFliterAppearceManager.shared.pickerIndicaterColor
        return view
    }()
    
    override func didInit() {
        super.didInit()
        self.addSubview(self.pickerContainerView)
        self.pickerContainerView.addSubview(self.leftTF)
        self.pickerContainerView.addSubview(self.indicateView)
        self.pickerContainerView.addSubview(self.rightTF)
    }
    
    override func didLayoutSubviews() {
        super.didLayoutSubviews()
        self.pickerContainerView.frame = CGRect.init(x: JFFliterAppearceManager.shared.sectionPaddingSize.width, y: 0, width: self.width - 2.0 * (JFFliterAppearceManager.shared.sectionPaddingSize.width), height: self.height - JFFliterAppearceManager.shared.sectionPaddingSize.height)
    
        self.indicateView.frame = CGRect.init(origin: CGPoint.init(x: (self.pickerContainerView.width - JFFliterAppearceManager.shared.pickerIndicaterSize.width)/2.0 , y: (self.pickerContainerView.height - JFFliterAppearceManager.shared.pickerIndicaterSize.height)/2.0), size: self.cellItem!.sectionSelect ? JFFliterAppearceManager.shared.pickerIndicaterSize : CGSize.zero)
        
        self.leftTF.frame = CGRect.init(x: JFFliterAppearceManager.shared.pickerInsets.left, y: JFFliterAppearceManager.shared.pickerInsets.top, width: self.cellItem!.sectionSelect ? (self.indicateView.frame.minX - 6.0 - JFFliterAppearceManager.shared.pickerInsets.left) : (self.pickerContainerView.width - JFFliterAppearceManager.shared.pickerInsets.left + JFFliterAppearceManager.shared.pickerInsets.right), height: self.pickerContainerView.height - JFFliterAppearceManager.shared.pickerInsets.top + JFFliterAppearceManager.shared.pickerInsets.bottom)
        
        self.rightTF.frame = CGRect.init(x: self.indicateView.frame.maxX + 6, y: self.leftTF.y, width: self.cellItem!.sectionSelect ? self.leftTF.width : 0 , height: self.leftTF.height)
    
        
        
    }
    
}

extension JFFliterSectionPickerCell : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let pickerType = self.cellItem?.pickerType, pickerType == .TextField else {
            return false
        }

        if let toBeString = textField.text?.replacingCharacters(in: (textField.text?.range(from: range))!, with: string) {
            if toBeString.isEmpty {
                return true
            }
        
            if let doubleValue = Double(toBeString) {
                if let maxValue = textField.isEqual(self.leftTF) ? self.cellItem!.leftMaxNumber : self.cellItem!.rightMaxNumber {
                    if maxValue.doubleValue.isLess(than: doubleValue) || toBeString.characters.count > (String.init(format: "%d", Int(doubleValue)).characters.count + 3) {
                        return false
                    }
                }
            }else {
                return false
            }
            
            
            return true
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(self.leftTF) {
            self.cellItem!.leftValue = textField.text
        }else {
            self.cellItem?.rightValue = textField.text
        }
    }
}

//NSRange转化为range
extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
