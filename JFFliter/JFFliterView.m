//
//  JFFliterView.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/20.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Masonry.h>
#import "JFFliterView.h"
#import "UIView+Common.h"
#import "JFFliterSectionHeader.h"
#import "JFFliterAppearanceManager.h"
#import "JFFliterSectionChooseCell.h"
#import "JFFliterSectionPickerCell.h"


static NSString *const kFliterSectionChooseCellID = @"kFliterSectionChooseCellID";
static NSString *const kFliterSectionPickerCellID = @"kFliterSectionPickerCellID";
static NSString *const kFliterSectionCellHeaderID = @"kFliterSectionCellHeaderID";

static NSTimeInterval alphaDuration = 0.1;
static NSTimeInterval slideDuration = 0.3;

@interface JFFliterView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL _keyboardIsVisible;
    BOOL _customizedHeader;
    Class _itemCellClass;
}

@property (nonatomic, strong) NSMutableArray *fliterItems;
@property (nonatomic, strong) UIView *tableViewContainer;
@property (nonatomic, strong) UITableView *fliterTableView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, copy) void(^completionHandler)(NSDictionary *);
@property (nonatomic, strong) UIWindow *window;

@end


@implementation JFFliterView

#pragma mark - Life Circle

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

+ (instancetype)fliterViewWithFliterItems:(NSArray *)fliterItems withCompletion:(void (^)(NSDictionary *))completionHandler{
    JFFliterView *fliterView = [[JFFliterView alloc] initWithFliterItems:fliterItems withCompletion:completionHandler];
    return fliterView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFliterItems:(NSArray *)fliterItems withCompletion:(void (^)(NSDictionary *))completionHandler{
    if (self = [super init]) {
        [self.fliterItems addObjectsFromArray:fliterItems];
        self.completionHandler = completionHandler;
    }
    return self;
}

#pragma mark - Public Methods
- (void)showWithCompletion:(dispatch_block_t)completionHandler {
    [self addToWindow];
    [self showAnimationWithCompletion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)registerHeaderViewClass:(Class)aClass {
    [self.fliterTableView registerClass:aClass forHeaderFooterViewReuseIdentifier:kFliterSectionCellHeaderID];
    _customizedHeader = YES;
}

- (JFFliterSectionHeader *)dequeueReusableHeaderView {
    return [self.fliterTableView dequeueReusableHeaderFooterViewWithIdentifier:kFliterSectionCellHeaderID];
}

- (void)registerItemCellClass:(Class)aClass {
    _itemCellClass = aClass;
}

- (NSInteger)sectionForChooseCell:(JFFliterSectionChooseCell *)cell {
    NSIndexPath *path = [self.fliterTableView indexPathForCell:cell];
    return path ? path.section : cell.tag;
}

#pragma mark - Private Methods

- (void)commonInit
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    _keyboardIsVisible = NO;
    _customizedHeader = NO;

    [self configureDefault];
    [self configureViews];
}

- (void)configureDefault {
    self.slideFrom = JFFliterSlideFromRight;
    self.shadowWidth = 116.0 ;
    self.showStatusBar = YES;
    self.shadowColor = UIColorWithHEXAndAlpha(@"#D7D7D7", 0.1);
    self.contentColor = UIColorWithHEXAndAlpha(@"#1C1E21", 1.0);
    self.bottomHeight = 43.0;
    
}

- (void)addToWindow {
    if (!self.superview) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.windowLevel = self.showStatusBar ? UIWindowLevelNormal : UIWindowLevelAlert;
        [self addSubview:self.shadowView];
        [self addSubview:self.tableViewContainer];
        [self.window addSubview:self];
        [self.window makeKeyAndVisible];
    }
}

- (void)removeFromWindow {
    if (self.superview) {
        [self removeFromSuperview];
        self.window = nil;
    }
}

- (void)hide {
    if ([self keyboardIsVisible]) {
        [self endEditing:YES];
        return;
    }
    [self hideAnimationWithCompletion:^(BOOL finished) {
        [self removeFromWindow];
    }];
}

- (void)showAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [self endEditing:YES];
    CGFloat containerX = self.slideFrom == JFFliterSlideFromRight ? self.shadowWidth : -self.shadowWidth;
    [UIView animateWithDuration:slideDuration
                           animations:^{
                               self.tableViewContainer.frame = CGRectMake(containerX, 0, kWidth, kHeight);
                           }
                           completion:^(BOOL finished) {
        [UIView animateWithDuration:alphaDuration
                         animations:^{
                             self.shadowView.backgroundColor = self.shadowColor;
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion(finished);
                             }
                         }];
                           }];
    
}

