//
//  JFFliterSectionCell.h
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/21.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JFFliterItem;
@interface JFFliterSectionCell : UITableViewCell

@property (nonatomic, strong) JFFliterItem *cellItem;
//don't call directly, for override use
- (void)didInit; //init之后的操作
- (void)didLayoutSubviews;//布局完成并且frame设置完成

@end
