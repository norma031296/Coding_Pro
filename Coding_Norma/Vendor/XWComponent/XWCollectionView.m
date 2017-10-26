//
//  XWCollectionView.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/10.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#ifdef DEBUG
//#define XWAssert(condition)  if(!(condition)){ assert(0);}
#else
#define XWAssert(condition)
#endif

#import "XWCollectionView.h"
#import "XWCollectionViewCell.h"
#import "XWCollectionReusableView.h"
#import "XWCollectionViewFlowLayout.h"

@interface XWCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionViewLayout *layout;

@property (nonatomic, copy) NSString * cellReuseIdentifier;

@property (nonatomic, copy) NSString * headerReuseIdentifier;

@property (nonatomic, copy) NSString * footerReuseIdentifier;

@property (nonatomic, strong) NSMutableDictionary * cacheCellDic;

@property (nonatomic, strong) NSMutableDictionary * cacheHeaderDic;

@property (nonatomic, strong) NSMutableDictionary * cacheFooterDic;



@end

@implementation XWCollectionView

+(instancetype) createWithLayout:(UICollectionViewLayout *)layout{
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

+(instancetype) createWithFlowLayout{
    UICollectionViewFlowLayout * layout = [XWCollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self createWithLayout:layout];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.layout = layout;
        
        [self initConfig];
    }
    return self;
}

