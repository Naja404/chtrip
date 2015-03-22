//
//  AddSubTripLocationMapTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/19.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddSubTripLocationMapTableViewCell.h"

@implementation AddSubTripLocationMapTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _nameLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:self.nameLB];
        
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_nameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [_nameLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width - 20.0, self.contentView.frame.size.height - 10.0)];
        _nameLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        
        _addressLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:self.addressLB];
        
        [_addressLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_addressLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10.0];
        [_addressLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width - 20.0, self.contentView.frame.size.height - 20.0)];
        
        _addressLB.textColor = [UIColor blueColor];
        _addressLB.font = [UIFont fontWithName:@"Helvetica" size:14];
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
