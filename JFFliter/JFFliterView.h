//
//  JFFliterView.h
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/20.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFFliterItem.h"
#import "JFFliterSectionChooseCell.h"

typedef NS_ENUM(NSInteger, JFFliterSlideFrom) {
    JFFliterSlideFromLeft,
    JFFliterSlideFromRight
};

@class JFFliterView;
@class JFFliterSectionHeader;
@protocol JFFliterViewDataSource <NSObject>

- (JFFliterSectionHeader *)sectionHeaderForFliterView:(JFFliterView *)fliterView inSection:(NSInteger)section;

@end

@protocol JFFliterViewDelegate <NSObject>

@optional
- (CGFloat)heightForHeaderViewInSection:(NSInteger)section;

- (BOOL)shouldConfirmWithResult:(NSDictionary *)result;

@end

@interface JFFliterView : UIView

@property (nonatomic, weak) id<JFFliterViewDataSource> dataSource;
@property (nonatomic, weak) id<JFFliterViewDelegate>   delegate;

@property (nonatomic, assign) JFFliterSlideFrom slideFrom;
@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, assign) CGFloat shadowWidth;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, weak) id<JFFliterSectionChooseCellDataSource> chooseCellDataSource;

+ (instancetype)fliterViewWithFliterItems:(NSArray *)fliterItems withCompletion:(void(^)(NSDictionary *result))completionHandler;
- (instancetype)initWithFliterItems:(NSArray *)fliterItems withCompletion:(void(^)(NSDictionary *result))completionHandler;

- (void)showWithCompletion:(dispatch_block_t)completionHandler;

- (__kindof JFFliterSectionHeader *)dequeueReusableHeaderView;
- (void)registerHeaderViewClass:(Class)aClass;

- (void)registerItemCellClass:(Class)aClass;
- (NSInteger)sectionForChooseCell:(JFFliterSectionChooseCell *)cell;

@end
