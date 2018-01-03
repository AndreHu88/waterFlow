//
//  CustomLayout.m
//  CollectionViewDemo
//
//  Created by Jack on 2018/1/2.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()

/** 保存cell布局 */
@property (nonatomic,strong) NSMutableDictionary *cellLayoutDict;
/** 图视图布局对象 */
@property (nonatomic,strong) NSMutableDictionary *headerLayoutDict;
/** 尾视图布局对象 */
@property (nonatomic,strong) NSMutableDictionary *footerLayoutDict;
/** 保存每列cell底部y值 */
@property (nonatomic,strong) NSMutableDictionary *bottomYDict;
/** 起始值 */
@property (nonatomic,assign) CGFloat startY;

@end

@implementation CustomLayout

static NSString *sectionHeaderIdentifier = @"sectionHeaderIdentifier";
static NSString *sectionFooterIdentifier = @"sectionFooterIdentifier";

- (instancetype)init{
    
    if (self = [super init]) {
        
        // 初始化各种参数
        self.columnNumbers = 4;
        self.cellDistance = 10;
        self.cellBottomDistance = 10;
        self.startY = 0;
        self.headerHeight = 0;
        self.footerHeight = 0;
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    //每次布局前清空之前的布局
    [self.cellLayoutDict removeAllObjects];
    [self.headerLayoutDict removeAllObjects];
    [self.footerLayoutDict removeAllObjects];
    [self.bottomYDict removeAllObjects];
    self.startY = 0;
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat itemWidth = (collectionViewWidth - self.cellDistance * (self.columnNumbers + 1)) / self.columnNumbers;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        //如果头视图的高度不为0，并且根据响应了代理方法
        if (self.headerHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:sectionHeaderIdentifier withIndexPath:headerIndexPath];
            attribute.frame = CGRectMake(0, self.startY, collectionViewWidth, self.headerHeight);
            //保存header的布局对象
            self.headerLayoutDict[headerIndexPath] = attribute;
            self.startY += self.headerHeight;
        }
        else{
            self.startY += self.cellDistance;
        }
        
        //设置cell第一行的Y值
        for (NSInteger i = 0; i < self.columnNumbers; i++) {
            
            self.bottomYDict[@(i)] = @(self.startY);
        }
        
        //计算cell的布局
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
            
            //获取y的值
            CGFloat y = [self.bottomYDict[@(0)] floatValue];
            NSInteger currentColumn = 0;
            for (NSInteger i = 1; i < self.columnNumbers; i++) {
                
                if ([self.bottomYDict[@(i)] floatValue] < y) {
                    y = [self.bottomYDict[@(i)] floatValue];
                    currentColumn = i;
                }
            }
            //计算x值
            CGFloat x = self.cellDistance + (self.cellDistance + itemWidth) * currentColumn;
            CGFloat height = [self.delegate cellLayoutHeightAtIndexPath:itemIndexPath itemWidth:itemWidth] + 30;
            layoutAttributes.frame = CGRectMake(x, y, itemWidth, height);
            //重新设置当前列的Y值
            y = y + self.cellDistance + height;
            self.bottomYDict[@(currentColumn)] = @(y);
            //保存cell的布局对象
            self.cellLayoutDict[itemIndexPath] = layoutAttributes;
            
            //如果是section的最后一个cell，取最后一排cell的底部的最大值
            if (item == itemCount - 1) {
                
                CGFloat maxY = [self.bottomYDict[@(0)] floatValue];
                for (NSInteger i = 1; i < self.columnNumbers; i++) {
                    
                    if ([self.bottomYDict[@(i)] floatValue] > y) {
                        maxY = [self.bottomYDict[@(i)] floatValue];
                    }
                }
                self.startY = maxY + self.cellBottomDistance;
            }
        }
        
        //存储footer属性
        if (self.footerHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:sectionFooterIdentifier withIndexPath:headerIndexPath];
            footerAttribute.frame = CGRectMake(0, self.startY, collectionViewWidth, self.footerHeight);
            self.footerLayoutDict[headerIndexPath] = footerAttribute;
            self.startY += self.footerHeight;
        }
        
    }
}

/**
 *  返回当前的布局对象数组,必须要实现
*/
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributeArray = [NSMutableArray array];
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributeArray addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的头视图的布局
    [self.headerLayoutDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributeArray addObject:attribute];
        }
    }];
    
    //添加当前屏幕可见的尾部的布局
    [self.footerLayoutDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributeArray addObject:attribute];
        }
    }];
    
    return attributeArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *itemAttribute = self.cellLayoutDict[indexPath];
    return itemAttribute;
}

//返回当前的currentSize
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}

#pragma mark - lazyload
- (NSMutableDictionary *)cellLayoutDict{
    
    if (!_cellLayoutDict) {
        
        _cellLayoutDict = [NSMutableDictionary dictionary];
    }
    return _cellLayoutDict;
}

- (NSMutableDictionary *)headerLayoutDict{
    
    if (!_headerLayoutDict) {
        
        _headerLayoutDict = [NSMutableDictionary dictionary];
    }
    return _headerLayoutDict;
}

- (NSMutableDictionary *)footerLayoutDict{
    
    if (!_footerLayoutDict) {
        
        _footerLayoutDict = [NSMutableDictionary dictionary];
    }
    return _footerLayoutDict;
}

- (NSMutableDictionary *)bottomYDict{
    
    if (!_bottomYDict) {
        
        _bottomYDict = [NSMutableDictionary dictionary];
    }
    return _bottomYDict;
}

@end
