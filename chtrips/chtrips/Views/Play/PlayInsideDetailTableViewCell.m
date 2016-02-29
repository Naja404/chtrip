//
//  PlayInsideDetailTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/2/26.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "PlayInsideDetailTableViewCell.h"

@interface PlayInsideDetailTableViewCell ()



@end

@implementation PlayInsideDetailTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        if ([reuseIdentifier isEqualToString:@"playNavCell"]) {
            self.bgImg = [UIImageView newAutoLayoutView];
            [self.contentView addSubview:_bgImg];
            
            [_bgImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_bgImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
            [_bgImg autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
            [_bgImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];

        }else if ([reuseIdentifier isEqualToString:@"playTitleCell"]){
            self.shopNameLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_shopNameLB];
            
            [_shopNameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
            [_shopNameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
            [_shopNameLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 10, 30)];
            _shopNameLB.font = FONT_SIZE_16;
            _shopNameLB.font = BLACK_FONT_TEXT;
            
            self.ratingImg = [UIImageView newAutoLayoutView];
            [self.contentView addSubview:_ratingImg];
            
            [_ratingImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_shopNameLB withOffset:5];
            [_ratingImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_shopNameLB];
            [_ratingImg autoSetDimensionsToSize:CGSizeMake(66, 12)];
            
            self.categoryLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_categoryLB];
            
            [_categoryLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_ratingImg];
            [_categoryLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_ratingImg withOffset:20];
            [_categoryLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 66 - 10 - 20, 12)];
            _categoryLB.font = FONT_SIZE_12;
            _categoryLB.textColor = GRAY_FONT_COLOR;
            
            self.lineLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_lineLB];
            
            [_lineLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:-0.5];
            [_lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
            [_lineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 0.5)];
            _lineLB.backgroundColor = GRAY_COLOR_CITY_CELL;
        }else{
            self.iconImg = [UIImageView newAutoLayoutView];
            [self.contentView addSubview:_iconImg];
            
            [_iconImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
            [_iconImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
            [_iconImg autoSetDimensionsToSize:CGSizeMake(15, 15)];
            
            self.titleLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_titleLB];
            
            [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:12];
            [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImg withOffset:5];
            [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 60, 15)];
            _titleLB.font = FONT_SIZE_15;
            
            self.contentLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_contentLB];
            
            [_contentLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLB withOffset:5];
            [_contentLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_titleLB];
            [_contentLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-100];
            [_contentLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5];

//            if (self.contentView.frame.size.height >= 74) {
//                [_contentLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 60, 32)];
//            }else{
//                [_contentLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 60, 15)];
//            }
            _contentLB.lineBreakMode = NSLineBreakByWordWrapping;
            _contentLB.numberOfLines = 0;
            _contentLB.font = FONT_SIZE_14;
            _contentLB.textColor = GRAY_FONT_COLOR;
            self.lineLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_lineLB];
            
            [_lineLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentView withOffset:-0.5];
            [_lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
            [_lineLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 0.5)];
            _lineLB.backgroundColor = GRAY_COLOR_CELL_LINE;
            
            
            self.hLineLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_hLineLB];
            
            [_hLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_contentLB withOffset:20];
            [_hLineLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_contentLB];
            [_hLineLB autoSetDimensionsToSize:CGSizeMake(1, 20)];
            _hLineLB.backgroundColor = GRAY_FONT_COLOR;
            _hLineLB.hidden = YES;
            
            self.mapLB = [UILabel newAutoLayoutView];
            [self.contentView addSubview:_mapLB];
            
            [_mapLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_hLineLB withOffset:10];
            [_mapLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_contentLB];
            [_mapLB autoSetDimensionsToSize:CGSizeMake(40, 20)];
            _mapLB.text = @"地图";
            _mapLB.font = FONT_SIZE_14;
            _mapLB.textColor = [UIColor whiteColor];
            _mapLB.textAlignment = NSTextAlignmentCenter;
            _mapLB.backgroundColor = BLUE_COLOR_BG;
            _mapLB.layer.masksToBounds = YES;
            _mapLB.layer.cornerRadius = 5;
            _mapLB.hidden = YES;
        }
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
