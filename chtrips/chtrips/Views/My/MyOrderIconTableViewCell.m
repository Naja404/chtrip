//
//  MyOrderIconTableViewCell.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderIconTableViewCell.h"

@implementation MyOrderIconTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *iconArr = @[@"iconUnpay", @"iconUndelivered", @"iconConfirm", @"iconComplete"];
        NSArray *titleArr = @[@"TEXT_UNPAY", @"TEXT_UNDELIVERED", @"TEXT_UNCONFIRM", @"TEXT_COMPLETE"];
        
        for (int i = 0; i < 4; i++) {
            UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(ScreenWidth / 4 * i, 0, ScreenWidth / 4, self.contentView.frame.size.height)];
            bgView.tag = i + 10;
            
            [bgView addTarget:self action:@selector(bgViewTap:) forControlEvents:UIControlEventTouchUpInside];

            UIImageView *iconImg = [UIImageView newAutoLayoutView];
            [bgView addSubview:iconImg];
            
            [iconImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bgView withOffset:0.0];
            [iconImg autoAlignAxis:ALAxisVertical toSameAxisOfView:bgView];
            [iconImg autoSetDimensionsToSize:CGSizeMake(20, 20)];
            iconImg.image = [UIImage imageNamed:[iconArr objectAtIndex:i]];
            
            UILabel *titleLB = [UILabel newAutoLayoutView];
            [bgView addSubview:titleLB];
            
            [titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconImg withOffset:5.0];
            [titleLB autoAlignAxis:ALAxisVertical toSameAxisOfView:bgView];
            [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth/4, 12)];
            titleLB.backgroundColor = [UIColor clearColor];
            titleLB.textColor = BLACK_FONT_COLOR;
            titleLB.font = FONT_SIZE_12;
            titleLB.textAlignment = NSTextAlignmentCenter;
            titleLB.text = NSLocalizedString([titleArr objectAtIndex:i], nil);
            
            
            [self.contentView addSubview:bgView];
        }
    }
    
    return self;
}

- (void) bgViewTap:(UIControl *) control {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _tapAction(control.tag);
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
