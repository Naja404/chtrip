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
        
//        self.checkboxBTN = [UIButton newAutoLayoutView];
//        [self.contentView addSubview:_checkboxBTN];
//        
//        [_checkboxBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
//        [_checkboxBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
//        [_checkboxBTN autoSetDimensionsToSize:CGSizeMake(20, 20)];
//        _checkboxBTN.backgroundColor = [UIColor greenColor];
        
        
        self.checkBoxImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_checkBoxImg];
        
        [_checkBoxImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_checkBoxImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_checkBoxImg autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        self.contentLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_contentLB];
        
        [_contentLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_contentLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_checkBoxImg withOffset:10.0];
        [_contentLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width - 80, self.contentView.frame.size.height)];
        
        self.lineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_lineLB];
        
        [_lineLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:-1.0];
        [_lineLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, 1)];
        _lineLB.backgroundColor = [UIColor grayColor];
        
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