-(void) initConfig{
    self.backgroundColor = [UIColor clearColor];
    self.bounces = YES;
    self.alwaysBounceVertical = YES;
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark -- cell注册


-(UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    [self registerCellClassIfNeedWithIdentifier:identifier];
    return [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

-(void) registerCellClassIfNeedWithIdentifier:(NSString *) identifier{
    if (identifier) {
        XWCollectionViewCell * cacheCell = [self.cacheCellDic objectForKey:identifier];
        if (!cacheCell) {
            Class cellClass = NSClassFromString(identifier);
            [self registerCellClass:cellClass];
            [self.cacheCellDic setObject:cellClass forKey:identifier];
        }
    }
}
-(void) registerHeaderClassIfNeedWithIdentifier:(NSString *) identifier{
    if (identifier) {
        XWCollectionReusableView * cacheHeader = [self.cacheHeaderDic objectForKey:identifier];
        if (!cacheHeader) {
            Class headerClass = NSClassFromString(identifier);
            [self registerHeaderClass:headerClass];
            [self.cacheHeaderDic setObject:headerClass forKey:identifier];
        }
    }
}
-(void) registerFooterClassIfNeedWithIdentifier:(NSString *) identifier{
    if (identifier) {
        XWCollectionReusableView * cacheFooter = [self.cacheFooterDic objectForKey:identifier];
        if (!cacheFooter) {
            Class footerClass = NSClassFromString(identifier);
            //XWAssert(footerClass); //identifier 错误 不是类名
            [self registerFooterClass:footerClass];
            [self.cacheFooterDic setObject:footerClass forKey:identifier];
        }
    }
}

-(void)registerCellClass:(Class)cellClass {
    self.cellReuseIdentifier = NSStringFromClass(cellClass);
    [self registerClass:cellClass forCellWithReuseIdentifier:self.cellReuseIdentifier];
}
-(void) registerHeaderClass:(Class) headerClass{
    
    self.headerReuseIdentifier = NSStringFromClass(headerClass);
    [self registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.headerReuseIdentifier];
}

-(void) registerFooterClass:(Class) footerClass{
   
    self.footerReuseIdentifier = NSStringFromClass(footerClass);
    [self registerClass:footerClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:self.footerReuseIdentifier];
}




#pragma mark UICollectionViewDataSourceDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.dataSourceDelegate respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.dataSourceDelegate numberOfSectionsInCollectionView:collectionView];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
            NSArray * array = [self.dataSourceDelegate headerDataListWithCollectionView:self];
            if (array) {
                return array.count;
            }else {
                return 0;
            }
        }
        if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithCollectionView:)]) {
            NSArray * array = [self.dataSourceDelegate cellDataListWithCollectionView:self];
            if (array.count > 0) {
                if ([[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                    return array.count;
                }else {
                    return 1;
                }
            }else {
                return 1;
            }
        }
    }
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.dataSourceDelegate collectionView:collectionView numberOfItemsInSection:section];
    }else {
        NSArray * array = [self getSecionDataListWithSection:section] ;
        if (array) {
            return array.count;
        }
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSourceDelegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }else {
        id data = [[self getSecionDataListWithSection:indexPath.section] objectAtIndex:indexPath.row];
        if (data) {
            XWReuseDataBase * reuseData = (XWReuseDataBase *)data;
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.cellReuseIdentifier;
            }
            XWCollectionViewCell * cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.collectionView = self;
            if (![reuseData isMemberOfClass:[XWReuseDataBase class]]) {
                [cell reuseWithData:reuseData indexPath:indexPath];
            }
            //cell.delegate = self.cellDelegate;
            return cell;
        }
    }
    [self registerCellClassIfNeedWithIdentifier:@"XWCollectionViewCell"];
    return [self dequeueReusableCellWithReuseIdentifier:@"XWCollectionViewCell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    XWCollectionViewCell * cell = (XWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XWCollectionViewCell class]]) {
        [cell selectedCell];
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        
        [self.dataSourceDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }

}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSourceDelegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [self getHeaderViewWithIndexPath:indexPath kind:kind];
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            return [self getFooterViewWithIndexPath:indexPath kind:kind];
        }
    }
    return nil;
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWCollectionViewCell  *cell = (XWCollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    
    cell.defaultColor = cell.contentView.backgroundColor;
    if (cell.selectionStyle == XWCollectionViewCellSelectionStyleNone) {
        
        [cell.contentView setBackgroundColor:cell.contentView.backgroundColor];
    }else if (cell.selectionStyle == XWCollectionViewCellSelectionStyleBlue){
        
        [cell.contentView setBackgroundColor:[UIColor blueColor]];
    }else{
        
        [cell.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWCollectionViewCell* cell = (XWCollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell.contentView setBackgroundColor:cell.defaultColor];
}

#pragma mark UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }else {
        id data = [[self getSecionDataListWithSection:indexPath.section] objectAtIndex:indexPath.row];
        if (data) {
           XWReuseDataBase  * reuseData = ((XWReuseDataBase  *)data);
           // QAssert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
            [self registerCellClassIfNeedWithIdentifier:[reuseData reuseIdentifier]];
            if (reuseData.height == 0 || reuseData.width == 0) {
                XWCollectionViewCell * cacheCell = [self getCacheCellWithReuseIdentifier:[reuseData reuseIdentifier]];
                
                
                if (!cacheCell.dynamicCellSize && (cacheCell.data.height > 0 && cacheCell.data.width > 0)) {
                    reuseData.width = cacheCell.data.width;
                    reuseData.height = cacheCell.data.height;
                    return CGSizeMake(cacheCell.data.width, cacheCell.data.height);
                }
                [cacheCell reuseWithData:reuseData indexPath:indexPath];
                CGSize size =  [cacheCell cellSize];
                reuseData.width = size.width;
                reuseData.height = size.height;
                return size;
            }
            return CGSizeMake(reuseData.width, reuseData.height);
        }
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self]) {
        NSArray * list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            XWHeaderReuseDataBase * data = [list objectAtIndex:section];
            if ([data isKindOfClass:[XWHeaderReuseDataBase class]]) {
                return data.secionInset;
            }
        }
    }
    
    if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return ((UICollectionViewFlowLayout *)self.layout).sectionInset ;
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self]) {
        NSArray * list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            XWHeaderReuseDataBase * data = [list objectAtIndex:section];
            if ([data isKindOfClass:[XWHeaderReuseDataBase class]]) {
                return data.minimumLineSpacing;;
            }
        }
    }
    
    if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return ((UICollectionViewFlowLayout *)self.layout).minimumLineSpacing ;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self]) {
        NSArray * list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            XWHeaderReuseDataBase * data = [list objectAtIndex:section];
            if ([data isKindOfClass:[XWHeaderReuseDataBase class]]) {
                return data.minimumInteritemSpacing;;
            }
        }
    }
    
    if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return ((UICollectionViewFlowLayout *)self.layout).minimumInteritemSpacing ;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self]) {
            id data = [[self.dataSourceDelegate headerDataListWithCollectionView:self] objectAtIndex:section];
            if (data) {
                XWHeaderReuseDataBase * reuseData = ((XWHeaderReuseDataBase *)data);
               // QAssert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
                [self registerHeaderClassIfNeedWithIdentifier:[reuseData reuseIdentifier]];
                if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                    if (reuseData.width == 0 && reuseData.height == 0) {
                        CGSize size = ((UICollectionViewFlowLayout *)self.layout).headerReferenceSize ;
                        reuseData.width = size.width;
                        reuseData.height = size.height;
                    }
                }
                if (reuseData.height == 0 || reuseData.width == 0) {
                    XWCollectionReusableView * cacheHeader = [self getCacheHeaderWithReuseIdentifier:[reuseData reuseIdentifier]];
                    
                    if (!cacheHeader.dynamicViewSize && (cacheHeader.data.height > 0 && cacheHeader.data.width > 0)) {
                        reuseData.width = cacheHeader.data.width;
                        reuseData.height = cacheHeader.data.height;
                        return CGSizeMake(cacheHeader.data.width, cacheHeader.data.height);
                    }
                    
                    [cacheHeader reuseWithData:reuseData section:section isHeader:true];
                    CGSize size  = [cacheHeader viewSize];
                    reuseData.width = size.width;
                    reuseData.height = size.height;
                    return size;
                }
                return CGSizeMake(reuseData.width, reuseData.height);
            }else {
                [self registerHeaderClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
            }
        }else {
            [self registerHeaderClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
        }
    }
    //    if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
    //        return ((UICollectionViewFlowLayout *)self.layout).headerReferenceSize ;
    //    }
    return CGSizeMake(0.001, 0.001);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithCollectionView:)] && [self.dataSourceDelegate footerDataListWithCollectionView:self]) {
            id data = [[self.dataSourceDelegate footerDataListWithCollectionView:self] objectAtIndex:section];
            if (data) {
                XWReuseDataBase * reuseData = ((XWReuseDataBase *)data);
                //QAssert([data isKindOfClass:[XWComponentDataBase class]]);//要继承ReuseDataBase
                [self registerFooterClassIfNeedWithIdentifier:[reuseData reuseIdentifier]];
                
                if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                    if (reuseData.width == 0 && reuseData.height == 0) {
                        CGSize size = ((UICollectionViewFlowLayout *)self.layout).footerReferenceSize ;
                        reuseData.width = size.width;
                        reuseData.height = size.height;
                    }
                }
                
                if (reuseData.height == 0 || reuseData.width == 0) {
                    XWCollectionReusableView * cacheFooter = [self getCacheFooterWithReuseIdentifier:[reuseData reuseIdentifier]];
                    if (!cacheFooter.dynamicViewSize && (cacheFooter.data.height > 0 && cacheFooter.data.width > 0)) {
                        reuseData.width = cacheFooter.data.width;
                        reuseData.height = cacheFooter.data.height;
                        return CGSizeMake(cacheFooter.data.width, cacheFooter.data.height);
                    }
                    
                    [cacheFooter reuseWithData:reuseData section:section isHeader:false];
                    CGSize size = [cacheFooter viewSize];
                    reuseData.width = size.width;
                    reuseData.height = size.height;
                    return size;
                }
                return CGSizeMake(reuseData.width, reuseData.height);
            }else {
                [self registerFooterClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
            }
        }else {
            [self registerFooterClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
        }
    }
    //    if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
    //        return ((UICollectionViewFlowLayout *)self.layout).footerReferenceSize ;
    //    }
    return CGSizeMake(0.001, 0.001);
}


