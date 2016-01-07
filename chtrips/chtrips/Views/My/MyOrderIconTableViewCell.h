//
//  MyOrderIconTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderIconTableViewCell : UITableViewCell

//@property (nonatomic, strong) (UIButton *) NSArray *button;
@property (nonatomic, strong) void (^tapAction)(NSInteger index);

@end
