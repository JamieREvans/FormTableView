//
//  FormTableView+Initializers.h
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FormTableView.h"
#import "FTVTextEntryView.h"

@interface FormTableView (Initializers)

+ (FTVTextEntryView *)textFieldWithTitle:(NSString *)title type:(FormTextFieldType)type andReturnCallback:(ReturnCallback)returnCallback;
+ (FTVTextEntryView *)textFieldWithTitle:(NSString *)title type:(FormTextFieldType)type isLastTextField:(BOOL)isLastTextField;

@end
