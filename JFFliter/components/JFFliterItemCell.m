//
//  JFFliterItemCell.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/21.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Masonry.h>
#import "JFFliterItemCell.h"
#import "JFFliterAppearanceManager.h"

@interface JFFliterItemCell ()
{
    UIButton *_chooseButton;
}
@property (nonatomic, strong) UIImageView *chooseImgView;

@end

@implementation JFFliterItemCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureViews];
    }
    return self;
}

#pragma mark - Configure Views
- (void)configureViews {
    [self addSubview:self.chooseButton];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.chooseImgView];
    [self.chooseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(13);
    }];
}

#pragma mark - Getter && Setter
- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
    self.chooseButton.selected = self.chosen;
    self.chooseImgView.hidden = !chosen;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.titleLabel.font = [JFFliterAppearanceManager sharedManager].subButtonFont;
        _chooseButton.backgroundColor = [JFFliterAppearanceManager sharedManager].subButtonBackgroundColor;
        [_chooseButton setTitleColor:[JFFliterAppearanceManager sharedManager].subButtonTextChoodenColor forState:UIControlStateSelected];
        [_chooseButton setTitleColor:[JFFliterAppearanceManager sharedManager].subButtonTextNormalColor forState:UIControlStateNormal];
        _chooseButton.userInteractionEnabled = NO;
    }
    return _chooseButton;
}

- (UIImageView *)chooseImgView {
    if (!_chooseImgView) {
        _chooseImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouxuan"]];
    }
    return _chooseImgView;
}

@end
