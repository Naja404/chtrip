//
//  CitySelectCollectionViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CitySelectCollectionViewCell.h"

@implementation CitySelectCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.0f;
        self.backgroundColor = GRAY_COLOR_CITY_CELL;
        
        self.cityImg = [UIImageView newAutoLayoutView];
        [self addSubview:_cityImg];
        
        [_cityImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:5];
        [_cityImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_cityImg autoSetDimensionsToSize:CGSizeMake((ScreenWidth - 60) / 2 / 2.7 - 10, (ScreenWidth - 60) / 2 / 2.7 - 10)];
        _cityImg.image = [UIImage imageNamed:@"defaultPic.jpg"];
        
        self.cityLB = [UILabel newAutoLayoutView];
        [self addSubview:_cityLB];
        
        [_cityLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_cityLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self withOffset:((ScreenWidth - 60) / 2 / 2.7 / 2)];
        [_cityLB autoSetDimensionsToSize:CGSizeMake(60, 30)];
        _cityLB.font = [UIFont systemFontOfSize:16.0];
        _cityLB.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
        _cityLB.text = @"城市";
        _cityLB.textAlignment = NSTextAlignmentCenter;
        
        
        self.cityBTN = [UIButton newAutoLayoutView];
        [self addSubview:_cityBTN];
        
        [_cityBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_cityBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [_cityBTN autoSetDimensionsToSize:CGSizeMake((ScreenWidth - 60) / 2 , (ScreenWidth - 60) / 2 / 2.7)];
        _cityBTN.backgroundColor = [UIColor clearColor];

    }
    
    return self;
}

@end
