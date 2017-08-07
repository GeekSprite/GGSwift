//
//  JFFliter.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

let JFFliter_kWidth = UIScreen.main.bounds.size.width
let JFFliter_kHeight = UIScreen.main.bounds.size.height


fileprivate let kFliterSectionChooseCellID = "kFliterSectionChooseCellID"
fileprivate let kFliterSectionPickerCellID = "kFliterSectionPickerCellID"
fileprivate let kFliterSectionCellHeaderID = "kFliterSectionCellHeaderID"

enum JFFliterSlideFrom {
    case Left
    case Right
}

@objc
protocol JFFliterViewDelegate : NSObjectProtocol {
    @objc(shouldConfirmWithResult:)
    optional func shouldConfirmWithResult(result:[String:[String]]) -> Bool
}

protocol JFFliterViewDataSource : NSObjectProtocol {
    
}

class JFFliter: UIView {
    
    // MARK: Private Property
    
    fileprivate var isKeyboardVisible = false
    fileprivate var customizedHeader = false
    fileprivate var itemCellClass : AnyClass?
    fileprivate var fliterItems : [JFFliterItem] = []
    
    fileprivate var completionHandler : (([String:[String]])->Void)?
    
    fileprivate var comtainerWindow : UIWindow?
    
    // MARK: Configuration
    var alphaDuration = 0.1
    var slideDuration = 0.3
    var slideFrom : JFFliterSlideFrom = .Right
    var showStatusBar : Bool = false
    var shadowWidth : CGFloat = 116.0
    var bottomHeight : CGFloat = 43.0
    var shadowColor : UIColor = UIColor.JFFliter_colorWithHexString(hex: "#D7D7D7", alpha: 0.1)
    var contentColor : UIColor = UIColor.JFFliter_colorWithHexString(hex: "#1C1E21", alpha: 1.0)
    
    // MARK: Property
    weak var dataSource : JFFliterViewDataSource?
    weak var delegate   : JFFliterViewDelegate?
    
