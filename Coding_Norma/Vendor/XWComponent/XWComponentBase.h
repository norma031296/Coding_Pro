//
//  XWComponentBase.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWReuseDataBase.h"
#import "XWComponentView.h"

@interface XWComponentBase : NSObject

@property(nonatomic , strong) XWHeaderReuseDataBase * headerData; // 头部视图模型
@property(nonatomic , strong) NSMutableArray<XWReuseDataBase *> * cellDataList; // cell视图模型数组
@property(nonatomic , strong) XWReuseDataBase * footerData;       // 尾部视图模型
@property(nonatomic , copy  ) Class decorationViewClass; // 修视背景图类

@property(nonatomic , assign) BOOL needRequst;

@property(nonatomic , weak  ) XWComponentView * multiWidgetView;




/**
 *  多个secion时候设置
 */

@property(nonatomic , strong) NSMutableArray<XWHeaderReuseDataBase *> * headerDataList;
@property(nonatomic , strong) NSMutableArray< NSMutableArray<XWReuseDataBase *> *> * twoDimensionCellDataList;
@property(nonatomic , strong) NSMutableArray<XWReuseDataBase *> * footerDataList;
@property(nonatomic , strong) NSMutableArray<Class> * decorationViewClassList;

/**
 *  初始化继承这个     相当于viewDidLoad
 */
-(void) initConfig;

/**
 *   上拉刷新回调
 *   optional to overriding
 *   重写时 不要 调用父类该方法
 *
 */
-(void) requestUpRefresh;

/**
 *  下拉刷新回调
 *   重写时 不要 调用父类该方法
 */
-(void) requestDropRefresh;

/**
 *  请求数据完毕时回调
 */
-(void)requestFinish;

/**
 *  请求数据完毕时 没有更多数据回调
 */
-(void)requestNoMoreData;

/**
 *  请求数据完毕时 请求失败时候回调
 */
-(void)requestFail;




@end
