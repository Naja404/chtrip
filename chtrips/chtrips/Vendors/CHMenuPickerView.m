//
//  CHMenuPickerView.m
//  chtrips
//
//  Created by Hisoka on 15/4/16.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CHMenuPickerView.h"

@implementation CHMenuPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupMenuLabel];
    }
    
    return self;
}

#pragma mark 设置菜单view
- (void) setupMenuLabel {
    self.menuName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [self.menuName setFont:[UIFont fontWithName:@"Arial" size:17]];
    [self.menuName setFont:[UIFont systemFontOfSize:17.0f]];
    [self.menuName setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
    [self.menuName setTextAlignment:NSTextAlignmentCenter];
    self.menuName.numberOfLines = 2;
    
    [self addSubview:_menuName];
}

@end
