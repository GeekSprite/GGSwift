//
//  JFFliterAppearanceManager.h
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/27.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JFFliterSeparateLineStyleBlack,
    JFFliterSeparateLineStyleWhite,
    JFFliterSeparateLineStyleNone,
} JFFliterSeparateLineStyle;



/**
 用来设置筛选器的一些UI属性
 */
@interface  JFFliterAppearanceManager : NSObject

@property (nonatomic, assign) CGSize sectionPaddingSize;
@property (nonatomic, assign) JFFliterSeparateLineStyle  separateLineStyle;

@property (nonatomic, assign) NSInteger subButtonCount;
@property (nonatomic, assign) CGFloat subButtonHeight;
@property (nonatomic, strong) UIColor *subButtonBackgroundColor;
@property (nonatomic, strong) UIColor *subButtonTextNormalColor;
@property (nonatomic, strong) UIColor *subButtonTextChoodenColor;
@property (nonatomic, strong) UIFont  *subButtonFont;

@property (nonatomic, assign) CGFloat pickerHeight;
@property (nonatomic, assign) UIEdgeInsets pickerInsets;
@property (nonatomic, assign) CGSize   pickerIndicaterSize;
@property (nonatomic, strong) UIColor *pickerContainerColor;
@property (nonatomic, strong) UIColor *pickerBackgroundColor;
@property (nonatomic, strong) UIColor *pickerTextColor;
@property (nonatomic, strong) UIColor *pickerPlaceHolderColor;
@property (nonatomic, strong) UIFont  *pickerTextFont;
@property (nonatomic, strong) UIColor *pickerIndicaterColor;

+ (instancetype)sharedManager;

@end
