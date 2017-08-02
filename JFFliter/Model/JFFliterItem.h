//
//  JFFliterItem.h
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/21.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const JFFliterAllChosenKey;
UIKIT_EXTERN NSString *const JFFliterDateFormter;

typedef enum : NSUInteger {
    JFFliterPickerTypeTextField,
    JFFliterPickerTypeDatePicker,
    JFFliterPickerTypeDatePickerAddress,
} JFFliterPickerType;

typedef enum : NSUInteger {
    JFFliterItemTypeChooseButton,
    JFFliterItemTypePicker,
} JFFliterItemType;


@interface JFFliterItem : NSObject

//共用属性
@property (nonatomic, copy) NSString *title;//头部标题（显示）
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) JFFliterItemType type;


//多选按钮
@property (nonatomic, strong) NSArray *subTitles;//子按钮标题
@property (nonatomic, strong, nullable) NSArray *subTitlesReferences;//标题对应的值
@property (nonatomic, copy, nullable) NSString *allChosenReferences;//全选对应的值
@property (nonatomic, assign) BOOL enableMultipleChoose;//是否允许多选 默认yes
@property (nonatomic, assign) BOOL isAllChosen;//是否被全选 默认yes

//选择器
@property (nonatomic, assign) BOOL sectionSelect; //是否为区间选择
@property (nonatomic, assign) JFFliterPickerType pickerType;//选择器类型(包含输入框)
@property (nonatomic, strong) NSDate *leftMinDate;
@property (nonatomic, strong) NSDate *leftMaxDate;
@property (nonatomic, strong) NSDate *rightMinDate;
@property (nonatomic, strong) NSDate *rightMaxDate;

@property (nonatomic, strong) NSNumber *leftMaxNumber;
@property (nonatomic, strong) NSNumber *rightMaxNumber;

@property (nonatomic, copy) NSString *leftPlaceHolder;//占位文字
@property (nonatomic, copy) NSString *rightPlaceHolder;//占位文字
@property (nonatomic, copy) NSString *leftValue;
@property (nonatomic, copy) NSString *rightValue;
@property (nonatomic, assign) BOOL shouldReset;

@property (nonatomic, assign, readonly) CGFloat cacheCellHeight;
@property (nonatomic, assign, readonly) CGFloat cacheHeaderHeight;

- (void)setChosen:(BOOL)chosen forKey:(NSString *)key;
- (BOOL)isChosenForKey:(NSString *)key;
- (void)reset;

@end
