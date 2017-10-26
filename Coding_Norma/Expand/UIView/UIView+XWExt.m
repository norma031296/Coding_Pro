//
//  UIView+XWExt.m
//  OlaDriver
//  Created by 王剑石 on 16/8/21.
//  Copyright © 2016年 olakeji. All rights reserved.
//

#import "UIView+XWExt.h"
#import "XWComponentView.h"
#import <objc/runtime.h>

@implementation UIView (XWExt)

///** 获取当前View的控制器对象 */

//使用关联向分类中添加一个当前控制器的属性
-(void)setViewController:(UIViewController *)viewController{
    objc_setAssociatedObject(self, @selector(viewController),viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController *)viewController{
    id vc= objc_getAssociatedObject(self, _cmd);
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            vc= (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return vc;
}



-(id)xw_tableView{
    
    if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:[UITableView class]]) {
        return self.superview;
    } else {
        return [self.superview xw_tableView];
    }

}


-(id)xw_componentView{
    
    if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:[XWComponentView class]]) {
        return self.superview;
    } else {
        return [self.superview xw_componentView];
    }
    
}

- (CGFloat)xw_left {
    return self.frame.origin.x;
}

-(void)setXw_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)xw_top {
    return self.frame.origin.y;
}

- (void)setXw_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)xw_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXw_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xw_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXw_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xw_width {
    return self.frame.size.width;
}

- (void)setXw_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)xw_height {
    return self.frame.size.height;
}

- (void)setXw_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)xw_centerX {
    return self.center.x;
}


- (void)setXw_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)xw_centerY {
    return self.center.y;
}

- (void)setXw_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)xw_origin {
    return self.frame.origin;
}

- (void)setXw_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)xw_size {
    return self.frame.size;
}

- (void)setXw_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    // 若view 隐藏 ,若没有superview ,若size为CGrectZero
    if (self.hidden||self.superview == nil||CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return FALSE;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}


//截图
-(UIImage *)screenShot{
    
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    return viewImage;
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
//    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
//    {
//        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
//    }
//    else
//    {
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    }
//    
//    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return screenshot;
    
}
/**
 *  @brief  找到指定类名的view对象(递归查找，返回层级比较高的那个subview)
 *
 *  @param clazz view类名
 *
 *  @return view对象
 */
- (id)xw_subViewByClass:(Class)clazz
{
    if (self.subviews.count == 0) {
        return nil;
    }
    else{
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:clazz]) {
                return subView;
            }
            else if(subView.subviews.count != 0){
                return [subView xw_subViewByClass:clazz];
            }
        }
    }
    
    return nil;
}
/**
 *  @brief  找到指定tag的view对象
 *
 *  @param tag view--tag
 *
 *  @return view对象
 */
- (id)xw_subViewByTag:(NSInteger)tag
{
    if (self.tag == tag) {
        return self;
    }
    else if ([self viewWithTag:tag]) {
        return [self viewWithTag:tag];
    }
    else{
        if (self.subviews.count == 0) {
            return nil;
        }
        
        for (UIView *subView in self.subviews) {
            if ([subView viewWithTag:tag]) {
                return [subView viewWithTag:tag];
            }
            else if(subView.subviews.count != 0){
                return [subView xw_subViewByTag:tag];
            }
        }
        
    }
    
    return nil;
}
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)xw_superViewByClass:(Class)clazz
{
    if (self == nil) {
        return nil;
    } else if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    } else {
        return [self.superview xw_superViewByClass:clazz];
    }
}
/**
 *  @brief  找到并且resign第一响应者
 *
 *  @return 结果
 */
- (BOOL)xw_findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *v in self.subviews) {
        if ([v xw_findAndResignFirstResponder]) {
            return YES;
        }
    }
    
    return NO;
}
/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)xw_findFirstResponder {
    
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
        && (self.isFirstResponder)) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *fv = [v xw_findFirstResponder];
        if (fv) {
            return fv;
        }
    }
    
    return nil;
}




@end
