//
//  JFFliterSectionPickerCell.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/25.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Masonry.h>
#import "JFFliterItem.h"
#import "JFAreaPickerView.h"
#import "JFSelectDatePickView.h"
#import "JFFliterAppearanceManager.h"
#import "JFFliterSectionPickerCell.h"
#import "JFVarificationInputManager.h"
#import "UITextField+CustomPlacehold.h"

@interface JFFliterSectionPickerCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UITextField *leftTF;
@property (nonatomic, strong) UITextField *rightTF;
@property (nonatomic, strong) UITextField *singleTF;
@property (nonatomic, strong) JFSelectDatePickView *leftPickerView;
@property (nonatomic, strong) JFSelectDatePickView *rightPickerView;
@property (nonatomic, strong) JFAreaPickerView *leftAddressPicker;
@property (nonatomic, strong) JFAreaPickerView *rightAddressPicker;

@end

@implementation JFFliterSectionPickerCell

#pragma amrk - Override
- (void)setCellItem:(JFFliterItem *)cellItem {
    [super setCellItem:cellItem];

    self.indicateView.hidden = !self.cellItem.sectionSelect;
    self.rightTF.hidden = !self.cellItem.sectionSelect;
    [self.leftTF customTextfiledPlaceholdWithColor:[JFFliterAppearanceManager sharedManager].pickerPlaceHolderColor content:self.cellItem.leftPlaceHolder ? self.cellItem.leftPlaceHolder : @"" fontSize:[FontUtil fontSize:14]];
    [self.rightTF customTextfiledPlaceholdWithColor:[JFFliterAppearanceManager sharedManager].pickerPlaceHolderColor content:self.cellItem.rightPlaceHolder ? self.cellItem.rightPlaceHolder : @"" fontSize:[FontUtil fontSize:14]];
    switch (cellItem.pickerType) {
        case JFFliterPickerTypeTextField:
        {
            self.leftTF.inputView = nil;
            self.rightTF.inputView = nil;
        }
            break;
        case JFFliterPickerTypeDatePicker:
        {
            @weakify(self);
            [self workWhenRunloopIdle:^{
                @strongify(self);
                self.leftPickerView.myPickerView.maximumDate = self.cellItem.leftMaxDate;
                self.leftPickerView.myPickerView.minimumDate = self.cellItem.leftMinDate;
                self.rightPickerView.myPickerView.maximumDate = self.cellItem.rightMaxDate;
                self.rightPickerView.myPickerView.minimumDate = self.cellItem.rightMinDate;
                self.leftTF.inputView = self.leftPickerView;
                self.rightTF.inputView = self.rightPickerView;
                self.leftPickerView.block = [self pickerBlockForTextField:self.leftTF];
                self.rightPickerView.block = [self pickerBlockForTextField:self.rightTF];
            }];
        }
            break;
        case JFFliterPickerTypeDatePickerAddress:
        {
            @weakify(self);
            [self workWhenRunloopIdle:^{
                @strongify(self);
                self.leftTF.inputView = self.leftAddressPicker;
                self.rightTF.inputView = self.rightAddressPicker;
                self.leftAddressPicker.tfBlock = [self addressPickerBlockForTextField:self.leftTF];
                self.rightAddressPicker.tfBlock = [self addressPickerBlockForTextField:self.rightTF];
            }];
        }
            break;
        default:
            break;
    }
    if (self.cellItem.shouldReset) {
        self.cellItem.shouldReset = NO;
        self.leftTF.text = nil;
        self.rightTF.text = nil;
    }
}

- (void)didInit {
    [super didInit];
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView addSubview:self.leftTF];
    [self.pickerContainerView addSubview:self.indicateView];
    [self.pickerContainerView addSubview:self.rightTF];
}

