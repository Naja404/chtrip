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
        [_frontImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_frontImg autoSetDimensionsToSize:CGSizeMake(300, 280)];
        
        self.dateLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_dateLB];
        
        [_dateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_frontImg withOffset:-10.0];
        [_dateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_dateLB autoSetDimensionsToSize:CGSizeMake(300, 20)];
        _dateLB.backgroundColor = [UIColor whiteColor];
        _dateLB.font = [UIFont fontWithName:@"Helvetica" size:12];
        
        self.backgroundImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_backgroundImg];
        
        [_backgroundImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0];
        [_backgroundImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_backgroundImg autoSetDimensionsToSize:CGSizeMake(150, 40)];
        _backgroundImg.image = [UIImage imageNamed:@"background"];
        
        self.nameLB = [UILabel newAutoLayoutView];
        [_backgroundImg addSubview:_nameLB];
        
        [_nameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backgroundImg withOffset:10.0];
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_backgroundImg withOffset:10.0];
        [_nameLB autoSetDimensionsToSize:CGSizeMake(200, 25)];
        
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
