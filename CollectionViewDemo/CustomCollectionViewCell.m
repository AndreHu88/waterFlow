//
//  CustomCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by Jack on 2018/1/2.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import <Masonry.h>

@interface CustomCollectionViewCell ()


@end

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor orangeColor];

    }
    return self;
}

- (void)prepareForReuse{
    
    [super prepareForReuse];
    self.imgView.image = nil;
}

- (void)layoutSubviews{
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.left.bottom.equalTo(self);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - lazyload
- (UIImageView *)imgView{
    
    if (!_imgView) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame), self.frame.size.width, self.frame.size.height - 30)];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
        _titleLabel.backgroundColor = [UIColor lightGrayColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