- (void)hideAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [self endEditing:YES];
    CGFloat containerX = self.slideFrom == JFFliterSlideFromRight ? kWidth : -kWidth;
    [UIView animateWithDuration:alphaDuration
                     animations:^{
                         self.shadowView.backgroundColor = [UIColor clearColor];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:slideDuration
                                                animations:^{
                                                    self.tableViewContainer.frame = CGRectMake(containerX, 0, kWidth, kHeight);
                                                }
                                                completion:^(BOOL finished) {
                                                    if (completion) {
                                                        completion(finished);
                                                    }
                                                }];
                    }];
}

- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}

- (BOOL)keyboardIsVisible
{
    return _keyboardIsVisible;
}

- (CGFloat)calculateCellHeaderHeightForIndex:(NSInteger)index {
    JFFliterItem *item = self.fliterItems[index];
    if (item.cacheHeaderHeight > 0) {
        return item.cacheHeaderHeight;
    }
    CGFloat height;
    if ([self.delegate respondsToSelector:@selector(heightForHeaderViewInSection:)]) {
        height = [self.delegate heightForHeaderViewInSection:index];
    }else {
        height = 0;
        height += (2.0 * [JFFliterAppearanceManager sharedManager].sectionPaddingSize.height);
        height += [UIFont systemFontOfSize:[FontUtil fontSize:11]].lineHeight;
    }
    [item setValue:@(height) forKeyPath:@"cacheHeaderHeight"];
    return height;
}

- (CGFloat)calculateCellHeightForIndex:(NSInteger)index {
    JFFliterItem *item = self.fliterItems[index];
    if (item.cacheCellHeight > 0) {
        return item.cacheCellHeight;
    }
    
    CGFloat height = 0.0;
    if (item.type == JFFliterItemTypePicker) {
        height = [JFFliterAppearanceManager sharedManager].pickerHeight;
    }else {
        CGFloat subButtonHeight = [JFFliterAppearanceManager sharedManager].subButtonHeight;
        
        if ([self.chooseCellDataSource respondsToSelector:@selector(heightForItemCellInSection:)]) {
            subButtonHeight = [self.chooseCellDataSource heightForItemCellInSection:index];
        }
        NSInteger lineCount = ceil((item.subTitles.count + (item.enableMultipleChoose ? 1 : 0)) / ([JFFliterAppearanceManager sharedManager].subButtonCount * 1.0));
        height += (lineCount * subButtonHeight + (lineCount - 1) * [JFFliterAppearanceManager sharedManager].sectionPaddingSize.height);
    }

    height += [JFFliterAppearanceManager sharedManager].sectionPaddingSize.height;
    [item setValue:@(height) forKeyPath:@"cacheCellHeight"];
    return height;
}

#pragma mark - Configure Views
- (void)configureViews {
    
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.shadowView.frame = self.bounds;
    
    CGFloat containerX = self.slideFrom == JFFliterSlideFromRight ? kWidth : -kWidth;
    CGFloat tableViewX = self.slideFrom == JFFliterSlideFromRight ? 0 : self.shadowWidth;
    CGFloat tableViewY = self.showStatusBar ? kStatusBarHeight : 0;
    
    self.tableViewContainer.frame = CGRectMake(containerX, 0, kWidth, kHeight);
    self.tableViewContainer.backgroundColor = self.contentColor;
    
    self.fliterTableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomHeight, 0);
    
    self.fliterTableView.frame = CGRectMake(tableViewX, tableViewY, (kWidth - self.shadowWidth), kHeight - tableViewY);
    self.fliterTableView.backgroundColor = self.contentColor;
    [self.tableViewContainer addSubview:self.fliterTableView];
    [self.tableViewContainer addSubview:self.resetButton];
    [self.tableViewContainer addSubview:self.confirmButton];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.fliterTableView);
        make.height.mas_equalTo(self.bottomHeight);
        make.width.mas_equalTo(self.fliterTableView.width / 2.0);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resetButton.mas_right);
        make.bottom.height.width.equalTo(self.resetButton);
    }];
}

