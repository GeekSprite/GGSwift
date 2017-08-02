//
//  JFFliterSectionChooseCell.swift
//  GGSwift
//
//  Created by geeksprite on 2017/8/1.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

import UIKit

class JFFliterSectionChooseCell: JFFliterSectionCell {

    override var cellItem: JFFliterItem? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func didInit() {
        super.didInit()
        self.addSubview(self.collectionView)
    }
    
    override func didLayoutSubviews() {
        super.didLayoutSubviews()
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = JFFliterAppearceManager.shared.sectionPaddingSize.height
        layout.minimumInteritemSpacing = JFFliterAppearceManager.shared.sectionPaddingSize.width
        self.collectionView.frame = CGRect.init(x: JFFliterAppearceManager.shared.sectionPaddingSize.width, y: 0, width: self.width - JFFliterAppearceManager.shared.sectionPaddingSize.width * 2.0, height: self.height - JFFliterAppearceManager.shared.sectionPaddingSize.height)
    }
    
    fileprivate let kFliterItemCellID = "kFliterItemCellID"
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(JFFliterItemCell.self, forCellWithReuseIdentifier: self.kFliterItemCellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
}

extension JFFliterSectionChooseCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.cellItem?.subTitles?.count {
            return count + (self.cellItem!.enableMultipleChoose ? 1 : 0)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((self.width - CGFloat(JFFliterAppearceManager.shared.subButtonCount + 1) * JFFliterAppearceManager.shared.sectionPaddingSize.width) / CGFloat(JFFliterAppearceManager.shared.subButtonCount))
        let height = JFFliterAppearceManager.shared.subButtonHeight
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JFFliterItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.kFliterItemCellID, for: indexPath) as! JFFliterItemCell
        if let enableMultipleChoose = self.cellItem?.enableMultipleChoose, enableMultipleChoose && indexPath.row == 0 {
            cell.chooseButton.setTitle(JFFliterAllChosenKey, for: .normal)
            cell.chosen = self.cellItem?.isAllChosen
            return cell
        }
        
        let title = self.cellItem!.subTitles?[indexPath.row - (self.cellItem!.enableMultipleChoose ? 1 : 0)]
        cell.chooseButton.setTitle(title, for: .normal)
        cell.chosen = self.cellItem!.isChosen(key: title!)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.cellItem!.enableMultipleChoose {
            let title = (self.cellItem!.subTitles)![indexPath.row]
            if self.cellItem!.isChosen(key: title) {
                var shouldReverse = false
                for key in (self.cellItem!.subTitles)! {
                    if key == title {
                        continue
                    }
                    if self.cellItem!.isChosen(key: key) {
                        shouldReverse = true
                        break
                    }
                }
                if shouldReverse {
                    self.cellItem!.setChosen(chosen: false, key: title)
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }else {
                var prePath: IndexPath?
                for indedx in 0..<(self.cellItem!.subTitles?.count)! {
                    if let key = self.cellItem!.subTitles?[indedx], self.cellItem!.isChosen(key: key) {
                        self.cellItem!.setChosen(chosen: false, key: key)
                        prePath = IndexPath.init(row: indedx, section: 0)
                        break;
                    }
                }
                self.cellItem!.setChosen(chosen: true, key: title)
                if let prePath = prePath {
                    collectionView.reloadItems(at: [indexPath, prePath])
                }else {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }else {
            if indexPath.row == 0 {
                if self.cellItem!.isAllChosen {
                    return
                }
                self.cellItem!.isAllChosen = true
                collectionView.reloadData()
            }else {
                let title = self.cellItem!.subTitles?[indexPath.row - 1]
                if self.cellItem!.isChosen(key: title!) {
                    var shouldReverse = false
                    for key in (self.cellItem!.subTitles)! {
                        if key == title {
                            continue
                        }
                        if self.cellItem!.isChosen(key: key) {
                            shouldReverse = true
                            break
                        }
                    }
                    if shouldReverse {
                        self.cellItem!.setChosen(chosen: false, key: title!)
                        collectionView.reloadItems(at: [indexPath])
                    }
                }else {
                    var allChosenPath: IndexPath?
                    if self.cellItem!.isAllChosen {
                        self.cellItem!.isAllChosen = false
                        allChosenPath = IndexPath.init(row: 0, section: 0)
                    }
                    self.cellItem!.setChosen(chosen: true, key: title!)
                        var shouldReset = true
                    for key in (self.cellItem!.subTitles)! {
                        shouldReset = self.cellItem!.isChosen(key: key)
                        if !shouldReset {
                            break
                        }
                    }
                    if shouldReset {
                        self.cellItem!.isAllChosen = true
                        collectionView.reloadData()
                    }else {
                        var items = [indexPath]
                        if let path = allChosenPath {
                            items.append(path)
                        }
                        collectionView.reloadItems(at: items)
                    }
                }
            }
    
        }

    }
}
