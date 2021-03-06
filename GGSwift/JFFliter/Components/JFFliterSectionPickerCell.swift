//
//  JFFliterSectionPickerCell.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterSectionPickerCell: JFFliterSectionCell {

    // MARK: Properties
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
    
    fileprivate lazy var leftDateInputView: JFSelectDatePickView = {
        let picker = JFSelectDatePickView.instanceView()
        return picker
    }()
    
    fileprivate lazy var rightDateInputView: JFSelectDatePickView = {
        let picker = JFSelectDatePickView.instanceView()
        return picker
    }()
    
    fileprivate lazy var leftAddressInputView: JFSelectAddressPickerView = {
        return JFSelectAddressPickerView()
    }()
    
    fileprivate lazy var rightAddressInputView: JFSelectAddressPickerView = {
        return JFSelectAddressPickerView()
    }()
    
    // MARK: Override Methods
    override var cellItem: JFFliterItem? {
        didSet{
            guard cellItem != nil else {
                return
            }
            switch cellItem!.pickerType {
            case .DatePicker:
                self.wordWhenRunloopIdel {                    
                    self.leftDateInputView.myPickerView.minimumDate = self.cellItem?.leftMinDate
                    self.leftDateInputView.myPickerView.maximumDate = self.cellItem?.leftMaxDate
                    self.rightDateInputView.myPickerView.minimumDate = self.cellItem?.rightMinDate
                    self.rightDateInputView.myPickerView.maximumDate = self.cellItem?.rightMaxDate
                    self.leftTF.inputView = self.leftDateInputView
                    self.rightTF.inputView = self.rightDateInputView
                    self.leftDateInputView.callBack = self.datePickerBlock(textField: self.leftTF)
                    self.rightDateInputView.callBack = self.datePickerBlock(textField: self.rightTF)
                }
            case .AddressPicker:
                self.wordWhenRunloopIdel {
                    self.leftTF.inputView = self.leftAddressInputView
                    self.rightTF.inputView = self.rightAddressInputView
                    self.leftAddressInputView.callBack = self.addressPickerBlock(textField: self.leftTF)
                    self.rightAddressInputView.callBack = self.addressPickerBlock(textField: self.rightTF)
                }
                
            default:
                break
            }
            
            if let reset = self.cellItem?.shouldReset, reset {
                self.leftTF.text = nil
                self.rightTF.text = nil
            }
        }
    }
    
    override func didInit() {
        super.didInit()
        self.addSubview(self.pickerContainerView)
        self.pickerContainerView.addSubview(self.leftTF)
        self.pickerContainerView.addSubview(self.indicateView)
        self.pickerContainerView.addSubview(self.rightTF)
    }
    
    override func didLayoutSubviews() {
        super.didLayoutSubviews()
        self.pickerContainerView.frame = CGRect.init(x: JFFliterAppearceManager.shared.sectionPaddingSize.width, y: 0, width: self.JFFliter_width - 2.0 * (JFFliterAppearceManager.shared.sectionPaddingSize.width), height: self.JFFliter_height - JFFliterAppearceManager.shared.sectionPaddingSize.height)
    
        self.indicateView.frame = CGRect.init(origin: CGPoint.init(x: (self.pickerContainerView.JFFliter_width - JFFliterAppearceManager.shared.pickerIndicaterSize.width)/2.0 , y: (self.pickerContainerView.JFFliter_height - JFFliterAppearceManager.shared.pickerIndicaterSize.height)/2.0), size: (self.cellItem!.sectionSelect && self.cellItem!.pickerType != .AddressPicker) ? JFFliterAppearceManager.shared.pickerIndicaterSize : CGSize.zero)
        
        self.leftTF.frame = CGRect.init(x: JFFliterAppearceManager.shared.pickerInsets.left, y: JFFliterAppearceManager.shared.pickerInsets.top, width: (self.cellItem!.sectionSelect && self.cellItem!.pickerType != .AddressPicker) ? (self.indicateView.frame.minX - 6.0 - JFFliterAppearceManager.shared.pickerInsets.left) : (self.pickerContainerView.JFFliter_width - JFFliterAppearceManager.shared.pickerInsets.left + JFFliterAppearceManager.shared.pickerInsets.right), height: self.pickerContainerView.JFFliter_height - JFFliterAppearceManager.shared.pickerInsets.top + JFFliterAppearceManager.shared.pickerInsets.bottom)
        
        self.rightTF.frame = CGRect.init(x: self.indicateView.frame.maxX + 6, y: self.leftTF.JFFliter_y, width: (self.cellItem!.sectionSelect && self.cellItem!.pickerType != .AddressPicker) ? self.leftTF.JFFliter_width : 0 , height: self.leftTF.JFFliter_height)
    }
    
    // MARK: Private Methods
    private func wordWhenRunloopIdel(work:@escaping ()->Void) {
        let runloop = CFRunLoopGetCurrent()
        let runloopMode = CFRunLoopMode.defaultMode
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { (observer, activity) in
            work()
            CFRunLoopRemoveObserver(runloop, observer, runloopMode)
        }
        CFRunLoopAddObserver(runloop, observer, runloopMode)
    }
    
    private func datePickerBlock(textField: UITextField) -> (String?,Date?)->Void {
        func closure(str: String?, date: Date?) {
            if str != nil && date != nil {
                textField.text = str!
            }
            textField.resignFirstResponder()
        }
        return closure
    }
    
    private func addressPickerBlock(textField: UITextField) -> (String?,String?)->Void {
        func closure(str0: String?, str1: String?) {
            if str0 != nil && str1 != nil {
                textField.text = "\(str0!)  \(str1!)"
            }
            textField.resignFirstResponder()
        }
        return closure
    }
    
}

extension JFFliterSectionPickerCell : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let pickerType = self.cellItem?.pickerType, pickerType == .TextField else {
            return false
        }

        if let toBeString = textField.text?.replacingCharacters(in: (textField.text?.JFFliter_range(from: range))!, with: string) {
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

//MARK: NSRange转化为range
extension String {
    func JFFliter_range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
