//
//  PlayTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/7/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayTableViewCell.h"

@implementation PlayTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.proImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_proImg];
        
        [_proImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5];
        [_proImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_proImg autoSetDimensionsToSize:CGSizeMake(90, 66)];
        
        self.sourceLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_sourceLB];
        
        [_sourceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proImg];
        [_sourceLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_proImg];
        [_sourceLB autoSetDimensionsToSize:CGSizeMake(90, 14)];
        _sourceLB.textColor = [UIColor whiteColor];
        _sourceLB.backgroundColor = TRANSLATE_BLACK_BG;
        _sourceLB.textAlignment = NSTextAlignmentCenter;
        _sourceLB.text = @"Source: Gurunavi";
        _sourceLB.font = FONT_SIZE_10;
        _sourceLB.hidden = YES;
        
        self.bigTitleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_bigTitleLB];

        [_bigTitleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_proImg];
        [_bigTitleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_proImg withOffset:10];
        [_bigTitleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 5 - 10 - 90 - 10, 20)];
        _bigTitleLB.font = TITLE_17FONT_SIZE;
        _bigTitleLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        self.starImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_starImg];
        
        [_starImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_proImg withOffset:4];
        [_starImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bigTitleLB];
        [_starImg autoSetDimensionsToSize:CGSizeMake(66, 12)];
        
        self.avgLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_avgLB];

        [_avgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_starImg withOffset:-4];
        [_avgLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-30];
        [_avgLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
        _avgLB.font = TITLE_17FONT_SIZE;
        _avgLB.textColor = HIGHLIGHT_BLACK_COLOR;
        _avgLB.textAlignment = NSTextAlignmentRight;
        
        
        self.areaLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_areaLB];
        
        [_areaLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proImg];
        [_areaLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bigTitleLB];
        [_areaLB autoSetDimensionsToSize:CGSizeMake(85, 12)];
        _areaLB.font = NORMAL_12FONT_SIZE;
        _areaLB.textColor = GRAY_FONT_COLOR;
    
        self.cateLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cateLB];

        [_cateLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proImg];
        [_cateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_areaLB withOffset:5];
        [_cateLB autoSetDimensionsToSize:CGSizeMake(85, 12)];
        _cateLB.font = NORMAL_12FONT_SIZE;
        _cateLB.textColor = HIGHLIGHT_GRAY_COLOR;
        
        self.cutLineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cutLineLB];
        
        [_cutLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_proImg];
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
