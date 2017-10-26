//
//  XWHeaderReuseDataBase.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWHeaderReuseDataBase.h"

@interface XWHeaderReuseDataBase ()

@property(nonatomic , copy)  NSString * defaultReuseIndentiferStr;

@end

@implementation XWHeaderReuseDataBase

-(NSString *)reuseIdentifier{
    return self.defaultReuseIndentiferStr;
}

-(NSString *)defaultReuseIndentiferStr{
    if (!_defaultReuseIndentiferStr) {
        NSString * name = [NSString stringWithUTF8String:object_getClassName(self)];
         name = [name substringToIndex:[name length] - 4];
         name = [name stringByAppendingString:@"View"];
        _defaultReuseIndentiferStr = name;
    }
    return _defaultReuseIndentiferStr;
}



@end
