//
//  JFFliterSectionChooseCell.m
//  JFTX_WuHanPJJY
//
//  Created by geeksprite on 2017/7/25.
//  Copyright © 2017年 jf. All rights reserved.
//

#import <Masonry.h>
#import "JFFliterItem.h"
#import "JFFliterItemCell.h"
#import "JFFliterSectionChooseCell.h"
#import "JFFliterAppearanceManager.h"

static NSString *const kFliterItemCellID = @"kFliterItemCellID";

@interface JFFliterSectionChooseCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    BOOL _customizedCell ;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JFFliterSectionChooseCell

- (void)registerItemCellClass:(Class)aClass {
    [self.collectionView registerClass:aClass forCellWithReuseIdentifier:kFliterItemCellID];
    _customizedCell = YES;
}

- (JFFliterItemCell *)dequeueReusableItemCellForIndexpath:(NSIndexPath *)path {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:kFliterItemCellID forIndexPath:path];
}

#pragma mark - Override
- (void)setCellItem:(JFFliterItem *)cellItem {
    [super setCellItem:cellItem];
    [self.collectionView reloadData];
}

- (void)didInit {
    [super didInit];
    [self addSubview:self.collectionView];
}

- (void)didLayoutSubviews {

    [super didLayoutSubviews];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = [JFFliterAppearanceManager sharedManager].sectionPaddingSize.height;
    layout.minimumInteritemSpacing = [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width,[JFFliterAppearanceManager sharedManager].sectionPaddingSize.height, [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(insets);
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.cellItem.enableMultipleChoose) {//非多选
        NSString *title = self.cellItem.subTitles[indexPath.row];
        if ([self.cellItem isChosenForKey:title]) {
            BOOL shouldReverse = NO;
            for (NSString *key in self.cellItem.subTitles) {
                if ([key isEqualToString:title]) {
                    continue;
                }
                if ([self.cellItem isChosenForKey:key]) {
                    shouldReverse = YES;
                    break;
                }
            }
            if (shouldReverse) {
                [self.cellItem setChosen:NO forKey:title];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }else {
            NSIndexPath *prePath;
            for (NSInteger index = 0; index < self.cellItem.subTitles.count; index ++) {
                NSString *key = self.cellItem.subTitles[index];
                if ([self.cellItem isChosenForKey:key]) {
                    [self.cellItem setChosen:NO forKey:key];
                    prePath = [NSIndexPath indexPathForRow:index inSection:0];
                    break;
                }
            }
            [self.cellItem setChosen:YES forKey:title];
            if (prePath) {
                [collectionView reloadItemsAtIndexPaths:@[indexPath,prePath]];
            }else {
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    }else {
        if (indexPath.row == 0) {
            if (self.cellItem.isAllChosen) {
                return;
            }
            self.cellItem.isAllChosen = YES;
            [collectionView reloadData];
        }else {
            NSString *title = self.cellItem.subTitles[indexPath.row - 1];
            if ([self.cellItem isChosenForKey:title]) {
                BOOL shouldReverse = NO;
                for (NSString *key in self.cellItem.subTitles) {
                    if ([key isEqualToString:title]) {
                        continue;
                    }
                    if ([self.cellItem isChosenForKey:key]) {
                        shouldReverse = YES;
                        break;
                    }
                }
                if (shouldReverse) {
                    [self.cellItem setChosen:NO forKey:title];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }

            }else {
                NSIndexPath *allChosenPath = nil;
                if (self.cellItem.isAllChosen) {
                    self.cellItem.isAllChosen = NO;
                    allChosenPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
                [self.cellItem setChosen:YES forKey:title];
                BOOL shouldReset = YES;
                for (NSString *key in self.cellItem.subTitles) {
                    shouldReset = [self.cellItem isChosenForKey:key];
                    if (!shouldReset) {
                        break;
                    }
                }
                if (shouldReset) {
                    self.cellItem.isAllChosen = YES;
                    [collectionView reloadData];
                }else {
                    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, allChosenPath,nil]];
                }
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellItem.subTitles.count + (self.cellItem.enableMultipleChoose ? 1 : 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [JFFliterAppearanceManager sharedManager].subButtonHeight;
    if ([self.dataSource respondsToSelector:@selector(heightForItemCellInSection:)]) {
        height = [self.dataSource heightForItemCellInSection:self.tag];
    }
    return CGSizeMake(floorf((self.width - ([JFFliterAppearanceManager sharedManager].subButtonCount + 1) * [JFFliterAppearanceManager sharedManager].sectionPaddingSize.width) / ([JFFliterAppearanceManager sharedManager].subButtonCount * 1.0)), height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(itemCellForChooseCell:atRow:)]) {
        return [self.dataSource itemCellForChooseCell:self atRow:indexPath.row];
    }
    JFFliterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFliterItemCellID forIndexPath:indexPath];
    if (self.cellItem.enableMultipleChoose && indexPath.row == 0) {
        [cell.chooseButton setTitle:JFFliterAllChosenKey forState:UIControlStateNormal];
        cell.chosen = self.cellItem.isAllChosen;
        return cell;
    }
    NSString *title = self.cellItem.subTitles[indexPath.row - (self.cellItem.enableMultipleChoose ? 1 : 0)];
    [cell.chooseButton setTitle:title forState:UIControlStateNormal];
    cell.chosen = [self.cellItem isChosenForKey:title];
    return cell;
}

#pragma mark - Getter && Setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        if (!_customizedCell || ![self.dataSource respondsToSelector:@selector(itemCellForChooseCell:atRow:)]) {
            [_collectionView registerClass:[JFFliterItemCell class] forCellWithReuseIdentifier:kFliterItemCellID];
        }
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
