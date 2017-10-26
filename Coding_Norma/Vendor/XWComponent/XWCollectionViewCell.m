//
//  XWCollectionViewCell.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWCollectionViewCell.h"
#import "XWReuseDataBase.h"

@implementation XWCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}



-(void)setDefaultColor:(UIColor *)defaultColor{
    _defaultColor = defaultColor;
    
    
    
    self.contentView.backgroundColor = defaultColor;
    
}

-(UIColor *)heightColor{
    
    if (_heightColor == nil) {
        
        _heightColor = self.defaultColor;
    }
    
    return _heightColor;
}



// 可以重写 可以不用重写
-(void) createUI{
    if (!([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)) {
        self.bounds = CGRectMake(0, 0, 9999, 9999);
        self.contentView.bounds = CGRectMake(0, 0, 9999, 9999);
    }
}


// 需要重写
-(void) reuseWithData:(XWReuseDataBase *) data indexPath:(NSIndexPath *) indexPath{
    self.data = data;
    self.indexPath = indexPath;
    self.reuseTimes++;
}

-(CGSize)cellSize{
    
    CGFloat width = [self cellWidth];
    CGFloat height = [self cellHeight];
    if (width) {
        self.width = width;
    }
    if (height){
        self.height = height;
    }
    if (width && height) {
        return CGSizeMake(width, height);
    }
    if (!width && !height) {
        width = kScreenWidth;
        self.width = width;
    }
    
    CGSize size = [self contentViewSize];
    if (width) {
        size.width = width;
    }
    if (height) {
        size.height = height;
    }
    self.data.height = size.width;
    self.data.width = size.height;
    return size;
}

-(CGFloat)cellWidth{
    return 0;
}

-(CGFloat) cellHeight{
    return 0;
}

-(CGSize) contentViewSize{
    
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}


-(void) refresh{
}

-(void)selectedCell{
    
}

@end
