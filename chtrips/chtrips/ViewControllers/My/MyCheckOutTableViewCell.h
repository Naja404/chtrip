//
//  MyCheckOutTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCheckOutTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *priceLB;
@property (nonatomic, strong) UILabel *shippingLB;
@property (nonatomic, strong) UIImageView *selectImg;
@property (nonatomic, strong) void (^tapPayAction)(NSInteger index);
@property (nonatomic, strong) NSMutableArray *controlArr;
@property (nonatomic, strong) UILabel *lastLine;

@end
