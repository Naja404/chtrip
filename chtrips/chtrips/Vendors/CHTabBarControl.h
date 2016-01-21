//
//  CHTabBarControl.h
//  chtrips
//
//  Created by Hisoka on 16/1/21.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHTabBarControl : UIControl

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat height;
@property (nonatomic, readwrite) CGFloat weight;
@property (nonatomic, readwrite) CGFloat selectedIndexHeight;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset; // default is UIEdgeInsetsMake(0, 5, 0, 5)
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index);
@property (nonatomic, strong) NSMutableArray *labelArr;

- (id) initWithTitles:(NSArray *)titles;
- (void) setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end
