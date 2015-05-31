//
//  AddSubTripEndTimeTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/13.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddSubTripEndTimeTableViewCell.h"

@implementation AddSubTripEndTimeTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoSetDimension:ALDimensionHeight toSize:20.0];
        
        self.timeLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_timeLB];
        
        [_timeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20.0];
        [_timeLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_timeLB autoSetDimension:ALDimensionHeight toSize:20.0];
        

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
