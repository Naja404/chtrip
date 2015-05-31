//
//  AddTripFrontTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddTripFrontTableViewCell.h"

@implementation AddTripFrontTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.frontImgView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_frontImgView];
        
        [_frontImgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_frontImgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_frontImgView autoSetDimensionsToSize:CGSizeMake(140, 140)];
        _frontImgView.backgroundColor = [UIColor grayColor];
        
        self.noteLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_noteLB];
        
        [_noteLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_frontImgView  withOffset:20.0];
        [_noteLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_frontImgView];
        [_noteLB autoSetDimensionsToSize:CGSizeMake(150, 50)];
        
        _noteLB.text = NSLocalizedString(@"TEXT_ADD_FRONT_IMAGE", Nil);
        _noteLB.textColor = [UIColor grayColor];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
