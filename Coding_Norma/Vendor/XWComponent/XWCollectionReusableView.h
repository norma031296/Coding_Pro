//
//  XWCollectionReusableView.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWCollectionView;
@class XWReuseDataBase;

@interface XWCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) XWCollectionView *collectionView;
@property (nonatomic, strong) XWReuseDataBase *data;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL bHeader;
@property (nonatomic, assign) BOOL dynamicViewSize; // 是否为动态大小  默认为静态 如果不是要设置为true才行

// UI的初始化可以继承这个
- (void)createUI;

// 复用数据会在这里继承
- (void)reuseWithData:(XWReuseDataBase *)data section:(NSInteger)section isHeader:(BOOL)bHeader;

/**
 *  可以重写  如果直接确定这个view 的大小 可以重写这个方法直接返回大小
 *  @return view 的大小 宽和高
 */
- (CGSize)viewSize;

/**
 *  可以重写
 *  如果可以确定高度 就要重写这个方法 而宽度会根据自动布局来自动算出
 *  @return 返回view的高度
 */

- (CGFloat)viewHeight;

/**
 *  可以重写
 *  如果可以确定宽度 就要重写这个方法 而高度会根据自动布局来自动算出
 *  @return 返回view的高度
 */

- (CGFloat)viewWidth;

/** 刷新 */
- (void)refresh;



@end
