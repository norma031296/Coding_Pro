//
//  XWComponentView.m
//  XWComponentDemo
//
//  Created by 王剑石 on 16/8/11.
//  Copyright © 2016年 Avatar. All rights reserved.
//

#import "XWComponentView.h"
#import "XWComponentBase.h"
#import "XWCollectionViewFlowLayout.h"


@interface XWComponentView ()<XWCollectionViewDataSourceDelegate>

@property (nonatomic, strong) NSMutableArray * headerDataList;
@property (nonatomic, strong) NSMutableArray * cellDataList;
@property (nonatomic, strong) NSMutableArray * footerDataList;
@property (nonatomic, strong) NSMutableArray * decorationViewClassList;
@property (nonatomic, readwrite) XWCollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * widgets;

@end

@implementation XWComponentView

// init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    self.backgroundColor = [UIColor clearColor];
    //[self.collectionView constraintWithEdgeZero]
    self.headerDataList = [NSMutableArray new];
    self.cellDataList = [NSMutableArray new];
    self.footerDataList = [NSMutableArray new];
    self.decorationViewClassList = [NSMutableArray new];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)setBagColor:(UIColor *)bagColor
{
    _bagColor = bagColor;
    
    self.collectionView.backgroundColor = bagColor;
}

+ (instancetype)createWithDelgate:(id<XWComponentViewDeleagte>)delegate
{
    XWComponentView * intance = [[XWComponentView alloc] initWithDelegate:delegate];
    
    return intance;
}

#pragma mark public

- (void)addWidget:(XWComponentBase *)widget
{
    NSUInteger secion = self.widgets.count;
    [self insertWidget:widget section:secion];
}

- (NSMutableArray *)widgets
{
    if (!_widgets) {
        _widgets = [NSMutableArray new];
    }
    return _widgets;
}

- (void)insertWidget:(XWComponentBase *)widget section:(NSUInteger)section
{
    if (![widget isKindOfClass:[XWComponentBase class]]) {
        
        NSLog(@"widget 类型 不符");
        
        return;
    }
    if ([widget isKindOfClass:[XWComponentBase class]] && self.widgets.count <= section) {
        if ([self containWithWidget:widget] == false) {
            widget.multiWidgetView = self;
            [self.widgets insertObject:widget atIndex:section];
            [self delayReload];
        }
    }
}

- (void)reloadDataWithWidget:(XWComponentBase *)widget
{
    
}

- (void)requestFail
{
    
}

- (void)requestFinish
{
    
}

- (void)requestNoMoreData
{
    
}

- (void)removeWidget:(XWComponentBase *)widget
{
    if ([self.widgets containsObject:widget]) {
        [self.widgets removeObject:widget];
       // [self delayReload];
    }
}

- (BOOL)containWithWidget:(XWComponentBase *)widget
{
    return [self.widgets containsObject:widget];
}

- (BOOL)containWithWidgetClass:(Class)aClass
{
    for (XWComponentBase *sub in self.widgets) {
        if ([sub isMemberOfClass:aClass]) {
            return true;
        }
    }
    return false;
}

// 刷新
- (void)reloadData
{
    self.headerDataList = [NSMutableArray new];
    self.cellDataList = [NSMutableArray new];
    self.footerDataList = [NSMutableArray new];
    self.decorationViewClassList = [NSMutableArray new];
    for (XWComponentBase * widget in self.widgets) {
        [self.headerDataList addObjectsFromArray:widget.headerDataList];
        [self.cellDataList addObjectsFromArray:widget.twoDimensionCellDataList];
        [self.footerDataList addObjectsFromArray:widget.footerDataList];
        [self.decorationViewClassList addObjectsFromArray:widget.decorationViewClassList];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.collectionView reloadData];
        
    }];
}

#pragma mark - private

- (void)delayReload
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (void)dealloc
{
    
}

#pragma mark - getter

- (XWCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [self getCollectionView];
        if (!_collectionView) {
            _collectionView = [[XWCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self getCollectionViewLayout]];
            _collectionView.dataSourceDelegate = self;
            _collectionView.showsVerticalScrollIndicator = NO;
            // _collectionView.collectionViewDelegate = self;
            _collectionView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_collectionView];
        }
    }
    return _collectionView;
}

- (UICollectionViewLayout *)getCollectionViewLayout
{
    if ([self.delegate respondsToSelector:@selector(collectionViewLayoutWithMultiWidgetView:)]) {
        return [self.delegate collectionViewLayoutWithMultiWidgetView:self];
    }
    // 默认流布局
    XWCollectionViewFlowLayout * layout = [XWCollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}

- (XWCollectionView *)getCollectionView
{
    return nil;
}

#pragma mark - QLXCollectionViewDataSourceDelegate

- (NSMutableArray<XWHeaderReuseDataBase *> *)headerDataListWithCollectionView:(XWCollectionView *)collectionView
{
    return self.headerDataList;
}

- (NSMutableArray<XWReuseDataBase *> *)cellDataListWithCollectionView:(XWCollectionView *)collectionView
{
    return self.cellDataList;
}

- (NSMutableArray<XWReuseDataBase *> *)footerDataListWithCollectionView:(XWCollectionView *)collectionView
{
    return self.footerDataList;
}

- (NSMutableArray<Class> *)decorationViewClassListWithCollectionView:(XWCollectionView *)collectionView
{
    return self.decorationViewClassList;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return true;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    return true;
}// called when the user taps on an already-selected item in multi-select mode

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //  self.scrolling = true;
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

@end
