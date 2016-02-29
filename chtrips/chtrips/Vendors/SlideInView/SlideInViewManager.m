//
//  SlideInViewManager.m
//  chtrips
//
//  Created by Hisoka on 15/11/23.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "SlideInViewManager.h"

//static NSTimeInterval kNotificationViewDefaultHideTimeInterval = 4.5;

@implementation SlideInViewManager {
    BOOL visible;
    UIView *slideView;
    UIView *parentView;
}

- (id) initWithSlideView:(UIView *)_slideView parentView:(UIView *)_parentView {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    slideView = _slideView;
    parentView = _parentView;
    
    return self;
}

- (void) slideViewIn {
    parentView.hidden = NO;
    visible = YES;
    
    CGFloat slideWidth = CGRectGetWidth(slideView.frame);
    CGFloat slideHeight = CGRectGetHeight(slideView.frame);
    CGFloat slideX = CGRectGetMinX(slideView.frame);
    CGFloat slideOriginalY = CGRectGetHeight(parentView.frame);
    CGFloat slideTargetY = CGRectGetHeight(parentView.frame) - slideHeight;
    
    CGRect original = CGRectMake(slideX, slideOriginalY, slideWidth, slideHeight);
    CGRect target = CGRectMake(slideX, slideTargetY, slideWidth, slideHeight);
    
    [slideView setFrame:original];
    [parentView addSubview:slideView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [slideView setFrame:target];
    } completion:^(BOOL finished) {
        if (finished) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            [slideView addGestureRecognizer:tapGestureRecognizer];
        }
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kNotificationViewDefaultHideTimeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        if (visible) {
//            [self slideViewOut];
//        }
//    });
}

- (void) slideViewOut {

    visible = NO;
    
    CGFloat slideWidth = CGRectGetWidth(slideView.frame);
    CGFloat slideHeight = CGRectGetHeight(slideView.frame);
    CGFloat slideX = CGRectGetMinX(slideView.frame);
    CGFloat slideOriginalY = CGRectGetHeight(parentView.frame);
    
    CGRect original = CGRectMake(slideX, slideOriginalY, slideWidth, slideHeight);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slideView setFrame:original];
    } completion:^(BOOL finished) {
        [slideView removeFromSuperview];
        parentView.hidden = YES;
    }];
}

- (void) tapped:(UITapGestureRecognizer *)recognizer {
    [recognizer.view removeGestureRecognizer:recognizer];
    [self slideViewOut];
}

@end
