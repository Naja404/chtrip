//
//  AddSubTripTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/13.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddSubTripTableViewCell.h"

@implementation AddSubTripTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.iconImgView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconImgView];
        
        [_iconImgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_iconImgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_iconImgView autoSetDimensionsToSize:CGSizeMake(20.0, 16.0)];
        
        self.inputField = [UITextField newAutoLayoutView];
        [self.contentView addSubview:_inputField];
        
        [_inputField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconImgView withOffset:30.0];
        [_inputField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [_inputField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_inputField autoSetDimension:ALDimensionHeight toSize:20.0];
        
        _inputField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
//        _inputField.userInteractionEnabled = NO;
        _inputField.returnKeyType = UIReturnKeyDone;

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
