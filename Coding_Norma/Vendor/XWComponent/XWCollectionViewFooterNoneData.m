//
//  XWCollectionViewFooterNoneData.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionViewFooterNoneData.h"

@implementation XWCollectionViewFooterNoneData

-(NSString *) reuseIdentifier{
    return @"XWCollectionViewFooterClear";
}

-(CGFloat)width{
    if ([super width] == 0) {
        return 0.001;
    }
    return  [super width];
}

-(CGFloat)height {
    if ([super height] == 0) {
        return 0.001;
    }
    return [super height];
}

@end
