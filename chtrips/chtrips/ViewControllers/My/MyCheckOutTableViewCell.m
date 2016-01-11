//
//  MyCheckOutTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCheckOutTableViewCell.h"

@implementation MyCheckOutTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:30];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 50, 30)];
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
