//
//  CHAlertPayView.h
//  chtrips
//
//  Created by Hisoka on 16/1/25.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHAlertPayView;

@protocol CHAlertPayViewDelegate <NSObject>

@end

@interface CHAlertPayView : NSObject

@property (nonatomic, weak) id<CHAlertPayViewDelegate>delegate;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *alterPayV;
@property (nonatomic, strong) UIView *coverV;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) void (^tapPayAction)(NSString *payType, NSString *oid);

- (instancetype) initWithShareView:(id<CHAlertPayViewDelegate>)delegate;
- (void) show;
- (void) dismiss;

@end
