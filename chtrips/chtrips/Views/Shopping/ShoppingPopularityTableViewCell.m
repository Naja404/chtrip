//
//  ShoppingPopularityTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPopularityTableViewCell.h"

@implementation ShoppingPopularityTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.productImage = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_productImage];
        
        [_productImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
        [_productImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_productImage autoSetDimensionsToSize:CGSizeMake(90, 80)];
        
        
        self.titleZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleZHLB];
        
        [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:2];
        [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_titleZHLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20, 20)];
        _titleZHLB.font = [UIFont fontWithName:@"Arial" size:19];
        
        self.titleJPLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleJPLB];
        
        [_titleJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:2];
        [_titleJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage  withOffset:10];
        [_titleJPLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20, 20)];
        _titleJPLB.font = [UIFont fontWithName:@"Arial" size:15];
        _titleJPLB.textColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
       
        self.prePriceLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_prePriceLB];
        [_prePriceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:2];
        [_prePriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_prePriceLB autoSetDimensionsToSize:CGSizeMake(50, 10)];
        _prePriceLB.font = PLAY_FONT_TEXT;
        _prePriceLB.textColor = GRAY_FONT_COLOR;
        _prePriceLB.text = NSLocalizedString(@"TEXT_REFERENCE_PRICE", nil);
        
//        self.priceJPImg = [UIImageView newAutoLayoutView];
//        [self.contentView addSubview:_priceJPImg];
//        
//        [_priceJPImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:5];
//        [_priceJPImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_prePriceLB withOffset:5];
//        [_priceJPImg autoSetDimensionsToSize:CGSizeMake(20, 10)];
//        _priceJPImg.image = [UIImage imageNamed:@"jpImg"];
//        
//        self.priceJPLB = [UILabel newAutoLayoutView];
//        [self.contentView addSubview:_priceJPLB];
        
//        [_priceJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:5];
//        [_priceJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceJPImg withOffset:10];
//        [_priceJPLB autoSetDimensionsToSize:CGSizeMake(100, 16)];
//        _priceJPLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];
        
        self.priceZHImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_priceZHImg];
        
        [_priceZHImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:2];
        [_priceZHImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_prePriceLB withOffset:5];
        [_priceZHImg autoSetDimensionsToSize:CGSizeMake(20, 10)];
        _priceZHImg.image = [UIImage imageNamed:@"zhImg"];
        
        
        self.priceZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceZHLB];
        
        [_priceZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB];
        [_priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceZHImg withOffset:5];
        [_priceZHLB autoSetDimensionsToSize:CGSizeMake(100, 16)];
        _priceZHLB.font = [UIFont fontWithName:@"Georgia-Italic" size:13];
        
        self.summaryLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_summaryLB];
        
        [_summaryLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_prePriceLB withOffset:8];
        [_summaryLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_prePriceLB];
        [_summaryLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20, 15)];
        _summaryLB.font = [UIFont fontWithName:@"Arial" size:15];
        _summaryLB.textColor = [UIColor redColor];
        
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
