//
//  UIDateField.m
//  iZJU
//
//  Created by ricky on 13-6-30.
//  Copyright (c) 2013年 iZJU Studio. All rights reserved.
//

#import "UIDateField.h"
#import "NSDate+RExtension.h"

@interface UIDateField ()

@end

@implementation UIDateField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)onDateChanged:(UIDatePicker*)picker
{
    NSDate *date = picker.date;
    if (self.canSelectTime)
        self.text = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        self.text = [date stringWithFormat:@"yyyy-MM-dd"];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (UIView *)inputView
{
    if (![super inputView]) {
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        NSDate *date = nil;
        if (self.canSelectTime) {
            picker.datePickerMode = UIDatePickerModeDateAndTime;
            date = [NSDate dateFromString:self.text
                               withFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        else {
            picker.datePickerMode = UIDatePickerModeDate;
            date = [NSDate dateFromString:self.text
                               withFormat:@"yyyy-MM-dd"];
        }
        if (date)
            picker.date = date;
        [picker addTarget:self
                   action:@selector(onDateChanged:)
         forControlEvents:UIControlEventValueChanged];

        [super setInputView:picker];
    }
    return [super inputView];
}

@end
