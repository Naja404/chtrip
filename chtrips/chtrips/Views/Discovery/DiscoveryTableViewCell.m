//
//  DiscoveryTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/6/7.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DiscoveryTableViewCell.h"

@implementation DiscoveryTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bgImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_bgImg];
        
        [_bgImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_bgImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_bgImg autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenWidth)];
        
        self.discoverImg = [UIImageView newAutoLayoutView];
        [self.bgImg addSubview:_discoverImg];
        
        [_discoverImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bgImg];
        [_discoverImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgImg];
        [_discoverImg autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bgImg];
        [_discoverImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgImg];
        _discoverImg.backgroundColor = [UIColor blackColor];
        _discoverImg.alpha = 0.15;
        
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-40];
        [_titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 30*2, 70)];
        _titleLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.numberOfLines = 0;
        _titleLB.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.shadowOffset = CGSizeMake(0.0f, 2.0f);
        _titleLB.shadowColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5f];
//        _titleLB.layer.shadowRadius = 20.0f;
//        _titleLB.layer.masksToBounds = YES;
        
        self.buyBTN = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_buyBTN];
        
        [_buyBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleLB withOffset:50];
        [_buyBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_buyBTN autoSetDimensionsToSize:CGSizeMake(100, 30)];
//        _buyBTN.backgroundColor = [UIColor blueColor];
        _buyBTN.font = [UIFont systemFontOfSize:20];
        _buyBTN.text = @"开抢啦!";
        _buyBTN.textColor = [UIColor whiteColor];
        _buyBTN.textAlignment = NSTextAlignmentCenter;
        _buyBTN.layer.cornerRadius = 3;
        _buyBTN.layer.masksToBounds = YES;
        
        self.timeLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_timeLB];
        
        [_timeLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.buyBTN];
        [_timeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.buyBTN withOffset:5];
        [_timeLB autoSetDimensionsToSize:CGSizeMake(120, 30)];
        _timeLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        _timeLB.textAlignment = NSTextAlignmentCenter;
        _timeLB.textColor = [UIColor whiteColor];
        
        self.locationImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_locationImg];
        
        [_locationImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10];
        [_locationImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5];
        [_locationImg autoSetDimensionsToSize:CGSizeMake(20, 25)];
        _locationImg.image = [UIImage imageNamed:@"mapLocationIcon"];
        
        self.mapLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_mapLB];
        
        [_mapLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_locationImg withOffset:5];
        [_mapLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_locationImg withOffset:-2];
        [_mapLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
        _mapLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        _mapLB.textAlignment = NSTextAlignmentLeft;
        _mapLB.textColor = [UIColor whiteColor];
        

        
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
