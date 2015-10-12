//
//  CitySelectViewController.h
//  chtrips
//
//  Created by Hisoka on 15/9/27.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ViewController.h"

@protocol CitySelectViewControllerDelegate <NSObject>

- (void) didSelectCity:(NSString *)cityName;

@end

@interface CitySelectViewController : ViewController

@property (strong, nonatomic) NSMutableArray *cityData;
@property (strong, nonatomic) NSString *selectedCity;
@property (weak, nonatomic) id<CitySelectViewControllerDelegate> delegate;

@end
