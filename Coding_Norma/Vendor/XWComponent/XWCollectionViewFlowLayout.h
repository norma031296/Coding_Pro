//
//  XWCollectionViewFlowLayout.h
//  OlaDriver
//
//  Created by 王剑石 on 16/9/6.
//  Copyright © 2016年 olakeji. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    XWCollectionViewFlowLayoutTypePlain,    // 普通布局
    XWCollectionViewFlowLayoutTypeStickHeader,// 头部悬浮 布局
    XWCollectionViewFlowLayoutTypeWaterfall,// 瀑布流
    XWCollectionViewFlowLayoutStretchyHeader,// 头部拉伸
} XWCollectionViewFlowLayoutType;

@interface XWCollectionViewFlowLayout : UICollectionViewFlowLayout

@property(nonatomic , assign) XWCollectionViewFlowLayoutType layoutType;

@end