    lazy var resetButton : UIButton = {
        let resetButton = UIButton.init(type: .custom)
        resetButton.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "#3A3F46")
        resetButton.setTitle("重置", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 15))
        resetButton.setTitleColor(UIColor.JFFliter_colorWithHexString(hex: "#D7D7D7"), for: .normal)
        resetButton.addTarget(self, action: #selector(resetClick(sender:)), for: .touchUpInside)
        return resetButton
        
    }()
    lazy var confirmButton : UIButton = {
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.backgroundColor = UIColor.JFFliter_colorWithHexString(hex: "#ED8D03")
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtil.fontSize(size: 15))
        confirmButton.setTitleColor(UIColor.JFFliter_colorWithHexString(hex: "#FFFFFF"), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmClick(sender:)), for: .touchUpInside)
        return confirmButton
    }()

    
    // MARK: Lazy Setter
    fileprivate lazy var tableViewContainer : UIView = {
        let container = UIView()
        return container
    }()
    
    fileprivate lazy var fliterTableView : UITableView = {
        let t = UITableView.init(frame: CGRect.zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.bounces = false
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = false
        t.keyboardDismissMode = .onDrag
        t.register(JFFliterSectionChooseCell.self, forCellReuseIdentifier: kFliterSectionChooseCellID)
        t.register(JFFliterSectionPickerCell.self, forCellReuseIdentifier: kFliterSectionPickerCellID)
        t.register(JFFliterSectionHeader.self, forHeaderFooterViewReuseIdentifier: kFliterSectionCellHeaderID)
        
        return t
    }()
    
    fileprivate lazy var shadowView : UIView = {
        let shadowView = UIView()
        return shadowView
    }()
    
    // MARK: Life Cricle
    deinit {
         print(#function)
        let center = NotificationCenter.default
        center.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        center.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    class func filterView(fliterItems: [JFFliterItem], completion:(([String:[String]])->Void)?) -> JFFliter {
        return JFFliter.init(fliterItems: fliterItems, completion: completion)
    }
    
    convenience init(fliterItems: [JFFliterItem],completion: (([String:[String]])->Void)?) {
        self.init(frame: CGRect.zero)
        self.fliterItems = fliterItems
        self.completionHandler = completion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitInit()
    }
    
    // MARK: Public Methods
    func showWithCompletion(completion: (()->Void)?) {
        guard self.superview == nil else {
            return
        }
        self.addToWindow()
        self.showAnimationWithCompletion { _ in
            if let completion = completion {
                completion()
            }
        }
    }
    
    func hide() {
        guard !self.keyboardIsVisible() else {
            self.endEditing(true)
            return
        }
        self.hideAnimationWithCompletion { (_) in
            self.removeFromWindow()
        }
    }
    
    // MARK: Configure Views
    private func commitInit() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardWillHide, object: nil)
        self.isKeyboardVisible = false
        self.customizedHeader = false
        self.configureViews()
    }
    
    private func configureViews() {
        self.frame = CGRect.init(x: 0, y: 0, width: JFFliter_kWidth, height: JFFliter_kHeight)
        self.shadowView.frame = self.bounds
        let containerX = self.slideFrom == .Right ? JFFliter_kWidth : JFFliter_kWidth * (-1.0)
        let tableViewX = self.slideFrom == .Right ? 0 : self.shadowWidth
        let tableViewY = self.showStatusBar ? UIApplication.shared.statusBarFrame.size.height : 0
        
        self.tableViewContainer.frame = CGRect.init(x: containerX, y: 0, width: JFFliter_kWidth, height: JFFliter_kHeight)
        self.tableViewContainer.backgroundColor = self.contentColor
        
        self.fliterTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: self.bottomHeight, right: 0)
    
        self.fliterTableView.frame = CGRect.init(x: tableViewX, y: tableViewY, width: (JFFliter_kWidth - self.shadowWidth), height: JFFliter_kHeight - tableViewY)
        
        self.resetButton.frame = CGRect.init(x: self.fliterTableView.JFFliter_x, y: self.tableViewContainer.JFFliter_height - self.bottomHeight, width: self.fliterTableView.JFFliter_width / 2.0, height: self.bottomHeight)
        
        self.confirmButton.frame = CGRect.init(x: self.fliterTableView.JFFliter_x + self.resetButton.JFFliter_width, y: self.tableViewContainer.JFFliter_height - self.bottomHeight, width: self.fliterTableView.JFFliter_width / 2.0, height: self.bottomHeight)
        
        self.fliterTableView.backgroundColor = self.contentColor
        self.tableViewContainer.addSubview(self.fliterTableView)
        self.tableViewContainer.addSubview(self.resetButton)
        self.tableViewContainer.addSubview(self.confirmButton)
    }
    
    // MARK: Private Methods
    private func addToWindow() {
        guard self.superview == nil else {
            return
        }
        
        self.comtainerWindow = UIWindow.init(frame: UIScreen.main.bounds)
        self.comtainerWindow?.windowLevel = self.showStatusBar ? UIWindowLevelNormal : UIWindowLevelAlert
        self.addSubview(self.shadowView)
        self.addSubview(self.tableViewContainer)
        self.comtainerWindow?.addSubview(self)
        self.comtainerWindow?.makeKeyAndVisible()
    }
    
    private func removeFromWindow() {
        guard self.superview != nil else {
            return
        }
        
        self.removeFromSuperview()
        self.comtainerWindow = nil
        print(#function)
    }
    
   private func showAnimationWithCompletion(completion: ((Bool) -> Void)? ) {
        self.endEditing(true)
        let containerX = self.slideFrom == .Right ? self.shadowWidth : (-1.0) * self.shadowWidth

        UIView.animate(withDuration: slideDuration, animations: { 
            self.tableViewContainer.frame = CGRect.init(x: containerX, y: 0, width: JFFliter_kWidth, height: JFFliter_kHeight)
        }) { _ in
            UIView.animate(withDuration: self.alphaDuration, animations: { 
                self.shadowView.backgroundColor = self.shadowColor
            }, completion: { flag in
                if let completion = completion {
                    completion(flag)
                }
            })
        }
    }
    
    private func hideAnimationWithCompletion(completion: ((Bool) -> Void)?) {
        self.endEditing(true)
        let containerX = self.slideFrom == .Right ? JFFliter_kWidth : -JFFliter_kWidth
        
        UIView.animate(withDuration: alphaDuration, animations: { 
            self.shadowView.backgroundColor = UIColor.clear
        }) { (flag) in
            UIView.animate(withDuration: self.slideDuration, animations: { 
                self.tableViewContainer.frame = CGRect.init(x: containerX, y: 0, width: JFFliter_kWidth, height: JFFliter_kHeight)
            }, completion: { (flag) in
                if let completion = completion {
                    completion(flag)
                }
            })
        }
    }

    func keyboardDidShow() {
        self.isKeyboardVisible = true
    }
    
    func keyboardDidHide() {
        self.isKeyboardVisible = false
    }
    
    func keyboardIsVisible() -> Bool {
        return self.isKeyboardVisible
    }
    
    fileprivate func calculateCellHeaderHeightFor(index: Int) -> CGFloat {
        guard index < self.fliterItems.count else {
            return 0.01
        }
        let item = self.fliterItems[index]
        if item.cacheHeaderHeight > 0 {
            return item.cacheHeaderHeight
        }
        var height: CGFloat = 0.0
        if false {
            
        }else {
            height += 2.0 * JFFliterAppearceManager.shared.sectionPaddingSize.height
            height += UIFont.systemFont(ofSize: FontUtil.fontSize(size: 11)).lineHeight
        }
        item.setValue(height, forKeyPath: "cacheHeaderHeight")
        return height
    }
    
    fileprivate func calculateCellHeightFor(index: Int) -> CGFloat {
        guard index < self.fliterItems.count else {
            return 0.01
        }
        let item = self.fliterItems[index]
        if item.cacheCellHeight > 0 {
            return item.cacheCellHeight
        }
        
        var height: CGFloat = 0.0
        if item.type == .Picker {
            height = JFFliterAppearceManager.shared.pickerHeight
        }else {
            let subButtonHeight = JFFliterAppearceManager.shared.subButtonHeight
            let lineCount: Int = Int(ceil(Double((item.subTitles?.count)! + (item.enableMultipleChoose ? 1 : 0)) / Double(JFFliterAppearceManager.shared.subButtonCount)))
            height += (CGFloat(lineCount) * subButtonHeight + CGFloat(lineCount - 1) * JFFliterAppearceManager.shared.sectionPaddingSize.height)
        }
        height += JFFliterAppearceManager.shared.sectionPaddingSize.height
        item.setValue(height, forKeyPath: "cacheCellHeight")
        return height;
    }

    // MARK: Target Action
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hide()
    }
    
    func resetClick(sender: UIButton) {
        for item in self.fliterItems {
            item.reset()
        }
        self.fliterTableView.reloadData()
    }
    
    func confirmClick(sender: UIButton) {
        var result = [String:[String]]()
        for item in self.fliterItems {
            if item.type == .ChooseButton {
                var itemArr = [String]()
                if item.isAllChosen && item.allChosenReferences != nil {
                    itemArr.append(item.allChosenReferences!)
                }else {
                    if let subtitles = item.subTitles {
                        for index in 0..<subtitles.count  {
                            let title = subtitles[index]
                            var itemValue = title
                            if let subTitlesReferences = item.subTitlesReferences,subTitlesReferences.count > index {
                                itemValue = subTitlesReferences[index]
                            }
                            if item.isAllChosen {
                                itemArr.append(itemValue)
                            }else if (item.isChosen(key: title)) {
                                itemArr.append(itemValue)
                            }
                        }
                    }
                }
                result[item.key] = itemArr
            }else {
                
                var itemArr = [String]()
                
                if item.leftValue != nil {
                    itemArr.append(item.leftValue!)
                }
                if item.rightValue != nil {
                    itemArr.append(item.rightValue!)
                }
                result[item.key] = itemArr
            }
        }
        
        guard let function = self.delegate?.shouldConfirmWithResult(result:) else {
            self.hide()
            if let handler = self.completionHandler {
                handler(result)
            }
            return
        }
        
        let flag = function(result)
        
        if flag {
            self.hide()
            if let handler = self.completionHandler {
                handler(result)
            }
        }else {
            print("shouldConfirmWithResult error")
        }
        
    }
}

