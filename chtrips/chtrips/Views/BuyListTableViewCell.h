//
//  BuyListTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 15/3/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLB;
@property (nonatomic, strong) UIImageView *checkBoxImg;
@property (nonatomic, strong) UIButton *checkboxBTN;
@property (nonatomic, strong) NSString *buyID;
@property (nonatomic, strong) NSString *checkStatus;
@property (nonatomic, strong) UILabel *lineLB;

@end
