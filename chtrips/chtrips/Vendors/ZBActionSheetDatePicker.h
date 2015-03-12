//
//  ZBActionSheetDatePicker.h
//  WithTrip
//
//  Created by Zhou Bin on 14-4-10.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBActionSheetDatePicker;
@protocol ZBActionSheetDatePickerDelegate <NSObject>

- (void)datePickerDidSelectDate:(NSDate *)date
               pickerController:(ZBActionSheetDatePicker *)pickerController;
- (void)datePickerDidCancel:(ZBActionSheetDatePicker *)pickerController;

@end

@interface ZBActionSheetDatePicker : NSObject
@property (nonatomic, weak) id<ZBActionSheetDatePickerDelegate> delegate;

- (void)dismiss;

- (instancetype)initWithMode:(UIDatePickerMode)mode
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate;

- (instancetype)initWithMode:(UIDatePickerMode)mode
                 initialDate:(NSDate *)date
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate;

- (instancetype)initWithMode:(UIDatePickerMode)mode
                 initialDate:(NSDate *)date
              minuteInterval:(NSInteger)minute
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate;
@end
