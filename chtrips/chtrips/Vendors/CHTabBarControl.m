//
//  CHTabBarControl.m
//  chtrips
//
//  Created by Hisoka on 16/1/21.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "CHTabBarControl.h"

@interface CHTabBarControl ()

@property (nonatomic, strong) CALayer *selectedLayer;

@end

@implementation CHTabBarControl

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultStyle];
    }
    return self;
}

- (id) initWithTitles:(NSArray *)titles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _titleArr = titles;
        [self setDefaultStyle];
    }
    
    return self;
}

- (void) setDefaultStyle {
    self.weight = self.frame.size.width / _titleArr.count;
    self.height = self.frame.size.height;
    self.selectedIndexHeight = 5.0f;
    self.selectedIndex = 0;
    self.selectedRedLineHeight = 42;
    self.fontStyle = FONT_SIZE_16;
    self.backgroundColor = GRAY_COLOR_CITY_CELL;
    _labelArr = [[NSMutableArray alloc] init];
    self.selectedLayer = [CALayer layer];
}

- (void) drawRect:(CGRect)rect {
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    [self.textColor set];
    
    [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect rect = CGRectMake(_weight * idx, 0, _weight, _height);
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:rect];
        
        titleLB.text = [_titleArr objectAtIndex:idx];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = _fontStyle;
        titleLB.textColor = HIGHLIGHT_BLACK_COLOR;
        
        if (idx != 0) {
            UILabel *lineLB = [UILabel newAutoLayoutView];
            [titleLB addSubview:lineLB];
            
            [lineLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLB];
            [lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLB withOffset:1];
            [lineLB autoSetDimensionsToSize:CGSizeMake(1, 20)];
            lineLB.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
        }
        
        if (idx == _selectedIndex) {
            titleLB.textColor = HIGHLIGHT_RED_COLOR;
        }
        
        [_labelArr addObject:titleLB];
        
        [self.viewForBaselineLayout addSubview:titleLB];
        self.selectedLayer.frame = [self frameForSelection];
        self.selectedLayer.backgroundColor = HIGHLIGHT_RED_COLOR.CGColor;
        
        [self.layer addSublayer:self.selectedLayer];
    }];
}

- (CGRect) frameForSelection {
    
    CGFloat widthTillEndOfSelectedIndex = (_weight * _selectedIndex) + _weight;
    CGFloat widthTillBeforeSelectedIndex = (_weight * _selectedIndex);
    
    CGFloat x = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - 50 / 2);
    return CGRectMake(x, _selectedRedLineHeight, 50, 2);
    
//    return CGRectMake(_weight * _selectedIndex, 0.0, _weight, _height);
}

- (void) updateSelectionRect {
    if (CGRectIsEmpty(self.frame)) {
        self.bounds = CGRectMake(0, 0, _weight * _titleArr.count, _height);
    }else{
        _weight = self.frame.size.width / _titleArr.count;
        _height = self.frame.size.height;
    }
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        return;
    }
    
    [self updateSelectionRect];
}

#pragma mark - 点击事件
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger selected = touchLocation.x / _weight;
        if (selected != _selectedIndex) {
            [self setSelectedIndex:selected animated:YES];
        }
    }
}

- (void) setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}


- (void) setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    
    if (animated) {
        self.selectedLayer.actions = nil;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            
            if (_indexChangeBlock) {
                _indexChangeBlock(index);
            }
        }];
        self.selectedLayer.frame = [self frameForSelection];
        [CATransaction commit];
    }else{
        NSMutableDictionary *newAction = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedLayer.actions = newAction;
        
        self.selectedLayer.frame = [self frameForSelection];
        
        if (self.superview) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        if (_indexChangeBlock) {
            _indexChangeBlock(index);
        }
    }
    
    [_labelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((int)idx == index) {
            [obj setTextColor:HIGHLIGHT_RED_COLOR];
        }else{
            [obj setTextColor:HIGHLIGHT_BLACK_COLOR];
        }
    }];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (_titleArr) {
        [self updateSelectionRect];
    }
    
    [self setNeedsDisplay];
}

- (void) setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (_titleArr) {
        [self updateSelectionRect];
    }
    
    [self setNeedsDisplay];
}

@end
