//
//  cityMenu.h
//  chtrips
//
//  Created by Hisoka on 15/8/2.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cityMenuSelectedHandle) (NSInteger selectedIndex);

@interface cityMenu : UIView

@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, copy) cityMenuSelectedHandle selectedHandle;
@property (nonatomic, readonly) BOOL visible;

- (instancetype)init;
- (void)showFromView:(UIView *)view atPoint:(CGPoint)point animated:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
