//
//  UIView+XWCorner.h
//  WJSCategory
//
//  Created by 王剑石 on 16/5/27.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWCorner)

-(void)corner:(UIColor *)color;

-(void)corner:(UIColor *)color radius:(NSInteger) radius;

-(void)corner:(UIColor *)color radius:(NSInteger) radius borderWidth:(CGFloat) borderWidth;

-(void)corner:(NSInteger) radius cornerType:(UIRectCorner )corner;

@end
