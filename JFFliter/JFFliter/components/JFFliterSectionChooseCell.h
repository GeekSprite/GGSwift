//
//  JFFliterSectionChooseCell.h
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/25.
//  Copyright © 2017年 jf. All rights reserved.
//

#import "JFFliterSectionCell.h"

@class JFFliterSectionChooseCell;
@class JFFliterItemCell;
@protocol JFFliterSectionChooseCellDataSource <NSObject>

@optional
- (__kindof JFFliterItemCell *)itemCellForChooseCell:(JFFliterSectionChooseCell *)chooseCell atRow:(NSInteger)row;
- (CGFloat)heightForItemCellInSection:(NSInteger)section;

@end

@interface JFFliterSectionChooseCell : JFFliterSectionCell

@property (nonatomic, weak) id<JFFliterSectionChooseCellDataSource> dataSource;

- (__kindof JFFliterItemCell *)dequeueReusableItemCellForIndexpath:(NSIndexPath *)path;
- (void)registerItemCellClass:(Class)aClass;

@end
