//
//  XWCollectionView.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/10.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWReuseDataBase.h"
#import "XWHeaderReuseDataBase.h"


@protocol XWCollectionViewDataSourceDelegate;



@interface XWCollectionView : UICollectionView


@property (nonatomic, weak) id<XWCollectionViewDataSourceDelegate> dataSourceDelegate;

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> layoutDelegate;


/**
 * 便利构造
 * 默认流布局
 */
+ (instancetype)createWithFlowLayout;

+ (instancetype)createWithLayout:(UICollectionViewLayout *)layout;

@end


// delegate
@protocol QLXCollectionViewDelegate <UICollectionViewDelegate>

@optional

//下拉刷新
- (void)refreshCollectionViewDropRefresh:(XWCollectionView *)collectionView;
//上拉刷新
- (void)refreshCollectionViewUpRefresh:(XWCollectionView *)collectionView;

-(void) contentSizeDidChangeWithScrollView:(UIScrollView *)scrollView;

@end

@protocol XWCollectionViewDataSourceDelegate <NSObject>

@optional

/**
 * cell数据源
 *
 *  返回 XWComponentDataBase 类型组成的数据 数组
 */
- (NSMutableArray<XWReuseDataBase *> *)cellDataListWithCollectionView:(XWCollectionView *)collectionView;

- (NSMutableArray<XWHeaderReuseDataBase *> *)headerDataListWithCollectionView:(XWCollectionView *)collectionView;

- (NSMutableArray<XWReuseDataBase *> *)footerDataListWithCollectionView:(XWCollectionView *)collectionView;


- (NSMutableArray<Class> *)decorationViewClassListWithCollectionView:(XWCollectionView *)collectionView;



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

