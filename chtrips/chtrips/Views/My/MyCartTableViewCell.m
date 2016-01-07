//
//  MyCartTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCartTableViewCell.h"

@implementation MyCartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.checkBTN = [UIButton newAutoLayoutView];
        [self.contentView addSubview:_checkBTN];
        
        [_checkBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_checkBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_checkBTN autoSetDimensionsToSize:CGSizeMake(25, 25)];
        
        [_checkBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
        
        
        self.productImage = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_productImage];
        
        [_productImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_checkBTN withOffset:10];
        [_productImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_productImage autoSetDimensionsToSize:CGSizeMake(90, 66)];
        _productImage.contentMode = UIViewContentModeCenter;
        
        self.titleZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleZHLB];
        
        [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_productImage ];
        [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_titleZHLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20 - 30, 20)];
        _titleZHLB.font = [UIFont systemFontOfSize:17.0f];
        _titleZHLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.summaryZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_summaryZHLB];
        
        [_summaryZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:4];
        [_summaryZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage  withOffset:10];
        [_summaryZHLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20, 20)];
        _summaryZHLB.font = [UIFont systemFontOfSize:12.0f];
        _summaryZHLB.textColor = HIGHLIGHT_GRAY_COLOR;
        
        
        self.prePriceLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_prePriceLB];
        
        [_prePriceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_productImage];
        [_prePriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_prePriceLB autoSetDimensionsToSize:CGSizeMake(60, 20)];
        _prePriceLB.font = [UIFont systemFontOfSize:14.0f];
        _prePriceLB.text = NSLocalizedString(@"TEXT_REFERENCE_PRICE", nil);
        _prePriceLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.priceZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceZHLB];
        
        [_priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_prePriceLB withOffset:5];
        [_priceZHLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_prePriceLB];
        [_priceZHLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
        _priceZHLB.font = [UIFont systemFontOfSize:11.0f];
        _priceZHLB.textColor = HIGHLIGHT_RED_COLOR;
        
        self.cutLineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cutLineLB];
        
        [_cutLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_checkBTN];
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
