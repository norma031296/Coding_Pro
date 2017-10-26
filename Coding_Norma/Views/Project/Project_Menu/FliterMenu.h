//
//  FliterMenu.h
//  Coding_Norma
//
//  Created by 0390 on 2017/10/24.
//  Copyright © 2017年 norma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FliterMenuType){
    FliterMenuTypeAll,
    FliterMenuTypeCreated,
    FliterMenuTypeJoin,
    FliterMenuTypeFollow,
    FliterMenuTypeCollect,
    FliterMenuTypeProjectSquare
};

@interface FliterMenu : UIView

- (instancetype)initWithFrame:(CGRect)frame Items : (NSArray *)items;
@property (nonatomic,assign)BOOL showStatus;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,copy)void (^clickMenuBlock)(NSInteger selectIndex);
@property (nonatomic,copy)void (^dismissMenuBlock)(void);

@end
