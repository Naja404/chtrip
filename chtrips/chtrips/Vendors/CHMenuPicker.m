//
//  CHMenuPicker.m
//  chtrips
//
//  Created by Hisoka on 15/4/16.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CHMenuPicker.h"
#import "CHMenuPickerView.h"

static CGFloat const WidthForMenuView = 60.0;
static CGFloat const HeightForMenuView = 40.0;

@interface CHMenuPicker ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *menuCellViews;

@end

@implementation CHMenuPicker

#pragma mark
- (instancetype) init{
    
    self = [super init];
    
    if (self) {
        self.menuArr = [NSArray arrayWithObjects:@"人气", @"特惠", @"精品", @"分类", @"活动", @"商圈", nil];
        
        self.menuPickerView = [[CHMenuPickerView alloc] initWithFrame:CGRectZero];
        self.menuCellViews = [[NSMutableArray alloc] initWithCapacity:[self.menuArr count]];
        self.menuPickerView.delegate = self;
        self.menuPickerView.contentSize = [self contentSizeWithMenuCount:[self.menuArr count]];
        self.menuPickerView.showsHorizontalScrollIndicator = NO;
        
        [self addBtnScrollView:self.menuArr];
        
        [self scrollToMenu:[self.menuArr count] animate:NO];
        
    }
    
    return self;
}

#pragma mark 菜单移动
- (void) scrollToMenu:(unsigned)menuNum animate:(BOOL)animate {

    [self resetMenuView:[self.menuArr count]];
    self.menuPickerView.contentOffset = CGPointMake(menuNum * WidthForMenuView, 0);
}

#pragma mark 重载菜单数据
- (void) resetMenuView:(unsigned)menuCount {
    
    for (unsigned i = 0; i < menuCount; i++) {
        CHMenuPickerView *menuView = self.menuCellViews[i];
        menuView.menuName.text = [self.menuArr objectAtIndex:i];
    }
}

#pragma mark 设置contentsize
- (CGSize) contentSizeWithMenuCount:(NSUInteger)count {
    return CGSizeMake(count * WidthForMenuView, HeightForMenuView);
}

#pragma mark 将文本加到scrollview上
- (void) addBtnScrollView:(NSArray *)menuArr {
    
    for (unsigned i = 0; i < [menuArr count]; i++) {
        CHMenuPickerView *menuView = [[CHMenuPickerView alloc] initWithFrame:CGRectMake(i * WidthForMenuView, 0, WidthForMenuView, HeightForMenuView)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewTapped:)];
        
        [menuView addGestureRecognizer:tap];
        
        [self.menuPickerView addSubview:menuView];
        [self.menuCellViews addObject:menuView];
    }
}

#pragma mark 菜单点击事件
- (void) menuViewTapped:(UITapGestureRecognizer *)gesture {
//    CHMenuPickerView *menuView = (CHMenuPickerView *)gesture.view;
    
    NSLog(@"tap menu view");
}

#pragma mark 根据设备返回菜单宽度
- (CGFloat) menuViewWidth {
    if (IS_IPHONE5 || IS_IPHONE4) {
        return IPHONE5_WIDTH;
    }
    
    if (IS_IPHONE6) {
        return IPHONE6_WIDTH;
    }
    
    if (IS_IPHONE6P) {
        return IPHONE6P_WIDTH;
    }
    
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark 根据设备返回菜单高度
- (CGFloat) menuViewHeight {
    return HeightForMenuView;
}

@end
