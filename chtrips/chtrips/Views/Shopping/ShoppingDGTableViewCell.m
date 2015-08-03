//
//  ShoppingDGTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/6/21.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGTableViewCell.h"

@implementation ShoppingDGTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.shopImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_shopImg];
        
        [_shopImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_shopImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_shopImg autoSetDimensionsToSize:CGSizeMake(75, 60)];
        
        self.title = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_title];
        
        [_title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImg withOffset:20];
        [_title autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20];
        [_title autoSetDimensionsToSize:CGSizeMake(120, 20)];
        _title.font = [UIFont fontWithName:@"Arial" size:18];
        
        self.address = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_address];
        
        [_address autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_shopImg withOffset:20];
        [_address autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10];
        [_address autoSetDimensionsToSize:CGSizeMake(100, 15)];
        _address.font = [UIFont fontWithName:@"Arial" size:12];
        _address.textColor = [UIColor grayColor];
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
