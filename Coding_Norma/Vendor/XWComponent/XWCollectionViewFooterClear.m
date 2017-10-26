//
//  XWCollectionViewFooterClear.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionViewFooterClear.h"

@implementation XWCollectionViewFooterClear

-(void)createUI{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
}

-(CGSize)viewSize{
    return CGSizeZero;
}

@end
