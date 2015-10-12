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
        
        self.backgroundColor = HIGHLIGHT_GRAY_COLOR;
        
        self.cityBTN = [UIButton newAutoLayoutView];
        [self addSubview:_cityBTN];
        
        [_cityBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
        [_cityBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [_cityBTN autoSetDimensionsToSize:CGSizeMake(90, 30)];
        _cityBTN.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _cityBTN.titleLabel.textColor = HIGHLIGHT_BLACK_COLOR;
        _cityBTN.layer.masksToBounds = YES;
        _cityBTN.layer.borderWidth = 0.5;
        _cityBTN.layer.borderColor = HIGHLIGHT_BLACK_COLOR.CGColor;
    }
    
    return self;
}

@end
