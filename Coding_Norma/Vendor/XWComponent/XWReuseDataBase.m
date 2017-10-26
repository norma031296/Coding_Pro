//
//  XWReuseDataBase.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/19.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWReuseDataBase.h"

@interface XWReuseDataBase ()

@property(nonatomic , copy)  NSString * defaultReuseIdentifier;

@end

@implementation XWReuseDataBase

-(instancetype)init{
    self = [super init];
    if (self){
        self.height = 0;
    }
    return self;
}
-(void) heightChanged{
    self.height = 0;
}

-(NSString *) reuseIdentifier{
    return self.defaultReuseIdentifier;    //  默认复用标识 为  本身类名后面Data  替换为 Cell  的 cell标识
}

-(NSString *)defaultReuseIdentifier{
    if (!_defaultReuseIdentifier) {
        NSString * name = [NSString stringWithUTF8String:object_getClassName(self)];
        name = [name substringToIndex:[name length] - 4];
        name = [name stringByAppendingString:@"Cell"];
        _defaultReuseIdentifier = name;
    }
    return _defaultReuseIdentifier;
}


@end
