//
//  FTVTextEntryView.h
//  FormTableView
//
//  Created by James Evans on 2015-05-01.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVProtocols.h"

typedef enum
{
    FormTextFieldTypePlain = 1 << 0,
    FormTextFieldTypePhone = 1 << 1,
    FormTextFieldTypeNumbers = 1 << 2
} FormTextFieldType;

typedef void (^ReturnCallback)(UITextField *textField);

@interface FTVTextEntryView : UIView <FormValueVerificationProtocol>

@property (nonatomic) NSString *title, *value;
@property (nonatomic) FormTextFieldType type;
// Defaults to UIReturnKeyTypeNext
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, strong) ReturnCallback returnCallback;
@property (readonly, nonatomic) UITextField *textField;
@property (nonatomic, strong) ValueVerificationBlock verificationBlock;

+ (ReturnCallback)returnCallbackSelectTextField:(UITextField *)nextTextField;
+ (ReturnCallback)returnCallbackResignResponder;

+ (ValueVerificationBlock)textVerificationBlock;
+ (ValueVerificationBlock)phoneNumberVerificationBlock;
+ (ValueVerificationBlock)sinVerificationBlock;

@end