//
//  ShoppingPopularityTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 15/4/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingPopularityTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleZHLB;
@property (nonatomic, strong) UILabel *titleJPLB;
@property (nonatomic, strong) UILabel *priceZHLB;
@property (nonatomic, strong) UILabel *priceJPLB;
@property (nonatomic, strong) UILabel *summaryZHLB;
@property (nonatomic, strong) UILabel *summaryLB;
@property (nonatomic, strong) UILabel *prePriceLB;
@property (nonatomic, strong) UIImageView *priceZHImg;
@property (nonatomic, strong) UIImageView *priceJPImg;
@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UILabel *cutLineLB;

@end
