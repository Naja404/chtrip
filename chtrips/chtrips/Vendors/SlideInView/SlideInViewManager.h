//
//  SlideInViewManager.h
//  chtrips
//
//  Created by Hisoka on 15/11/23.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SlideInViewManager : NSObject

- (id) initWithSlideView:(UIView *)_slideView parentView:(UIView *)_parentView;
- (void) slideViewIn;
- (void) slideViewOut;

@end
