//
//  JFFliterSectionCell.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/21.
//  Copyright © 2017年 jf. All rights reserved.
//
#import <Masonry.h>
#import "JFFliterSectionCell.h"
#import "JFFliterAppearanceManager.h"

@interface JFFliterSectionCell ()

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation JFFliterSectionCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self didInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.width > 0.00001) {
        [self didLayoutSubviews];
    }
}

- (void)didInit {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sepLine];
}

- (void)didLayoutSubviews {
    CGFloat sepLineHeight = [JFFliterAppearanceManager sharedManager].separateLineStyle == JFFliterSeparateLineStyleNone ? 0.0 : 1.0 ;
    UIColor *sepLineColor = [JFFliterAppearanceManager sharedManager].separateLineStyle == JFFliterSeparateLineStyleBlack ? UIColorWithHEXAndAlpha(@"#030404", 1.0) : UIColorWithHEXAndAlpha(@"#fcfbfb", 1.0);
    self.sepLine.backgroundColor = sepLineColor;
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self);
        make.height.mas_equalTo(sepLineHeight);
    }];
}

#pragma mark - Getter && Setter

- (void)setCellItem:(JFFliterItem *)cellItem {
    _cellItem = cellItem;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc] init];
    }
    return _sepLine;
}

@end
