//
//  XWCollectionViewCell.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWCollectionView;
@class XWReuseDataBase;

typedef NS_ENUM(NSInteger, XWCollectionViewCellSelectionStyle) {
    XWCollectionViewCellSelectionStyleNone ,
    XWCollectionViewCellSelectionStyleBlue,
    XWCollectionViewCellSelectionStyleGray,
    XWCollectionViewCellSelectionStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
};


@interface XWCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) XWCollectionView *collectionView;

@property (nonatomic, strong) UIColor *defaultColor;

@property (nonatomic, strong) UIColor *heightColor;

@property (nonatomic, assign) XWCollectionViewCellSelectionStyle   selectionStyle;

@property (nonatomic, strong) XWReuseDataBase *data;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) int reuseTimes; // 复用次数

@property (nonatomic, assign) BOOL dynamicCellSize; // 是否为动态大小  默认为静态 如果不是要设置为true才行

- (void)reuseWithData:(XWReuseDataBase *)data indexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

- (CGSize)cellSize;

// 可以重写 可以不用重写
-(void) createUI;

/**
 *  需要在子类里重写
 *
 *  @return cell 的宽度
 */
- (CGFloat)cellWidth;


- (CGFloat)cellHeight;

/** 刷新 可重写 */
- (void)refresh;

-(void)selectedCell;


@end
