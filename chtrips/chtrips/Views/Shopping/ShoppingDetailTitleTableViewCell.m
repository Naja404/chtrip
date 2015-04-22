//
//  ShoppingDetailTitleTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/22.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDetailTitleTableViewCell.h"

@implementation ShoppingDetailTitleTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleZHLB];
        
        [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_titleZHLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, 30)];
        _titleZHLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        _titleZHLB.backgroundColor = [UIColor grayColor];
        
        self.titleJPLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleJPLB];
        
        [_titleJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:2.0];
        [_titleJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_titleJPLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, 30)];
        _titleJPLB.font = [UIFont fontWithName:@"ArialMT" size:18];
        _titleJPLB.textColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
        _titleJPLB.backgroundColor = [UIColor grayColor];
        
        self.summaryLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_summaryLB];
        
        [_summaryLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:2.0];
        [_summaryLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_summaryLB autoSetDimensionsToSize:CGSizeMake(self.contentView.frame.size.width, 40)];
        _summaryLB.font = [UIFont fontWithName:@"Georgia-Italic" size:20];
        _summaryLB.textColor = [UIColor redColor];
        _summaryLB.backgroundColor = [UIColor blackColor];
        
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
