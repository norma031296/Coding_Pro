//
//  XWReuseDataBase.h
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"


/**
 这个类表示所有视图相关数据的基类，类似于 ViewModel。
 NOTE: 基类只包含一个视图的基本数据，即宽和高。
 */
@interface XWReuseDataBase : NSObject

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;


/** 高度变化了 请用这个函数调用下 */
- (void)heightChanged;

/**
 *  由子类重写  必须重写
 *
 *  @return 复用标识 对应的cell类名字符串 记得要写对
 */
- (NSString *)reuseIdentifier;

@end
