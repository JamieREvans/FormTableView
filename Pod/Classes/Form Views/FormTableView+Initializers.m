//
//  FormTableView+Initializers.m
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FormTableView+Initializers.h"
#import "FTVStyle.h"

@implementation FormTableView (Initializers)

+ (CGRect)cellFrame
{
    return CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, style().cellHeight);
}

+ (FTVTextEntryView *)textFieldWithTitle:(NSString *)title type:(FormTextFieldType)type andReturnCallback:(ReturnCallback)returnCallback
{
    FTVTextEntryView *textField = [[FTVTextEntryView alloc] initWithFrame:[self cellFrame]];
    [textField setTitle:title];
    [textField setType:type];
    [textField setReturnCallback:returnCallback];
    return textField;
}

+ (FTVTextEntryView *)textFieldWithTitle:(NSString *)title type:(FormTextFieldType)type isLastTextField:(BOOL)isLastTextField
{
    FTVTextEntryView *textField = [self textFieldWithTitle:title type:type andReturnCallback:(isLastTextField ? [FTVTextEntryView returnCallbackResignResponder] : nil)];
    if(isLastTextField)[textField setReturnKeyType:UIReturnKeyDone];
    return textField;
}

@end
