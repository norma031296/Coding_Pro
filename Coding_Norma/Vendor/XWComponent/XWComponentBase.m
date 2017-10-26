//
//  XWComponentBase.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWComponentBase.h"
#import "XWCollectionViewFooterNoneData.h"
#import "XWCollectionViewHeaderNoneData.h"
#import "XWDecorationViewClear.h"

@interface XWComponentBase ()

@property(nonatomic , assign) BOOL firstInit;

@end

@implementation XWComponentBase

@synthesize headerData = _headerData;
@synthesize footerData = _footerData;
@synthesize cellDataList = _cellDataList;
@synthesize decorationViewClass = _decorationViewClass;

-(instancetype)init{
    self = [super init];
    if (self) {
        self.firstInit =  true;
    }
    return self;
}

/**
 *  初始化继承这个
 */
-(void) initConfig{
    
}

/**
 *   optional to overriding
 *   重写时 不要 调用父类该方法
 *   上拉刷新
 */
-(void) requestUpRefresh{
    self.needRequst = false;
   // self.refreshResult = QLXRefreshResultDefault;
   // [self.multiWidgetView requestFinish];
    // [self requestFinish];
}

/**
 *  下拉刷新
 *   重写时 不要 调用父类该方法
 */
-(void) requestDropRefresh{
    self.needRequst = false;
    //self.refreshResult = QLXRefreshResultDefault;
   // [self.multiWidgetView requestFinish];
    //  [self requestFinish];
}

-(void)requestFinish{
    self.needRequst = false;
   // self.refreshResult = QLXRefreshResultSuccess;
   // [self.multiWidgetView requestFinish];
}

-(void)requestNoMoreData{
    self.needRequst = false;
   // self.refreshResult = QLXRefreshResultNoMoreData;
   // [self.multiWidgetView requestNoMoreData];
}

-(void)requestFail{
    self.needRequst = false;
    //self.refreshResult = QLXRefreshResultFail;
   // [self.multiWidgetView requestFail];
}



-(void)setMultiWidgetView:(XWComponentView *)multiWidgetView{
    // QLXAssert(_multiWidgetView == nil, @"只能设置一次");
    _multiWidgetView = multiWidgetView;
    if (self.firstInit) {
        self.firstInit = false;
        [self initConfig];
    }
}

-(XWHeaderReuseDataBase *)headerData{
    if (!_headerData) {
        _headerData = [XWCollectionViewHeaderNoneData  new];
       
    }
    return _headerData;
}

-(void)setHeaderData:(XWHeaderReuseDataBase *)headerData{
    if (( _headerData != headerData)) {
        _headerData = headerData;
        self.headerDataList = nil;
    }
}



-(XWReuseDataBase *)footerData{
    if (!_footerData) {
        _footerData = [XWCollectionViewFooterNoneData  new];

    }
    return _footerData;
}


-(void)setFooterData:(XWReuseDataBase *)footerData{
    if ((_footerData != footerData)) {
        _footerData = footerData;
        self.footerDataList = nil;
    }
}

-(NSMutableArray<XWReuseDataBase *> *)cellDataList{
    if (!_cellDataList) {
        _cellDataList = [NSMutableArray new];
    }
    return _cellDataList;
}

-(void)setCellDataList:(NSMutableArray<XWReuseDataBase *> *)cellDataList{
    if (_cellDataList != cellDataList) {
        _cellDataList = cellDataList;
        self.twoDimensionCellDataList = nil;
    }
}

-(Class)decorationViewClass{
    if (!_decorationViewClass) {
        _decorationViewClass = [XWDecorationViewClear class];
    }
    return _decorationViewClass;
}

//@property(nonatomic , strong) NSMutableArray<HeaderReuseDataBase *> * headerDataList;
//@property(nonatomic , strong) NSMutableArray<HeaderReuseDataBase *> * twoDimensionCellDataList;
//@property(nonatomic , strong) NSMutableArray<ReuseDataBase *> * footerDataList;
//@property(nonatomic , strong) NSMutableArray<Class> * decorationViewClassList;


-(NSMutableArray<XWHeaderReuseDataBase *> *)headerDataList{
    if (!_headerDataList) {
        _headerDataList = [[NSMutableArray alloc] initWithObjects:self.headerData, nil];
    }
    if (_headerDataList.count < self.twoDimensionCellDataList.count) {
        while (_headerDataList.count < self.twoDimensionCellDataList.count) {
            [_headerDataList addObject:self.headerData];
        }
    }
    return _headerDataList;
}

-(NSMutableArray<XWReuseDataBase *> *)footerDataList{
    if (!_footerDataList) {
        _footerDataList = [[NSMutableArray alloc] initWithObjects:self.footerData, nil];
    }
    if (_footerDataList.count < self.headerDataList.count) {
        while (_footerDataList.count < self.headerDataList.count) {
            [_footerDataList addObject:self.footerData];
        }
    }else if(_footerDataList.count > self.headerDataList.count){
        while (_footerDataList.count > self.headerDataList.count) {
            [_footerDataList removeLastObject];
        }
    }
    return _footerDataList;
}


-(NSMutableArray<NSMutableArray<XWReuseDataBase *> *> *)twoDimensionCellDataList{
    if (!_twoDimensionCellDataList) {
        return  _twoDimensionCellDataList = [[NSMutableArray alloc] initWithObjects:self.cellDataList, nil];
    }
    return _twoDimensionCellDataList;
}

-(NSMutableArray<Class> *)decorationViewClassList{
    if (!_decorationViewClassList) {
        _decorationViewClassList = [[NSMutableArray alloc] initWithObjects:self.decorationViewClass, nil];
    }
    if (_decorationViewClassList.count < self.headerDataList.count) {
        while (_decorationViewClassList.count < self.headerDataList.count) {
            [_decorationViewClassList addObject:self.decorationViewClass];
        }
    }else if(_decorationViewClassList.count > self.headerDataList.count){
        while (_decorationViewClassList.count > self.headerDataList.count) {
            [_decorationViewClassList removeLastObject];
        }
    }
    return _decorationViewClassList;
}


-(void)setDecorationViewClass:(Class)decorationViewClass{
    if (_decorationViewClass != decorationViewClass) {
        _decorationViewClass = decorationViewClass;
        if (self.decorationViewClassList.count == 1) {
            [self.decorationViewClassList replaceObjectAtIndex:0 withObject:_decorationViewClass];
        }
    }
}



@end
