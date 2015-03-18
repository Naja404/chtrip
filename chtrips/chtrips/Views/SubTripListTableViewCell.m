//
//  SubTripListTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "SubTripListTableViewCell.h"

@implementation SubTripListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.subTitleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_subTitleLB];
        
//        [_subTitleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [_subTitleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:50.0];
        [_subTitleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_subTitleLB autoSetDimensionsToSize:CGSizeMake(200, 30)];

        self.iconImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconImg];
        
        [_iconImg autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_subTitleLB];
        [_iconImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_iconImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
        _iconImg.image = [UIImage imageNamed:@"addIcon"];
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
