//
//  CitySelectCollectionViewCell.h
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *cityBTN;
@property (strong, nonatomic) NSIndexPath *cityIndexPath;
@property (nonatomic, strong) NSString *cityNameStr;

@end


