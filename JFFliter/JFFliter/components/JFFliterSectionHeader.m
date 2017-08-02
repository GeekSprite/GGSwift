//
//  JFFliterSectionHeader.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/26.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Masonry.h>
#import "JFFliterSectionHeader.h"
#import "JFFliterAppearanceManager.h"

@interface JFFliterSectionHeader ()
{
    UIView *_headerView;
    UILabel *_headerLabel;
}

@end

@implementation JFFliterSectionHeader

#pragma mark - Init
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self didInit];
    }
    return self;
}

#pragma mark - Configure Views
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.width > 0.00001) {
        [self didLayoutSubviews];
    }
}

- (void)didInit {
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.headerLabel];
    [self addSubview:self.headerView];
}

- (void)didLayoutSubviews {
    [self.headerLabel sizeToFit];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.height);
    }];

    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset([JFFliterAppearanceManager sharedManager].sectionPaddingSize.width);
        make.top.equalTo(self.headerView).offset([JFFliterAppearanceManager sharedManager].sectionPaddingSize.height);
    }];
}

#pragma mark - Getter && Setter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView= [[UIView alloc] init];
    }
    return _headerView;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.textAlignment = NSTextAlignmentLeft;
        _headerLabel.font = [UIFont systemFontOfSize:[FontUtil fontSize:11]];
        _headerLabel.textColor = UIColorWithHEX(@"#828282");
    }
    return _headerLabel;
}

@end