- (void)didLayoutSubviews {
    [super didLayoutSubviews];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width, [JFFliterAppearanceManager sharedManager].sectionPaddingSize.height, [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width);
    
    [self.pickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(insets);
    }];
    
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pickerContainerView);
        make.height.mas_equalTo([JFFliterAppearanceManager sharedManager].pickerIndicaterSize.height);
        make.width.mas_equalTo([JFFliterAppearanceManager sharedManager].pickerIndicaterSize.width);
    }];
    
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerContainerView).offset([JFFliterAppearanceManager sharedManager].pickerInsets.top);
        make.bottom.equalTo(self.pickerContainerView).offset([JFFliterAppearanceManager sharedManager].pickerInsets.bottom);
        make.right.equalTo(self.pickerContainerView).offset([JFFliterAppearanceManager sharedManager].pickerInsets.right);
        make.left.equalTo(self.indicateView.mas_right).offset(6);
    }];
    
    if (self.cellItem.sectionSelect) {
        [self.leftTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.rightTF);
            make.left.equalTo(self.pickerContainerView).offset([JFFliterAppearanceManager sharedManager].pickerInsets.left);
            make.right.equalTo(self.indicateView.mas_left).offset(-6);
        }];
    }else {
        [self.leftTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pickerContainerView).offset([JFFliterAppearanceManager sharedManager].pickerInsets.left);
            make.top.bottom.right.equalTo(self.rightTF);
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.cellItem.pickerType != JFFliterPickerTypeTextField) {
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString isBlank]) {
        return YES;
    }
    
    if (![JFVarificationInputManager validateContentIsFloatNum:toBeString]) {
        return NO;
    }
    
    NSNumber *maxValue;
    if (textField == self.leftTF) {
        maxValue = self.cellItem.leftMaxNumber;
    }else {
        maxValue = self.cellItem.rightMaxNumber;
    }
    if (toBeString.doubleValue > maxValue.doubleValue || toBeString.length > ([NSString stringWithFormat:@"%d",(int)toBeString.doubleValue].length + 3)) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *textValue = [textField.text isBlank] ? nil : textField.text;
    if (textField == self.leftTF) {
        self.cellItem.leftValue = textValue;
    }else {
        self.cellItem.rightValue = textValue;
    }
}


#pragma mark - Private

- (void)workWhenRunloopIdle:(void(^)())block {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        if (block) {
            block();
        }
        CFRunLoopRemoveObserver(runLoop, observer, runLoopMode);
        CFRelease(observer);
    });
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
}

- (void (^)(NSString* str,NSDate * date))pickerBlockForTextField:(UITextField *)tf {
    @weakify(tf);
    return ^(NSString* str,NSDate * date){
        @strongify(tf);
        if (str&&date) {
            tf.text = str;
        }
        [tf resignFirstResponder];
    };
}

- (void (^)(NSString* province,NSString * city))addressPickerBlockForTextField:(UITextField *)tf {
    @weakify(tf);
    return ^(NSString* province,NSString * city){
        @strongify(tf);
        if (province&&city) {
            tf.text = [NSString stringWithFormat:@"%@,%@",province,city];
        }
        [tf resignFirstResponder];
    };
}

#pragma mark - Getter && Setter
- (UIView *)pickerContainerView {
    if (!_pickerContainerView) {
        _pickerContainerView = [[UIView alloc] init];
        _pickerContainerView.backgroundColor = [JFFliterAppearanceManager sharedManager].pickerContainerColor;
    }
    return _pickerContainerView;
}

- (UIView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIView alloc] init];
        _indicateView.backgroundColor = [JFFliterAppearanceManager sharedManager].pickerIndicaterColor;
    }
    return _indicateView;
}

- (UITextField *)leftTF {
    if (!_leftTF) {
        _leftTF = [[UITextField alloc] init];
        _leftTF.textColor = [JFFliterAppearanceManager sharedManager].pickerTextColor;
        _leftTF.backgroundColor = [JFFliterAppearanceManager sharedManager].pickerBackgroundColor;
        _leftTF.borderStyle = UITextBorderStyleNone;
        _leftTF.textAlignment = NSTextAlignmentCenter;
        _leftTF.font = [JFFliterAppearanceManager sharedManager].pickerTextFont;
        _leftTF.delegate = self;
        _leftTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _leftTF;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = [JFFliterAppearanceManager sharedManager].pickerTextColor;
        _rightTF.backgroundColor = [JFFliterAppearanceManager sharedManager].pickerBackgroundColor;
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.textAlignment = NSTextAlignmentCenter;
        _rightTF.font = [JFFliterAppearanceManager sharedManager].pickerTextFont;
        _rightTF.delegate = self;
        _rightTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _rightTF;
}

- (JFSelectDatePickView *)leftPickerView {
    if (!_leftPickerView) {
        _leftPickerView = [JFSelectDatePickView instanceView];
    }
    return _leftPickerView;
}

- (JFSelectDatePickView *)rightPickerView {
    if (!_rightPickerView) {
        _rightPickerView = [JFSelectDatePickView instanceView];
    }
    return _rightPickerView;
}

- (JFAreaPickerView *)leftAddressPicker {
    if (!_leftAddressPicker) {
        _leftAddressPicker = [[JFAreaPickerView alloc] init];
    }
    return _leftAddressPicker;
}

- (JFAreaPickerView *)rightAddressPicker {
    if (!_rightAddressPicker) {
        _rightAddressPicker = [[JFAreaPickerView alloc] init];
    }
    return _rightAddressPicker;
}

@end
