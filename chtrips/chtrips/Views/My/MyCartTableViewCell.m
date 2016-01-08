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
        
        self.titleZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleZHLB];
        
        [_titleZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_productImage ];
        [_titleZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_titleZHLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20 - 40, 20)];
        _titleZHLB.font = [UIFont systemFontOfSize:17.0f];
        _titleZHLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.summaryZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_summaryZHLB];
        
        [_summaryZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleZHLB withOffset:4];
        [_summaryZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage  withOffset:10];
        [_summaryZHLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 90 - 5 - 20, 20)];
        _summaryZHLB.font = [UIFont systemFontOfSize:12.0f];
        _summaryZHLB.textColor = HIGHLIGHT_GRAY_COLOR;
        
        
//        self.prePriceLB = [UILabel newAutoLayoutView];
//        [self.contentView addSubview:_prePriceLB];
//        
//        [_prePriceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_productImage];
//        [_prePriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
//        [_prePriceLB autoSetDimensionsToSize:CGSizeMake(60, 20)];
//        _prePriceLB.font = [UIFont systemFontOfSize:14.0f];
//        _prePriceLB.text = NSLocalizedString(@"TEXT_REFERENCE_PRICE", nil);
//        _prePriceLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.priceZHLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_priceZHLB];
        
        [_priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_productImage withOffset:10];
        [_priceZHLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_productImage];
        [_priceZHLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
        _priceZHLB.font = [UIFont systemFontOfSize:11.0f];
        _priceZHLB.textColor = HIGHLIGHT_RED_COLOR;
        
        self.cutLineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cutLineLB];
        
        [_cutLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_checkBTN];
        [_cutLineLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_cutLineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 5, 0.5)];
        _cutLineLB.backgroundColor = GRAY_COLOR_CELL_LINE;
        
        // 定义按钮边框样色
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorRef = CGColorCreate(colorSpace, (CGFloat[]){1, 0, 0, 1});
        
        self.proTotalV = [UIControl newAutoLayoutView];
        [self.contentView addSubview:_proTotalV];
        
        [_proTotalV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_productImage];
        [_proTotalV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-5.0];
        [_proTotalV autoSetDimensionsToSize:CGSizeMake(102, 32)];
        _proTotalV.backgroundColor = [UIColor clearColor];
        _proTotalV.layer.masksToBounds = YES;
        _proTotalV.layer.cornerRadius = 16.0f;
        _proTotalV.layer.borderWidth = 0.5f;
        _proTotalV.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        
        self.minusProBTN = [UIButton newAutoLayoutView];
        [_proTotalV addSubview:_minusProBTN];
        
        [_minusProBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_proTotalV];
        [_minusProBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_proTotalV withOffset:1.0];
        [_minusProBTN autoSetDimensionsToSize:CGSizeMake(30, 30)];
        _minusProBTN.backgroundColor = [UIColor clearColor];
        _minusProBTN.layer.masksToBounds = YES;
        _minusProBTN.layer.cornerRadius = 15.0f;
        _minusProBTN.layer.borderWidth = 1;
        _minusProBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        
        [_minusProBTN addTarget:self action:@selector(clickMinusBTN:) forControlEvents:UIControlEventTouchUpInside];
        [_minusProBTN setTitle:@"-" forState:UIControlStateNormal];
        [_minusProBTN setTitleColor:BLACK_FONT_COLOR forState:UIControlStateNormal];
        
        self.proTotalLB = [UILabel newAutoLayoutView];
        [_proTotalV addSubview:_proTotalLB];
        
        [_proTotalLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_proTotalV];
        [_proTotalLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_proTotalV];
        [_proTotalLB autoSetDimensionsToSize:CGSizeMake(40, 30)];
        _proTotalLB.backgroundColor = [UIColor clearColor];
        _proTotalLB.font = FONT_SIZE_14;
        _proTotalLB.textAlignment = NSTextAlignmentCenter;
        _proTotalLB.textColor = BLACK_FONT_COLOR;
        
        self.plusProBTN = [UIButton newAutoLayoutView];
        [_proTotalV addSubview:_plusProBTN];
        
        [_plusProBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_proTotalV];
        [_plusProBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_proTotalV withOffset:-1.0];
        [_plusProBTN autoSetDimensionsToSize:CGSizeMake(30, 30)];
        _plusProBTN.backgroundColor = [UIColor clearColor];
        _plusProBTN.layer.masksToBounds = YES;
        _plusProBTN.layer.cornerRadius = 15.0f;
        _plusProBTN.layer.borderWidth = 1;
        _plusProBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        
        [_plusProBTN addTarget:self action:@selector(clickPlusBTN:) forControlEvents:UIControlEventTouchUpInside];
        [_plusProBTN setTitle:@"+" forState:UIControlStateNormal];
        [_plusProBTN setTitleColor:BLACK_FONT_COLOR forState:UIControlStateNormal];
        
    }
    
    return self;
}

#pragma mark - 增加商品数量按钮
- (void) clickPlusBTN:(UIButton *)btn {
    if (_selectState) _tapPlusBTNAction(btn.tag);

}

#pragma mark - 删减商品数量按钮
- (void) clickMinusBTN:(UIButton *)btn {
    if (_selectState) _tapMinusBTNAction(btn.tag);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
