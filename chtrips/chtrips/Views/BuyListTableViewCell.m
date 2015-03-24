//
//  BuyListTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "BuyListTableViewCell.h"

@implementation BuyListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_contentLB];
        
        [_contentLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_contentLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:50.0];
        [_contentLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width - 80, self.contentView.frame.size.height)];
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
