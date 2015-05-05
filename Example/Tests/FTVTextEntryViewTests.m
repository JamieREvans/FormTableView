//
//  ArrayTests.m
//  FoundationPlus
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVTextEntryView.h"
#import "FormTableView.h"

@interface FTVTextEntryView () <UITextFieldDelegate>
{
    CGFloat width, height;
}

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *valueTextField;

@property (nonatomic) UIToolbar *keyboardToolbarAccessory;

@end

@interface FormTableView ()

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture;

@end

SPEC_BEGIN(FTVTextEntryViewTests)

describe(@"FTVTextEntryView", ^{
    
    __block FTVTextEntryView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVTextEntryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    });
    
    it(@"should have allocated it's views", ^{
        
        [[subject.titleLabel should] beNonNil];
        [[subject.valueTextField should] beNonNil];
    });
    
    it(@"should not have allocated a toolbar accessory", ^{
        
        [[subject.keyboardToolbarAccessory should] beNil];
    });
    
    describe(@"when setting the type to be a numbers keyboard", ^{
        
        beforeEach(^{
            
            [subject setType:FormTextFieldTypeNumbers];
        });
        
        it(@"should have a toolbar accessory", ^{
            
            [[subject.keyboardToolbarAccessory should] beNonNil];
        });
        
        describe(@"and setting it back to a text entry field", ^{
            
            beforeEach(^{
                
                [subject setType:FormTextFieldTypePlain];
            });
            
            it(@"should not have a toolbar accessory", ^{
                
                [[subject.keyboardToolbarAccessory should] beNil];
            });
        });
    });
    
    describe(@"when the return callback is set to resign the responder", ^{
        
        beforeEach(^{
            
            [subject setReturnCallback:[FTVTextEntryView returnCallbackResignResponder]];
        });
        
        describe(@"and the keyboard is resigned", ^{
            
            __block id partialSubjectMock = nil;
            __block UITextField *mockedTextField = nil;
            
            beforeEach(^{
                
                partialSubjectMock = OCMPartialMock(subject);
                mockedTextField = OCMClassMock([UITextField class]);
                
                [subject textFieldShouldReturn:mockedTextField];
            });
            
            it(@"should call the return callback", ^{
                
                OCMVerify([subject returnCallback]);
            });
            
            it(@"should try to resign the responder", ^{
                
                OCMVerify([mockedTextField resignFirstResponder]);
            });
        });
    });
    
    context(@"FormValueVerificationBlock", ^{
        
        describe(@"when the text field has been given some text", ^{
            
            beforeEach(^{
                
                [subject.valueTextField setText:@"Testing text"];
            });
            
            it(@"should return the text as the 'value'", ^{
                
                [[subject.value should] equal:@"Testing text"];
            });
        });
    });
});

describe(@"FormTableView with Text Entry", ^{
    
    __block FormTableView *ftvSubject = nil;
    __block FTVTextEntryView *subject = nil;
    
    beforeEach(^{
        
        ftvSubject = [[FormTableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 500.0f)];
        [ftvSubject setSectionedCellViews:@[@[(subject = [[FTVTextEntryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)])]].mutableCopy];
    });
    
    context(@"FormValueVerificationBlock", ^{
        
        describe(@"when the value verification block has been set", ^{
            
            beforeEach(^{
                
                [subject setVerificationBlock:[FTVTextEntryView textVerificationBlock]];
            });
            
            describe(@"and the text field has text", ^{
                
                beforeEach(^{
                    
                    [subject.valueTextField setText:@"Some Text"];
                });
                
                it(@"the table's values should be valid", ^{
                    
                    [[theValue([ftvSubject validValues]) should] equal:theValue(YES)];
                });
            });
            
            describe(@"and the text field does not have text", ^{
                
                beforeEach(^{
                    
                    [subject.valueTextField setText:nil];
                });
                
                it(@"the table's values should be valid", ^{
                    
                    [[theValue([ftvSubject validValues]) should] equal:theValue(NO)];
                });
            });
        });
    });
});

SPEC_END