// private

/**
 *  获得cell 缓存
 */
-(XWCollectionViewCell *) getCacheCellWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.cellReuseIdentifier;
    }
    XWCollectionViewCell * cacheCell = [self.cacheCellDic objectForKey:identifier];
    if (!cacheCell || ![cacheCell isKindOfClass:[XWCollectionViewCell class]]) {
        cacheCell = [[NSClassFromString(identifier) alloc] init];
       // QLXAssert(cacheCell,@"identifier 错误 不是类名 data 未返回复用表示");
       // QAssert([cacheCell isKindOfClass:[QLXCollectionViewCell class]]);
        cacheCell.collectionView = self;
        [self.cacheCellDic setObject:cacheCell forKey:identifier];
    }
    return cacheCell;
}


-(XWCollectionReusableView *) getCacheHeaderWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.headerReuseIdentifier;
    }
    XWCollectionReusableView * cacheHeader = [self.cacheHeaderDic objectForKey:identifier];
    if (!cacheHeader || ![cacheHeader isKindOfClass:[XWCollectionReusableView class]]) {
        cacheHeader = [[NSClassFromString(identifier) alloc] init];
       // QAssert(cacheHeader);  //identifier 错误 不是类名
       // QAssert([cacheHeader isKindOfClass:[QLXCollectionReusableView class]]);
        cacheHeader.collectionView = self;
        [self.cacheHeaderDic setObject:cacheHeader forKey:identifier];
    }
    return cacheHeader;
}

