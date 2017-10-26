//
//  UIView+XWExt.h
//  OlaDriver
//
//  Created by 王剑石 on 16/8/21.
//  Copyright © 2016年 olakeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWExt)


//获取view所属控制器
@property (nonatomic, strong) UIViewController *viewController;



@property (nonatomic, assign) CGFloat xw_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat xw_top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat xw_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat xw_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat xw_width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat xw_height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat xw_centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat xw_centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint xw_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  xw_size;        ///< Shortcut for frame.size.

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;
//截图
-(UIImage *)screenShot;


-(id)xw_tableView;

-(id)xw_componentView;

/**
 *  @brief  找到指定类名的SubView对象
 *
 *  @param clazz SubVie类名
 *
 *  @return view对象
 */
- (id)xw_subViewByClass:(Class)clazz;

/**
 *  @brief  找到指定tag的SubView对象
 *
 *  @param tag  view -- tag
 *
 *  @return view对象
 */
- (id)xw_subViewByTag:(NSInteger )tag;
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)xw_superViewByClass:(Class)clazz;


/**
 *  @brief  找到并且resign第一响应者
 *
 *  @return 结果
 */
- (BOOL)xw_findAndResignFirstResponder;
/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)xw_findFirstResponder;



@end
