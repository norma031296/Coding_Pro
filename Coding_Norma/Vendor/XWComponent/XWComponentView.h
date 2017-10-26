//
//  XWComponentView.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCollectionView.h"

@class XWComponentBase;
@protocol XWComponentViewDeleagte;

typedef enum : NSUInteger {
    XWComponentViewStateDefault,      // 正常状态
    XWComponentViewStateRefreshing,   // 正在请求刷新状态
    XWComponentViewStateRefreshFail,  // 请求刷新失败
    XWComponentViewStateRefreshSuccess,// 请求刷新成功
    XWComponentViewStateRefreshNoMoreData// 请求刷新无更多数据状态
} XWComponentViewState;

@interface XWComponentView : UIView

@property (nonatomic, weak) id<XWComponentViewDeleagte> delegate;   // 如果要设置 请用 createWithDelgate 方法构造初始化
@property (nonatomic, strong, readonly) XWCollectionView *collectionView; // 要设置collectionview 的相关属性和方法 可以直接用这个
@property (nonatomic, assign) XWComponentViewState state;
@property (nonatomic, strong) UIColor *bagColor;

/**
 *  构造对象
 */
+ (instancetype)createWithDelgate:(id<XWComponentViewDeleagte>)delegate;

/**
 *  刷新 视图 刷新数据用这个方法 不能用[QLXMultiWidgetView.Collectionview reloadData];
 */
- (void)reloadData;

/**
 *  刷新部件
 */
//-(void) reloadDataWithWidget:(XWComponentBase *)widget;

/**
 *  添加一个部件
 */
- (void)addWidget:(XWComponentBase *)widget;

/**
 *  删除一个部件
 */
- (void)removeWidget:(XWComponentBase *)widget;

/**
 *  插入一个部件
 */
- (void)insertWidget:(XWComponentBase *)widget section:(NSUInteger)section;

/**
 *  判断是否已经有该类部件
 */
- (BOOL)containWithWidgetClass:(Class)aClass;

/**
 *  判断是否已经包含该部件
 */
- (BOOL)containWithWidget:(XWComponentBase *)widget;

/**
 *  请求数据完毕时回调
 */
//-(void)requestFinish;

/**
 *  请求数据完毕时 没有更多数据回调
 */
//-(void)requestNoMoreData;

/**
 *  请求失败失败时候回调
 */

//-(void) requestFail;

/**
 *  可继承返回自定义QLXCollectionView 子类
 */
- (XWCollectionView *)getCollectionView;

@end

// 代理

@protocol XWComponentViewDeleagte <QLXCollectionViewDelegate>

@optional
/**
 *  返回布局给collectionview 默认 系统流布局
 */
- (UICollectionViewLayout *)collectionViewLayoutWithMultiWidgetView:(XWComponentView *)multiWidgetView;

/**
 *  请求结束回调
 */
- (void)multiWidgetView:(XWComponentView *)multiWidgetView requestFinishWithResult:(XWComponentViewState)result;

@end
