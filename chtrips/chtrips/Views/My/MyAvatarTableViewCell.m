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
        
        self.avatarImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_avatarImg];
        
        [_avatarImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [_avatarImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0];
        [_avatarImg autoSetDimensionsToSize:CGSizeMake(60, 60)];
        
        _avatarImg.image = [UIImage imageNamed:@"avatar.jpg"];
        _avatarImg.layer.cornerRadius = 30;
        _avatarImg.clipsToBounds = YES;
        
        
        self.nameLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_nameLB];
        
        [_nameLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_nameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarImg withOffset:10.0];
        [_nameLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:30];
        _nameLB.text = @"Hisoka";
        _nameLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
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
