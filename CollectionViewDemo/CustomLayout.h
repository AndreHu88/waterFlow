//
//  CustomLayout.h
//  CollectionViewDemo
//
//  Created by Jack on 2018/1/2.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYWaterFlowLayoutDelegate <NSObject>

- (CGFloat)cellLayoutHeightAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat )itemWidth;

@end

@interface CustomLayout : UICollectionViewLayout

/** 列数 */
@property (nonatomic,assign) CGFloat columnNumbers;
/** 每列的间距 */
@property (nonatomic,assign) CGFloat cellDistance;
/** cell的上下间距 */
@property (nonatomic,assign) CGFloat cellBottomDistance;
/** 头视图高度 */
@property (nonatomic,assign) CGFloat headerHeight;
/** 尾视图高度 */
@property (nonatomic,assign) CGFloat footerHeight;
/** delegate */
@property (nonatomic,weak) id<HYWaterFlowLayoutDelegate> delegate;

@end
