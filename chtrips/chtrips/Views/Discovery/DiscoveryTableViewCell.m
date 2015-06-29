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
        [_bgImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:25];
        [_bgImg autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 185)];
        
        
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-40];
        [_titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        
//        [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
//        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(180, 20)];
        _titleLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0f];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.textColor = [UIColor whiteColor];
        
        self.leftLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_leftLB];
        

        [_leftLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleLB withOffset:30];
        [_leftLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_leftLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
        _leftLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        _leftLB.textAlignment = NSTextAlignmentCenter;
        _leftLB.textColor = [UIColor whiteColor];
        
        self.buyBTN = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_buyBTN];
        
        [_buyBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.leftLB withOffset:40];
        [_buyBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_buyBTN autoSetDimensionsToSize:CGSizeMake(120, 25)];
//        _buyBTN.backgroundColor = [UIColor colorWithRed:250 green:139 blue:10 alpha:1];
        _buyBTN.backgroundColor = [UIColor blueColor];
        _buyBTN.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
        _buyBTN.text = @"开抢啦!";
        _buyBTN.textColor = [UIColor whiteColor];
        _buyBTN.textAlignment = NSTextAlignmentCenter;
        
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