extension JFFliter : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fliterItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.calculateCellHeightFor(index: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.calculateCellHeaderHeightFor(index: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = self.fliterItems[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: kFliterSectionCellHeaderID) as! JFFliterSectionHeader
        header.headerLabel.text = item.title
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.fliterItems[indexPath.section]
        var cell : JFFliterSectionCell
        if item.type == .ChooseButton {
            cell = tableView.dequeueReusableCell(withIdentifier: kFliterSectionChooseCellID) as! JFFliterSectionCell
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: kFliterSectionPickerCellID) as! JFFliterSectionCell
        }
        cell.selectionStyle = .none
        cell.cellItem = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hide()
    }

}


extension UIColor {
    
    public static func JFFliter_colorWithHexString(hex:String) -> UIColor! {
        return UIColor.JFFliter_colorWithHexString(hex: hex, alpha: 1.0)
    }
    
    public static func JFFliter_colorWithHexString(hex:String,alpha:Float) -> UIColor! {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.characters.count < 6 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }else if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if cString.characters.count != 6 {
            return UIColor.clear
        }
    
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
     
     return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
    }
}

extension UIView {
    var JFFliter_x: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var JFFliter_y: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var JFFliter_width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.size.width
        }
    }
    
    var JFFliter_height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.size.height
        }
    }
    
    var JFFliter_centerX: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.size.height
        }
    }
}
