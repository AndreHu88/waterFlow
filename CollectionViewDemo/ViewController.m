//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by Jack on 2018/1/2.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "ViewController.h"
#import "CustomLayout.h"
#import "CustomCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,HYWaterFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageNameArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterFlowCell" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:self.imageNameArray[indexPath.item]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return cell;
}

#pragma mark - cellHeighDelegate
- (CGFloat)cellLayoutHeightAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    
    UIImage *image = [UIImage imageNamed:self.imageNameArray[indexPath.item]];
    CGFloat height = image.size.height / image.size.width * itemWidth;
    return height;
}


#pragma mark - lazyload
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        CustomLayout *layout = [[CustomLayout alloc] init];
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"waterFlowCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)imageNameArray{
    
    if (!_imageNameArray) {
        
        _imageNameArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 100; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i % 7];
            [_imageNameArray addObject:imageName];
        }
    }
    return _imageNameArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
