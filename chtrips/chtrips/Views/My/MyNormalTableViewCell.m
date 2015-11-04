//
//  MyNormalTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyNormalTableViewCell.h"

@implementation MyNormalTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.iconImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconImg];
        
        [_iconImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
        [_iconImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_iconImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImg withOffset:20];
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(100, 30)];
        _titleLB.font = [UIFont systemFontOfSize:16.0];
        _titleLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
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
