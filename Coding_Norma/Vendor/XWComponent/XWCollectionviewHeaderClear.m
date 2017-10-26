//
//  XWCollectionviewHeaderClear.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionviewHeaderClear.h"

@implementation XWCollectionviewHeaderClear

-(void)createUI{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
}

-(CGSize)viewSize{
    return CGSizeZero;
}

@end
