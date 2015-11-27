//
//  CHActionSheetMapApp.h
//  chtrips
//
//  Created by Hisoka on 15/11/27.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHActionSheetMapApp;

@protocol CHActionSheetMapAppDelegate <NSObject>


@end

@interface CHActionSheetMapApp : NSObject

@property (nonatomic, weak) id<CHActionSheetMapAppDelegate>delegate;
@property (nonatomic, strong) UIActionSheet *mapAS;
@property (nonatomic, strong) NSString *address;

- (instancetype)initWithMap:(id<CHActionSheetMapAppDelegate>)delegate;

- (void) dismiss;

@end
