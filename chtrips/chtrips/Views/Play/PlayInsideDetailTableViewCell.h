//
//  PlayInsideDetailTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 16/2/26.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayInsideDetailTableViewCell : UITableViewCell

#pragma mark - 大标题样式
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *shopNameLB;
@property (nonatomic, strong) UIImageView *ratingImg;
@property (nonatomic, strong) UILabel *categoryLB;
@property (nonatomic, strong) UILabel *hotelLB;
@property (nonatomic, strong) UILabel *sourceLB;

#pragma mark - 通用样式
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *contentLB;
@property (nonatomic, strong) UILabel *lineLB;
@property (nonatomic, strong) UILabel *hLineLB;
@property (nonatomic, strong) UILabel *mapLB;

@end
