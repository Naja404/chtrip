//
//  MyOrderTitleTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderTitleTableViewCell.h"

@implementation MyOrderTitleTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20.0];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(150, 30)];
        _titleLB.backgroundColor = [UIColor clearColor];
        _titleLB.font = FONT_SIZE_16;
        _titleLB.textColor = BLACK_FONT_COLOR;
        _titleLB.text = NSLocalizedString(@"TEXT_MY_ORDER", nil);
        
        self.noteLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_noteLB];
        
        [_noteLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_noteLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [_noteLB autoSetDimensionsToSize:CGSizeMake(150, 30)];
        _noteLB.backgroundColor = [UIColor clearColor];
        _noteLB.font = FONT_SIZE_14;
        _noteLB.textColor = GRAY_COLOR_CELL_LINE;
        _noteLB.textAlignment = NSTextAlignmentRight;
        _noteLB.text = NSLocalizedString(@"TEXT_VIEW_ALL_ORDER", nil);
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
