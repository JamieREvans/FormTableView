//
//  FTVTextEntryView.m
//  FormTableView
//
//  Created by James Evans on 2015-05-01.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <FoundationPlus/FoundationPlus.h>
#import "FTVTextEntryView.h"
#import "FTVViewStyle.h"
#import "FTVNotifications.h"

@interface FTVTextEntryView () <UITextFieldDelegate>
{
    CGFloat width, height;
}

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *valueTextField;

@property (nonatomic) UIToolbar *keyboardToolbarAccessory;

@end

@implementation FTVTextEntryView

+ (ReturnCallback)returnCallbackSelectTextField:(UITextField *)nextTextField
{
    __block UITextField *nextTextFieldBlockReference = nextTextField;
    return ^(UITextField *textField)
    {
        [nextTextFieldBlockReference becomeFirstResponder];
    };
}

+ (ReturnCallback)returnCallbackResignResponder
{
    return ^(UITextField *textField)
    {
        [textField resignFirstResponder];
    };
}

+ (ValueVerificationBlock)textVerificationBlock
{
    return ^BOOL(NSString *value)
    {
        return value.length > 0;
    };
}

+ (ValueVerificationBlock)phoneNumberVerificationBlock
{
    return ^BOOL(NSString *value)
    {
        NSString *phoneNumberString = value.numbersOnlyString;
        return !phoneNumberString.length || phoneNumberString.length == 10;
    };
}

+ (ValueVerificationBlock)sinVerificationBlock
{
    return ^BOOL(NSString *value)
    {
        NSString *sinNumberString = value.numbersOnlyString;
        return (sinNumberString.length == value.length) && (value.length == 9);
    };
}

- (BOOL)allowsTapToResign{return NO;}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        width = frame.size.width, height = frame.size.height;

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startEditing)]];

        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    CGFloat horizontalInset = style().horizontalInset, splitPosition = viewStyle().cellValueFieldXPosition;

    [self setBackgroundColor:[UIColor whiteColor]];

    self.titleLabel = [UILabel labelForString:nil
                                   attributes:[NSAttributes attributesWithFont:style().cellTitleFont
                                                                     textColor:style().cellTitleTextColor]
                                    yPosition:0.0
                                    xPosition:horizontalInset
                                     maxWidth:width - (horizontalInset * 2.0 + splitPosition)];
    [self.titleLabel centerInHeight:self.height forYOffset:0.0];
    [self addSubview:self.titleLabel];

    self.valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(splitPosition, 0.0, width - splitPosition- horizontalInset, height)];
    [self.valueTextField setFont:style().cellValueFont];
    [self.valueTextField setTextColor:style().cellValueTextColor];
    [self.valueTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.valueTextField setReturnKeyType:UIReturnKeyNext];
    [self.valueTextField setDelegate:self];
    [self addSubview:self.valueTextField];
}

- (void)startEditing
{
    [self.valueTextField becomeFirstResponder];
}

- (void)setType:(FormTextFieldType)type
{
    _type = type;

    if(type & (FormTextFieldTypePhone | FormTextFieldTypeNumbers))
    {
        [self.valueTextField setKeyboardType:UIKeyboardTypeNumberPad];

        self.keyboardToolbarAccessory = [UIToolbar new];
        [self.keyboardToolbarAccessory sizeToFit];
        UIBarButtonItem *toolbarButton = [[UIBarButtonItem alloc] initWithTitle:(self.valueTextField.returnKeyType == UIReturnKeyNext ? @"Next" : @"Done")
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(toolbarButtonClicked:)];
        [self.keyboardToolbarAccessory setItems:@[toolbarButton]];
        [self.valueTextField setInputAccessoryView:self.keyboardToolbarAccessory];
    }
    else if(self.keyboardToolbarAccessory)
    {
        [self.valueTextField setInputAccessoryView:nil];

        self.keyboardToolbarAccessory = nil;
    }
}

- (void)toolbarButtonClicked:(UIBarButtonItem *)toolbarButton
{
    [self textFieldShouldReturn:self.valueTextField];
}

- (void)setTitle:(NSString *)title
{
    _title = title;

    [self.titleLabel setText:title];
}

- (NSString *)value{return self.valueTextField.text;}
- (void)setValue:(NSString *)value
{
    [self.valueTextField setText:value];
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _returnKeyType = returnKeyType;

    [self.valueTextField setReturnKeyType:returnKeyType];

    if(self.keyboardToolbarAccessory)
    {
        [self setType:self.type];
    }
}

- (UITextField *)textField{return self.valueTextField;}

#pragma mark - TextField Delegate Methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.returnCallback)self.returnCallback(textField);
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.secureTextEntry)
    {
        postEditingChangedNotificationWithObject(self);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.type == FormTextFieldTypePhone)
    {
        NSString *unformattedPhoneNumber = [self unformatPhoneNumber:textField.text];

        // Too big for a phone number
        if(unformattedPhoneNumber.length + string.length - range.length > 10)return NO;
        if(!range.length && unformattedPhoneNumber.length == 10)return NO;

        if(range.length == 0)
        {
            // Forward typing, include string we just typed
            unformattedPhoneNumber = [NSString stringWithFormat:@"%@%@", unformattedPhoneNumber, string.numbersOnlyString];
        }
        else
        {
            // Backspacing, remove string we just erased
            NSInteger remainingLength = unformattedPhoneNumber.length - range.length;
            unformattedPhoneNumber = [NSString stringWithFormat:@"%@", [unformattedPhoneNumber substringToIndex:remainingLength]];
        }

        textField.text = [self formatPhoneNumber:unformattedPhoneNumber];

        // Form Editing Changed Notification
        postEditingChangedNotificationWithObject(self);

        return NO;
    }

    // Form Editing Changed Notification
    postEditingChangedNotificationWithObject(self);

    return YES;
}

#pragma mark - Phone Number Methods -

- (NSString *)unformatPhoneNumber:(NSString*)numberString
{
    return [[numberString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "]] componentsJoinedByString:@""];
}

- (NSString *)formatPhoneNumber:(NSString*)number
{
    number = [self unformatPhoneNumber:number];
    NSString *formattedNumber = number;

    if(number.length == 3)formattedNumber = [NSString stringWithFormat:@"( %@ )", number];
    else if(number.length > 3 && number.length < 6)formattedNumber = [NSString stringWithFormat:@"( %@ ) %@", [number substringToIndex:3], [number substringFromIndex:3]];
    else if(number.length == 6)formattedNumber = [NSString stringWithFormat:@"( %@ ) %@ - ", [number substringToIndex:3], [number substringFromIndex:3]];
    else if(number.length > 6 )formattedNumber = [NSString stringWithFormat:@"( %@ ) %@ - %@", [number substringToIndex:3], [number substringWithRange:NSMakeRange(3, 3)], [number substringFromIndex:6]];

    return formattedNumber;
}

@end

