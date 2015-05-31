//
//  AddTripNameTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddTripNameTableViewCell.h"

@implementation AddTripNameTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.tripNameInput = [UITextField newAutoLayoutView];
        [self.contentView addSubview:_tripNameInput];
        
        [_tripNameInput autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_tripNameInput autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_tripNameInput autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width - 50.0, self.contentView.frame.size.height)];
        
        _tripNameInput.backgroundColor = [UIColor whiteColor];
        _tripNameInput.placeholder = NSLocalizedString(@"INPUT_ADD_TRIP_NAME", Nil);
        _tripNameInput.returnKeyType = UIReturnKeyDone;
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
