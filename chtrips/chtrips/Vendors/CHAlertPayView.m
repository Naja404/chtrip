//
//  CHAlertPayView.m
//  chtrips
//
//  Created by Hisoka on 16/1/25.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "CHAlertPayView.h"

@implementation CHAlertPayView

- (instancetype) initWithShareView:(id<CHAlertPayViewDelegate>)delegate {
    self = [super init];
    
    if (self) {
        [self setStyleView];
    }
    
    return self;
}

- (void) setStyleView {
    //    self.alterShareV = [self screenBounds];
    
    self.topView = [[UIView alloc] initWithFrame:[self topView].bounds];
    _topView.backgroundColor = [UIColor clearColor];
    _topView.alpha = 0;
    _topView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_topView];
    
    self.coverV = [[UIView alloc] initWithFrame:[self topView].bounds];
    _coverV.backgroundColor = [UIColor blackColor];
    _coverV.alpha = 0;
    _coverV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_topView addSubview:_coverV];
    
    self.alterPayV = [UIView newAutoLayoutView];
    [_topView addSubview:_alterPayV];
    
    [_alterPayV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_coverV];
    [_alterPayV autoAlignAxis:ALAxisVertical toSameAxisOfView:_coverV];
    [_alterPayV autoSetDimensionsToSize:CGSizeMake(260, 100)];
    _alterPayV.backgroundColor = BLACK_FONT_COLOR;
    _alterPayV.alpha = 0;
    
    UILabel *payTitleLB = [UILabel newAutoLayoutView];
    [_alterPayV addSubview:payTitleLB];
    
    [payTitleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_alterPayV];
    [payTitleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_alterPayV];
    [payTitleLB autoSetDimensionsToSize:CGSizeMake(260, 20)];
    payTitleLB.backgroundColor = GRAY_COLOR_CELL_LINE;
    payTitleLB.textAlignment = NSTextAlignmentLeft;
    payTitleLB.font = FONT_SIZE_14;
    payTitleLB.textColor = [UIColor grayColor];
    payTitleLB.text = NSLocalizedString(@"TEXT_PAYMENT_TYPE", nil);
    
    UIImageView *wechatPayImg = [UIImageView newAutoLayoutView];
    [_alterPayV addSubview:wechatPayImg];
    
    [wechatPayImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_alterPayV];
    [wechatPayImg autoAlignAxis:ALAxisVertical toSameAxisOfView:_alterPayV withOffset:-65];
    [wechatPayImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
    wechatPayImg.image = [UIImage imageNamed:@"logoWeChat"];
    
    UIImageView *alipayImg = [UIImageView newAutoLayoutView];
    [_alterPayV addSubview:alipayImg];
    
    [alipayImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_alterPayV];
    [alipayImg autoAlignAxis:ALAxisVertical toSameAxisOfView:_alterPayV withOffset:65];
    [alipayImg autoSetDimensionsToSize:CGSizeMake(30, 30)];
    alipayImg.image = [UIImage imageNamed:@"logoAlipay"];
    
    UILabel *cutLine = [UILabel newAutoLayoutView];
    [_alterPayV addSubview:cutLine];
    
    [cutLine autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_alterPayV];
    [cutLine autoAlignAxis:ALAxisVertical toSameAxisOfView:_alterPayV];
    [cutLine autoSetDimensionsToSize:CGSizeMake(0.5, 100)];
    cutLine.backgroundColor = GRAY_COLOR_CELL_LINE;
    
    UILabel *wechatPayLB = [UILabel newAutoLayoutView];
    [_alterPayV addSubview:wechatPayLB];
    
    [wechatPayLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_alterPayV withOffset:-10];
    [wechatPayLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_alterPayV];
    [wechatPayLB autoSetDimensionsToSize:CGSizeMake(130, 20)];
    wechatPayLB.backgroundColor = [UIColor clearColor];
    wechatPayLB.textAlignment = NSTextAlignmentCenter;
    wechatPayLB.font = FONT_SIZE_14;
    wechatPayLB.textColor = GRAY_FONT_COLOR;
    wechatPayLB.text = @"微信支付";
    
    UILabel *alipayLB = [UILabel newAutoLayoutView];
    [_alterPayV addSubview:alipayLB];
    
    [alipayLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wechatPayLB];
    [alipayLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_alterPayV];
    [alipayLB autoSetDimensionsToSize:CGSizeMake(130, 20)];
    alipayLB.backgroundColor = [UIColor clearColor];
    alipayLB.textAlignment = NSTextAlignmentCenter;
    alipayLB.font = FONT_SIZE_14;
    alipayLB.textColor = GRAY_FONT_COLOR;
    alipayLB.text = @"支付宝支付";
    
    UIButton *wechatPayBTN = [UIButton newAutoLayoutView];
    [_alterPayV addSubview:wechatPayBTN];
    
    [wechatPayBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_alterPayV withOffset:10];
    [wechatPayBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:_alterPayV withOffset:-65];
    [wechatPayBTN autoSetDimensionsToSize:CGSizeMake(130, 80)];
    [wechatPayBTN setBackgroundColor:[UIColor clearColor]];
    [wechatPayBTN addTarget:self action:@selector(payByWeChat) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *alipayBTN = [UIButton newAutoLayoutView];
    [_alterPayV addSubview:alipayBTN];
    
    [alipayBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_alterPayV withOffset:10];
    [alipayBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:_alterPayV withOffset:65];
    [alipayBTN autoSetDimensionsToSize:CGSizeMake(130, 80)];
    [alipayBTN setBackgroundColor:[UIColor clearColor]];
    [alipayBTN addTarget:self action:@selector(payByAlipay) forControlEvents:UIControlEventTouchUpInside];
}

- (void) payByWeChat {
    _tapPayAction(@"wxpay", _oid);
    [self dismiss];
}

- (void) payByAlipay {
    _tapPayAction(@"alipay", _oid);
    [self dismiss];
}

- (CGRect) screenBounds {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interFaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interFaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}

- (UIView *) topView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.subviews[0];
}

- (void) show {
    [UIView animateWithDuration:0.5 animations:^{
        _topView.hidden = NO;
        _topView.alpha = 1;
        _coverV.alpha = 0.5;
        _alterPayV.alpha = 1;
        [self showAnimation];
    } completion:^(BOOL finished) {
        if (finished) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            [_coverV addGestureRecognizer:tapGestureRecognizer];
        }
    }];
}

- (void) tapped:(UITapGestureRecognizer *)recognizer {
    [recognizer.view removeGestureRecognizer:recognizer];
    [self dismiss];
}

- (void) showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alterPayV.layer addAnimation:popAnimation forKey:nil];
}

- (void) dismiss {
    [self hide];
}

- (void) hide {
    [UIView animateWithDuration:0.4 animations:^{
        _coverV.alpha = 0.0;
        _alterPayV.alpha = 0.0;
    } completion:^(BOOL finished) {
        //        [_coverV removeFromSuperview];
        _topView.hidden = YES;
    }];
}

@end
