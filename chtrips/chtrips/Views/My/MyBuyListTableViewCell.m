//
//  MyBuyListTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/5/31.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyBuyListTableViewCell.h"

@implementation MyBuyListTableViewCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.productImage = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_productImage];
        
        [_productImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10];
        [_productImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_productImage autoSetDimensionsToSize:CGSizeMake(100, 100)];
        
        
        self.titleZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleZHLB];
        
        [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10];
        [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:20];
        [_titleZHLB autoSetDimensionsToSize:CGSizeMake(180, 20)];
        
        self.titleJPLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleJPLB];
        
        [_titleJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:5];
        [_titleJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage  withOffset:20];
        [_titleJPLB autoSetDimensionsToSize:CGSizeMake(180, 20)];
        _titleJPLB.font = [UIFont fontWithName:@"Arial" size:17];
        _titleJPLB.textColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
        
        self.priceJPImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_priceJPImg];
        
        [_priceJPImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:10];
        [_priceJPImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:15];
        [_priceJPImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
        _priceJPImg.image = [UIImage imageNamed:@"japanFlagIcon"];
        
        self.priceJPLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceJPLB];
        
        [_priceJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:10];
        [_priceJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceJPImg withOffset:10];
        [_priceJPLB autoSetDimensionsToSize:CGSizeMake(100, 16)];
        _priceJPLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];
        
        self.priceZHImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_priceZHImg];
        
        [_priceZHImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:10];
        [_priceZHImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceJPImg withOffset:100];
        [_priceZHImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
        _priceZHImg.image = [UIImage imageNamed:@"chinaFlagIcon"];
        
        
        self.priceZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceZHLB];
        
        [_priceZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleJPLB withOffset:10];
        [_priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceJPImg withOffset:125];
        [_priceZHLB autoSetDimensionsToSize:CGSizeMake(100, 16)];
        _priceZHLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];
        
        self.summaryLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_summaryLB];
        
        [_summaryLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_priceJPLB withOffset:5];
        [_summaryLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:20];
        [_summaryLB autoSetDimensionsToSize:CGSizeMake(180, 20)];
        _summaryLB.textColor = [UIColor redColor];
        
        
        self.productNum = [UIStepper newAutoLayoutView];
        [self.contentView addSubview:_productNum];
        
        [_productNum autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_productNum autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20];
        [_productNum autoSetDimensionsToSize:CGSizeMake(100, 40)];
        
        _productNum.maximumValue = 99;
        _productNum.minimumValue = 1;
        _productNum.stepValue = 1;
        [_productNum addTarget:self action:@selector(stepTag:) forControlEvents:UIControlEventValueChanged];
        
        
        self.productNumLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_productNumLB];
        
        [_productNumLB autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_productNum withOffset:-10];
        [_productNumLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10];
        [_productNumLB autoSetDimensionsToSize:CGSizeMake(50, 15)];
        _productNumLB.text = @"1";
    }
    
    return self;
}

- (void) stepTag:(UIStepper *) stepper {
    self.productNumLB.text = [NSString stringWithFormat:@"%ld", (long)stepper.value];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
