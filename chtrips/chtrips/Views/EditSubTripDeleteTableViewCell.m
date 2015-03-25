//
//  EditSubTripDeleteTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/25.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "EditSubTripDeleteTableViewCell.h"

@implementation EditSubTripDeleteTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.deleteBTN = [UIButton newAutoLayoutView];
        [self.contentView addSubview:_deleteBTN];
        
        [_deleteBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_deleteBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_deleteBTN autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
        
        [_deleteBTN setTitle:NSLocalizedString(@"TEXT_DELETE_TRIP", nil) forState:UIControlStateNormal];
        _deleteBTN.backgroundColor = [UIColor clearColor];
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
