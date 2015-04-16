//
//  CHMenuPicker.h
//  chtrips
//
//  Created by Hisoka on 15/4/16.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHMenuPickerView.h"

@class CHMenuPicker;

@protocol CHMenuPickerDelegate <NSObject>

@optional
- (void) CHMenuPicker:(CHMenuPicker *)menu didSelectMenu:(unsigned)menuNum;

@end


@interface CHMenuPicker : NSObject

@property (nonatomic, strong) NSArray *menuArr;

@property (nonatomic, strong) CHMenuPickerView *menuPickerView;
@property (nonatomic, strong) id<CHMenuPickerDelegate> delegate;


- (void) scrollToMenu:(unsigned)menuNum animate:(BOOL)animate;

@end
