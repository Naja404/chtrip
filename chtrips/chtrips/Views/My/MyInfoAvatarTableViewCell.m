//
//  MyInfoAvatarTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/11/3.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoAvatarTableViewCell.h"

@implementation MyInfoAvatarTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
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
        
        [_avatarImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_avatarImg autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];
        [_avatarImg autoSetDimensionsToSize:CGSizeMake(80, 80)];
        _avatarImg.image = [UIImage imageNamed:@"defaultPicBig"];
        _avatarImg.layer.masksToBounds = YES;
        _avatarImg.layer.cornerRadius = 40;
        
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
