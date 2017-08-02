//
//  JFFliterAppearanceManager.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/27.
//  Copyright © 2017年 jf. All rights reserved.
//

#import "JFFliterAppearanceManager.h"

@implementation JFFliterAppearanceManager

#pragma mark - Singleton
+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static JFFliterAppearanceManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[JFFliterAppearanceManager alloc] init];
        [manager setupDefaultValue];
    });
    return manager;
}

- (void)setupDefaultValue {
    
    self.sectionPaddingSize = CGSizeMake(10.0, 8.0);
    self.separateLineStyle = JFFliterSeparateLineStyleBlack;
    
    self.subButtonCount = 3;
    self.subButtonHeight = 28.0;
    self.subButtonBackgroundColor = UIColorWithHEX(@"#323336");
    self.subButtonTextNormalColor = UIColorWithHEX(@"#D7D7D7");
    self.subButtonTextChoodenColor = UIColorWithHEX(@"#FF7700");
    self.subButtonFont = [UIFont systemFontOfSize:13];
    
    self.pickerHeight = 35.0;
    self.pickerInsets = UIEdgeInsetsMake(5, 8, -5, -8);
    self.pickerContainerColor = UIColorWithHEX(@"#030404");
    self.pickerBackgroundColor = UIColorWithHEX(@"#232529");
    self.pickerTextColor = UIColorWithHEX(@"#616161");
    self.pickerPlaceHolderColor = UIColorWithHEX(@"#4E4E4E");
    self.pickerTextFont = [UIFont systemFontOfSize:[FontUtil fontSize:14]];
    self.pickerIndicaterColor = UIColorWithHEX(@"#FFFFFF");
    self.pickerIndicaterSize = CGSizeMake(16.0, 2.0);
}
@end
