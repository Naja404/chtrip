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
        [_bgImg autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 200)];
        
        
        self.titleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLB];
        
        [_titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        
//        [_titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
//        [_titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:20];
        [_titleLB autoSetDimensionsToSize:CGSizeMake(180, 20)];
        _titleLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        
        self.leftLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_leftLB];
        
        [_leftLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_leftLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        [_leftLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
        
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
