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
        
        [_proImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_proImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_proImg autoSetDimensionsToSize:CGSizeMake(75, 60)];
        
        _proImg.image = [UIImage imageNamed:@"playdemoPro"];
        
        self.bigTitleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_bigTitleLB];
        
        [_bigTitleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_proImg withOffset:10];
        [_bigTitleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10];
        [_bigTitleLB autoSetDimensionsToSize:CGSizeMake(150, 20)];
        _bigTitleLB.textColor = BLACK_FONT_COLOR;
        
        self.starImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_starImg];
        
        [_starImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bigTitleLB];
        [_starImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_bigTitleLB withOffset:5];
        [_starImg autoSetDimensionsToSize:CGSizeMake(85, 18)];
//        _starImg.backgroundColor = [UIColor blackColor];
        _starImg.image = [UIImage imageNamed:@"starProRed"];
        
        self.avgLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_avgLB];
        
        [_avgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_starImg withOffset:20];
        [_avgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_starImg];
        [_avgLB autoSetDimensionsToSize:CGSizeMake(80, 20)];
        _avgLB.textColor = BLACK_FONT_COLOR;
        
        self.bgLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_bgLB];
        
        [_bgLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:1];
        [_bgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_bgLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 1)];
        _bgLB.backgroundColor = [UIColor colorWithRed:216/255.0 green:212/255.0 blue:212/255.0 alpha:1];
        
        self.areaLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_areaLB];
        
        [_areaLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bigTitleLB];
        [_areaLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_starImg withOffset:5];
        [_areaLB autoSetDimensionsToSize:CGSizeMake(85, 18)];
        _areaLB.font = PLAY_FONT_TEXT;
        _areaLB.textColor = GRAY_FONT_COLOR;
    
        self.cateLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_cateLB];
        
        [_cateLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_areaLB withOffset:5];
        [_cateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_starImg withOffset:5];
        [_cateLB autoSetDimensionsToSize:CGSizeMake(85, 18)];
        _cateLB.font = PLAY_FONT_TEXT;
        _cateLB.textColor = GRAY_FONT_COLOR;
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
