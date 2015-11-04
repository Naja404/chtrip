//
//  MyInfoSexTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/11/4.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoSexTableViewCell.h"

@implementation MyInfoSexTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(100, 60)];
        _titleLB.font = [UIFont systemFontOfSize:16.0];
        _titleLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.cutLineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cutLineLB];
        
        [_cutLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
        [_cutLineLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_cutLineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 5, 0.5)];
        _cutLineLB.backgroundColor = GRAY_COLOR_CELL_LINE;
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
