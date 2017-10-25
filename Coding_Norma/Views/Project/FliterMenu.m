//
//  FliterMenu.m
//  Coding_Norma
//
//  Created by 0390 on 2017/10/24.
//  Copyright © 2017年 norma. All rights reserved.
//

#import "FliterMenu.h"
@interface FliterMenu()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *menuDic;
@property (nonatomic,strong)NSArray *itemArray;
@end

@implementation FliterMenu

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
    
}



-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
   return  self.menuDic.allKeys.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"section%ld",section];
    self.itemArray = self.menuDic[key];
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
