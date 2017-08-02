//
//  JFFliterItem.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/21.
//  Copyright © 2017年 jf. All rights reserved.
//

#import "JFFliterItem.h"
#import <YYKit.h>

NSString *const JFFliterAllChosenKey = @"全部";
NSString *const JFFliterDateFormter = @"yyyy-MM-dd";


@interface JFFliterItem ()

@property (nonatomic, strong) NSDictionary *resetDic;
@property (nonatomic, strong) NSMutableDictionary *chosenDic;

@end

@implementation JFFliterItem

#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        self.type = JFFliterItemTypeChooseButton;
        _cacheCellHeight = -1;
        _cacheHeaderHeight = -1;
    }
    return self;
}

#pragma mark - Getter && Setter
- (void)setType:(JFFliterItemType)type {
    _type = type;
    switch (self.type) {
        case JFFliterItemTypeChooseButton:
        {
            self.enableMultipleChoose = YES;
        }
            break;
        case JFFliterItemTypePicker:
        {
            self.sectionSelect = YES;
            self.pickerType = JFFliterPickerTypeDatePicker;
            self.shouldReset = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - JFFliterItemTypeChooseButton
- (void)setSubTitles:(NSArray *)subTitles {
    _subTitles = subTitles;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int index = 0; index < subTitles.count; index ++) {
        [dic setObject:@(NO) forKey:subTitles[index]];
    }
    self.resetDic = [dic copy];
    self.chosenDic= dic;
}

- (void)setIsAllChosen:(BOOL)isAllChosen {
    if (!self.enableMultipleChoose) {
        _isAllChosen = NO;
        return;
    }
    _isAllChosen = isAllChosen;
    
    if (self.isAllChosen) {
        self.chosenDic = [self.resetDic mutableCopy];
    }
}

- (void)setEnableMultipleChoose:(BOOL)enableMultipleChoose {
    _enableMultipleChoose = enableMultipleChoose;
    if (self.enableMultipleChoose) {
        self.isAllChosen = YES;
    }else {
        self.isAllChosen = NO;
    }
}

#pragma mark - JFFliterItemTypePicker

- (void)setSectionSelect:(BOOL)sectionSelect {
    if (self.type == JFFliterItemTypeChooseButton) {
        return;
    }
    _sectionSelect = sectionSelect;
}

- (void)setPickerType:(JFFliterPickerType)pickerType {
    if (self.type == JFFliterItemTypeChooseButton) {
        return;
    }
    _pickerType = pickerType;
    switch (self.pickerType) {
        case JFFliterPickerTypeDatePicker:
        {
            self.leftMinDate = [[NSDate date] dateByAddingMonths:-12];
            self.leftMaxDate = [NSDate date];
            self.rightMinDate = [NSDate date];
            self.rightMaxDate = [[NSDate date] dateByAddingMonths:12];
        }
            break;
        case JFFliterPickerTypeTextField:
        {
            self.leftMaxNumber = @(366);
            self.rightMaxNumber = @(366);
        }
        default:
            break;
    }
}


#pragma mark - Public Methods
- (void)reset {
    if (self.type == JFFliterItemTypeChooseButton) {
        self.isAllChosen = YES;
    }else {
        self.shouldReset = YES;
    }
}

- (void)setChosen:(BOOL)chosen forKey:(NSString *)key {
    if (self.type == JFFliterItemTypePicker) {
        return;
    }
    if ([self.chosenDic.allKeys containsObject:key]) {
        [self.chosenDic setObject:@(chosen) forKey:key];
    }
}

- (BOOL)isChosenForKey:(NSString *)key {
    if (self.type == JFFliterItemTypePicker) {
        return NO;;
    }
    BOOL isChosen = NO;
    if ([self.chosenDic.allKeys containsObject:key]) {
        isChosen = ((NSNumber *)[self.chosenDic objectForKey:key]).boolValue;
    }
    return isChosen;
}

@end
