//
//  UIView+XWCorner.m
//  WJSCategory
//
//  Created by 王剑石 on 16/5/27.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import "UIView+XWCorner.h"

@implementation UIView (XWCorner)


-(void)corner:(UIColor *)color
{
    [self corner:color radius:8];
}

-(void)corner:(UIColor *)color radius:(NSInteger) radius
{
    [self corner:color radius:radius borderWidth:1.0f];
}

-(void)corner:(UIColor *)color radius:(NSInteger) radius borderWidth:(CGFloat) borderWidth
{
    
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius =  radius;
    
    
}

-(void)corner:(NSInteger) radius cornerType:(UIRectCorner )corner{
    
    CGSize radio = CGSizeMake(radius, radius);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,self.width, self.height) byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath;

    self.layer.mask = masklayer;
    
}



@end