#pragma mark - Target Action
- (void)confirmButtonClick:(UIButton *)sender {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (JFFliterItem *item in self.fliterItems) {
        if (item.type == JFFliterItemTypeChooseButton) {
            NSMutableArray *itemArr = [NSMutableArray array];
            if (item.isAllChosen && item.allChosenReferences) {
                [itemArr addObject:item.allChosenReferences];
            }else {            
                for (NSInteger index = 0; index < item.subTitles.count; index++) {
                    NSString *title = item.subTitles[index];
                    NSString *itemValue = [title copy];
                    if (item.subTitlesReferences.count > index) {
                        itemValue = [item.subTitlesReferences[index] copy];
                    }
                    if (item.isAllChosen) {
                        [itemArr addObject:itemValue];
                    }else if ([item isChosenForKey:title]) {
                        [itemArr addObject:itemValue];
                    }
                }
            }
            [result setObject:itemArr forKey:item.key];
        }else {
            NSArray *itemArr = [NSArray arrayWithObjects:item.leftValue ? item.leftValue:item.rightValue,item.leftValue ? item.rightValue:nil, nil];
            [result setObject:itemArr forKey:item.key];
        }
    }
    
    //check before completion
    if ([self.delegate respondsToSelector:@selector(shouldConfirmWithResult:)]) {
         BOOL flag = [self.delegate shouldConfirmWithResult:result];
        if (!flag) {
            NSLog(@"shouldConfirmWithResult error");
        }else {
            [self hide];
            if (self.completionHandler) {
                self.completionHandler(result);
            }
        }
    }else {
        [self hide];
        if (self.completionHandler) {
            self.completionHandler(result);
        }
    }
}

- (void)resetButtonClick:(UIButton *)sender {
    for (JFFliterItem *item in self.fliterItems) {
        [item reset];
    }
    [self.fliterTableView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fliterItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self calculateCellHeaderHeightForIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [self calculateCellHeightForIndex:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JFFliterItem *item = self.fliterItems[section];
    JFFliterSectionHeader *header;
    if (_customizedHeader && [self.dataSource respondsToSelector:@selector(sectionHeaderForFliterView:inSection:)]) {
        return [self.dataSource sectionHeaderForFliterView:self inSection:section];
    }
    header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFliterSectionCellHeaderID];
    header.headerLabel.text = item.title;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFFliterItem *item = self.fliterItems[indexPath.section];
    JFFliterSectionCell *cell;
    if (item.type == JFFliterItemTypePicker) {
        cell = [tableView dequeueReusableCellWithIdentifier:kFliterSectionPickerCellID];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:kFliterSectionChooseCellID];
        
        if (self.chooseCellDataSource) {
            JFFliterSectionChooseCell *chooseCell = (JFFliterSectionChooseCell *)cell;
            if (_itemCellClass) {
                [chooseCell registerItemCellClass:_itemCellClass];
            }
            chooseCell.dataSource = self.chooseCellDataSource;
            chooseCell.tag = indexPath.section;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellItem = item;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
}

#pragma mark - Getter && Setter
- (NSMutableArray *)fliterItems {
    if (!_fliterItems) {
        _fliterItems = [NSMutableArray array];
    }
    return _fliterItems;
}

- (UIView *)tableViewContainer {
    if (!_tableViewContainer) {
        _tableViewContainer = [[UIView alloc] init];
    }
    return _tableViewContainer;
}

- (UITableView *)fliterTableView {
    if (!_fliterTableView) {
        _fliterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _fliterTableView.delegate = self;
        _fliterTableView.dataSource = self;
        _fliterTableView.bounces = NO;
        _fliterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fliterTableView.showsVerticalScrollIndicator = NO;
        _fliterTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_fliterTableView registerClass:[JFFliterSectionChooseCell class] forCellReuseIdentifier:kFliterSectionChooseCellID];
        [_fliterTableView registerClass:[JFFliterSectionPickerCell class] forCellReuseIdentifier:kFliterSectionPickerCellID];
        if (!_customizedHeader || ![self.dataSource respondsToSelector:@selector(sectionHeaderForFliterView:inSection:)]) {
            [_fliterTableView registerClass:[JFFliterSectionHeader class] forHeaderFooterViewReuseIdentifier:kFliterSectionCellHeaderID];
        }
    }
    return _fliterTableView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
    }
    return _shadowView;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.backgroundColor = UIColorWithHEX(@"#3A3F46");
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:[FontUtil fontSize:15]];
        [_resetButton setTitleColor:UIColorWithHEX(@"#D7D7D7") forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = UIColorWithHEX(@"#ED8D03");
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:[FontUtil fontSize:15]];
        [_confirmButton setTitleColor:UIColorWithHEX(@"#FFFFFF") forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
