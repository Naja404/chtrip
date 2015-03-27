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
        
        self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        self.frontImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_frontImg];
        
        [_frontImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [_frontImg autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_frontImg autoSetDimensionsToSize:CGSizeMake(300, 280)];
        
        self.backgroundImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_backgroundImg];
        
        [_backgroundImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_frontImg withOffset:10.0];
        [_backgroundImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_frontImg withOffset:10.0];
        [_backgroundImg autoSetDimensionsToSize:CGSizeMake(200, 60)];
        _backgroundImg.backgroundColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:0.5];
        
        self.nameLB = [UILabel newAutoLayoutView];
        [_backgroundImg addSubview:_nameLB];
        
        [_nameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backgroundImg withOffset:10.0];
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backgroundImg withOffset:10.0];
        [_nameLB autoSetDimensionsToSize:CGSizeMake(200, 25)];
        _nameLB.textColor = [UIColor whiteColor];
        _nameLB.backgroundColor = [UIColor clearColor];
        
        self.dateLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_dateLB];
        
        [_dateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_backgroundImg withOffset:-20.0];
        [_dateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backgroundImg withOffset:10.0];
        [_dateLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
        _dateLB.backgroundColor = [UIColor clearColor];
        _dateLB.font = [UIFont fontWithName:@"Helvetica" size:12];
        _dateLB.textColor = [UIColor whiteColor];
        
        self.remindImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_remindImg];

        [_remindImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_nameLB];
        [_remindImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backgroundImg withOffset:2.0];
        [_remindImg autoSetDimensionsToSize:CGSizeMake(8, 8)];
        _remindImg.backgroundColor = [UIColor clearColor];
        
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
