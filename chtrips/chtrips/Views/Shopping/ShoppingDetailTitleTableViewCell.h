//
//  ShoppingDetailTitleTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 15/4/22.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingDetailTitleTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleZHLB;
@property (nonatomic, strong) UILabel *titleJPLB;
@property (nonatomic, strong) UILabel *summaryLB;

- (CGFloat) setTextWithHeight:(NSString *)titleZH titleJP:(NSString *)titleJP summary:(NSString *)summary;

@end
