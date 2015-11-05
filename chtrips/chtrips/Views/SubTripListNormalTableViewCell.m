//
//  SubTripListNormalTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 15/3/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "SubTripListNormalTableViewCell.h"

@implementation SubTripListNormalTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.subTitleLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_subTitleLB];
        
        [_subTitleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0];
        [_subTitleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:50.0];
        [_subTitleLB autoSetDimensionsToSize:CGSizeMake(200, 30)];

        self.subTimeLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_subTimeLB];
        
        [_subTimeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_subTitleLB withOffset:20.0];
        [_subTimeLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:50.0];
        [_subTimeLB autoSetDimensionsToSize:CGSizeMake(200, 30)];
        _subTimeLB.textColor = [UIColor grayColor];
        _subTimeLB.font = [UIFont systemFontOfSize:14.0f];
        
        self.iconImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconImg];

        [_iconImg autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_subTitleLB];
        [_iconImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_iconImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        self.addressLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_addressLB];
        
        [_addressLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_subTimeLB withOffset:-5.0];
        [_addressLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:50.0];
        _addressLB.textColor = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
        _addressLB.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _addressLB.layer.cornerRadius = 5.0f;
        _addressLB.layer.masksToBounds = YES;
        
        self.lineLB = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_lineLB];
        
        [_lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:24.0];
        [_lineLB autoSetDimensionsToSize:CGSizeMake(2, 80)];
        _lineLB.backgroundColor = [UIColor grayColor];
        
        self.redMindImg = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_redMindImg];
        
        [_redMindImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_lineLB withOffset:-4.0];
        [_redMindImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
        [_redMindImg autoSetDimensionsToSize:CGSizeMake(10, 10)];
        _redMindImg.image = [UIImage imageNamed:@"redmind"];
        
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
