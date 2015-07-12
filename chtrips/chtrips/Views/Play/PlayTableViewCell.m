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
        [_bigTitleLB autoSetDimensionsToSize:CGSizeMake(100, 20)];

        
        self.starImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_starImg];
        
        [_starImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bigTitleLB];
        [_starImg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_bigTitleLB withOffset:5];
        [_starImg autoSetDimensionsToSize:CGSizeMake(85, 18)];
        _starImg.image = [UIImage imageNamed:@"starProRed"];
        
        self.avgLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_avgLB];
        
        [_avgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_starImg withOffset:20];
        [_avgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_starImg];
        [_avgLB autoSetDimensionsToSize:CGSizeMake(80, 20)];
        
        self.bgLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_bgLB];
        
        [_bgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_starImg withOffset:5];
        [_bgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_starImg];
        [_bgLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [_bgLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        _bgLB.backgroundColor = [UIColor colorWithRed:216/255.0 green:212/255.0 blue:212/255.0 alpha:1];
       
        
        self.proposeLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_proposeLB];
        
        [_proposeLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bgLB withOffset:0];
        [_proposeLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_bgLB];
        _proposeLB.text = @"参考价格";
        _proposeLB.font = PLAY_FONT_TEXT;
        
        self.jpImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_jpImg];
        
        [_jpImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_proposeLB withOffset:5];
        [_jpImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_bgLB];
        [_jpImg autoSetDimensionsToSize:CGSizeMake(20, 10)];
        _jpImg.image = [UIImage imageNamed:@"jpImg"];
        
        self.jpLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_jpLB];
        
        [_jpLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_jpImg withOffset:5];
        [_jpLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_bgLB];
        [_jpLB autoSetDimensionsToSize:CGSizeMake(60, 15)];
        _jpLB.font = PLAY_FONT_TEXT;
        
        self.zhImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_zhImg];
        
        [_zhImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_jpLB withOffset:5];
        [_zhImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_bgLB];
        [_zhImg autoSetDimensionsToSize:CGSizeMake(20, 10)];
        _zhImg.image = [UIImage imageNamed:@"zhImg"];
        
        self.zhLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_zhLB];
        
        [_zhLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_zhImg withOffset:5];
        [_zhLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_bgLB];
        [_zhLB autoSetDimensionsToSize:CGSizeMake(60, 15)];
        _zhLB.font = PLAY_FONT_TEXT;
        
        
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
