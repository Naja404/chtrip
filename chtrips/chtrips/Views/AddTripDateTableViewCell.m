//
//  AddTripDateTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddTripDateTableViewCell.h"

@implementation AddTripDateTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(100, 50)];
        
        self.dateLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_dateLB];
        
        [_dateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleLB];
        [_dateLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_titleLB];
        [_dateLB autoSetDimensionsToSize:CGSizeMake(120, 50)];
        _dateLB.textColor = [UIColor grayColor];
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
