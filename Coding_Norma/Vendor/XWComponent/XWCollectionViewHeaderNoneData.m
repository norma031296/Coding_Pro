//
//  XWCollectionViewHeaderNoneData.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionViewHeaderNoneData.h"

@implementation XWCollectionViewHeaderNoneData

-(NSString *) reuseIdentifier{
    return @"XWCollectionviewHeaderClear";
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
