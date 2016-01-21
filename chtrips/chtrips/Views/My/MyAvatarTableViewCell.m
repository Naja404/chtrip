//
//  MyAvatarTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/4/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyAvatarTableViewCell.h"


@implementation MyAvatarTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.bgImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_bgImg];
        
        [_bgImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
        [_bgImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView];
        [_bgImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
        [_bgImg autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView];
        _bgImg.image = [UIImage imageNamed:@"myInfoBg"];
        
        self.avatarImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_avatarImg];
        
//        [_avatarImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.0];
//        [_avatarImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_avatarImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-10];
        [_avatarImg autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_avatarImg autoSetDimensionsToSize:CGSizeMake(80, 80)];
        
        _avatarImg.image = [UIImage imageNamed:@"defaultPicSmall"];
        _avatarImg.layer.cornerRadius = 40;
        _avatarImg.clipsToBounds = YES;
        
        
        self.nameLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_nameLB];
        
        [_nameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_avatarImg withOffset:10];
        [_nameLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
//        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarImg withOffset:10.0];
//        [_nameLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:30];
        _nameLB.text = NSLocalizedString(@"TEXT_REG_LOGIN", nil);
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.font = [UIFont systemFontOfSize:18.0f];
        
//        
//        self.scoreLB = [UILabel newAutoLayoutView];
//        [self.contentView addSubview:_scoreLB];
//        
//        [_scoreLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLB withOffset:10.0];
//        [_scoreLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_nameLB];
//        [_scoreLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 5, 30)];
//        _scoreLB.backgroundColor = RED_COLOR_BG;
//        _scoreLB.layer.masksToBounds = YES;
//        _scoreLB.layer.cornerRadius = 10.0;
//        _scoreLB.textAlignment = NSTextAlignmentCenter;
//        _scoreLB.textColor = [UIColor whiteColor];
//        _scoreLB.font = PLAY_FONT_TEXT;
//        _scoreLB.text = @"100积分";
//        
//        self.couponLB = [UILabel newAutoLayoutView];
//        [self.contentView addSubview:_couponLB];
//        
//        [_couponLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scoreLB];
//        [_couponLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_scoreLB withOffset:10.0];
//        [_couponLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth / 5, 30)];
//        _couponLB.backgroundColor = BLUE_COLOR_BG;
//        _couponLB.layer.masksToBounds = YES;
//        _couponLB.layer.cornerRadius = 10.0;
//        _couponLB.textAlignment = NSTextAlignmentCenter;
//        _couponLB.textColor = [UIColor whiteColor];
//        _couponLB.font = PLAY_FONT_TEXT;
//        _couponLB.text = @"2优惠券";
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
