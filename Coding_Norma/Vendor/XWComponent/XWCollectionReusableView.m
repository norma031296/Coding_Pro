//
//  XWCollectionReusableView.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionReusableView.h"

@implementation XWCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
}

-(void)reuseWithData:(XWReuseDataBase *)data section:(NSInteger)section isHeader:(BOOL)bHeader{
    self.data = data;
    self.section = section;
    self.bHeader = bHeader;
}

-(CGFloat)viewHeight{
    return 0;
}

-(CGFloat)viewWidth{
    return 0;
}

-(CGSize)viewSize{
    
    return CGSizeZero;
}
-(void)refresh{
    
}

@end