-(XWCollectionReusableView *) getCacheFooterWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.footerReuseIdentifier;
    }
    XWCollectionReusableView * cacheFooter = [self.cacheFooterDic objectForKey:identifier];
    if (!cacheFooter || ![cacheFooter isKindOfClass:[XWCollectionReusableView class]]) {
        cacheFooter = [[NSClassFromString(identifier) alloc] init];
       // QAssert(cacheFooter);  //identifier 错误 不是类名
      //  QAssert([cacheFooter isKindOfClass:[QLXCollectionReusableView class]]);
        cacheFooter.collectionView = self;
        [self.cacheFooterDic setObject:cacheFooter forKey:identifier];
    }
    return cacheFooter;
}


-(XWCollectionReusableView *) getHeaderViewWithIndexPath:(NSIndexPath *) indexPath kind:(NSString *)kind{
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self].count > 0){
        id data = [[self.dataSourceDelegate headerDataListWithCollectionView:self] objectAtIndex:indexPath.section];
        if (data) {
            XWReuseDataBase * reuseData = (XWReuseDataBase *)data;
           // QAssert([data isKindOfClass:[XWComponentDataBase class]]);
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.headerReuseIdentifier;
            }
            XWCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
           // QAssert(view && [view isKindOfClass:[XWCollectionReusableView class]]);
            view.collectionView = self;
            [view reuseWithData:reuseData section:indexPath.section isHeader:true];
           // view.delegate = self.headerDelegate;
            return view;
        }
    }
    [self registerHeaderClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
    return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XWCollectionReusableView" forIndexPath:indexPath];
}

-(XWCollectionReusableView *)  getFooterViewWithIndexPath:(NSIndexPath *) indexPath kind:(NSString *)kind{
    if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithCollectionView:)] && [self.dataSourceDelegate footerDataListWithCollectionView:self].count > 0){
        id data = [[self.dataSourceDelegate footerDataListWithCollectionView:self] objectAtIndex:indexPath.section];
        if (data) {
           XWHeaderReuseDataBase * reuseData = (XWHeaderReuseDataBase *)data;
           // QAssert([data isKindOfClass:[XWComponentDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.footerReuseIdentifier;
            }
            XWCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
           // QAssert(view && [view isKindOfClass:[XWCollectionReusableView class]]);
            view.collectionView = self;
            [view reuseWithData:reuseData section:indexPath.section isHeader:false];
            //view.delegate = self.footerDelegate;
            return view;
        }
    }
    [self registerHeaderClassIfNeedWithIdentifier:@"XWCollectionReusableView"];
    return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XWCollectionReusableView" forIndexPath:indexPath];
}




-(NSMutableArray *) getSecionDataListWithSection:(NSInteger) section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithCollectionView:)]) {
        NSMutableArray * array = [self.dataSourceDelegate cellDataListWithCollectionView:self];
        if (array.count > section) {
            id dataList = [array objectAtIndex:section];
            if (![dataList isKindOfClass:[NSArray class]]) {
                if (section == 0) {
                    return array;
                }else {
                   
                }
            }else {
                return dataList;
            }
        }else {
            return  nil;
        }
    }else {
       
    }
    return nil;
}


#pragma mark -- set / get

// 缓存一个cell 来 测量相应cell 的 size

-(NSMutableDictionary *)cacheCellDic{
    if (!_cacheCellDic) {
        _cacheCellDic = [NSMutableDictionary new];
    }
    return _cacheCellDic;
}

-(NSMutableDictionary *)cacheHeaderDic{
    if (!_cacheHeaderDic) {
        _cacheHeaderDic= [NSMutableDictionary new];
    }
    return _cacheHeaderDic;
}

-(NSMutableDictionary *)cacheFooterDic{
    if (!_cacheFooterDic) {
        _cacheFooterDic = [NSMutableDictionary new];
    }
    return _cacheFooterDic;
}

@end
