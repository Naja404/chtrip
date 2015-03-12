//
//  TripListTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "TripListTableViewCell.h"

@implementation TripListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.nameLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_nameLB];
        
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_nameLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.0];
        [_nameLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, 20)];
        
        self.frontImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_frontImg];
        
        [_frontImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_frontImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_frontImg autoSetDimensionsToSize:CGSizeMake(320, 300)];
        
        
        
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
