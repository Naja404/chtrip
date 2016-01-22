//
//  MyOrderTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/22.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.proImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_proImg];
        
        [_proImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_proImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_proImg autoSetDimensionsToSize:CGSizeMake(90, 66)];
        
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_proImg];
        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_proImg withOffset:10];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 20 - 10 , 40)];
        _titleLB.textColor = BLACK_FONT_COLOR;
        _titleLB.font = FONT_SIZE_16;
        
        self.priceLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceLB];
        
        [_priceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proImg];
        [_priceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLB];
        [_priceLB autoSetDimensionsToSize:CGSizeMake(100, 40)];
        _priceLB.textColor = RED_COLOR_BG;
        _priceLB.font = FONT_SIZE_14;
        
        self.totalLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_totalLB];
        
        [_totalLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_priceLB];
        [_totalLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceLB withOffset:10];
        [_totalLB autoSetDimensionsToSize:CGSizeMake(80, 40)];
        _totalLB.textColor = GRAY_FONT_COLOR;
        _totalLB.font = FONT_SIZE_12;
        
        
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
