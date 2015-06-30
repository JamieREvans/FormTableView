#import <Cedar/Cedar.h>
#import "FTVTextEntryView.h"
#import "FormTableView.h"

@interface FTVTextEntryView () <UITextFieldDelegate>

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *valueTextField;

@property (nonatomic) UIToolbar *keyboardToolbarAccessory;

@end

@interface FormTableView ()

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FTVTextEntryViewSpec)

describe(@"FTVTextEntryView", ^{
    
    __block FTVTextEntryView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVTextEntryView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    });
    
    it(@"should have allocated it's views", ^{
        
        subject.titleLabel should_not be_nil;
        subject.valueTextField should_not be_nil;
    });
    
    it(@"should not have allocated a toolbar accessory", ^{
        
        subject.keyboardToolbarAccessory should be_nil;
    });
    
    describe(@"when setting the type to be a numbers keyboard", ^{
        
        beforeEach(^{
            
            [subject setType:FormTextFieldTypeNumbers];
        });
        
        it(@"should have a toolbar accessory", ^{
            
            subject.keyboardToolbarAccessory should_not be_nil;
        });
        
        describe(@"and setting it back to a text entry field", ^{
            
            beforeEach(^{
                
                [subject setType:FormTextFieldTypePlain];
            });
            
            it(@"should not have a toolbar accessory", ^{
                
                subject.keyboardToolbarAccessory should be_nil;
            });
        });
    });
    
    describe(@"when the return callback is set to resign the responder", ^{
        
        beforeEach(^{
            
            [subject setReturnCallback:[FTVTextEntryView returnCallbackResignResponder]];
        });
        
        describe(@"and the keyboard is resigned", ^{
            
            beforeEach(^{
                
                spy_on(subject);
                subject stub_method(@selector(valueTextField)).and_return(nice_fake_for([UITextField class]));
                
                [subject textFieldShouldReturn:subject.valueTextField];
            });
            
            it(@"should call the return callback", ^{
                
                subject should have_received(@selector(returnCallback));
            });
            
            it(@"should try to resign the responder", ^{
                
                subject.valueTextField should have_received(@selector(resignFirstResponder));
            });
        });
    });
    
    context(@"FormValueVerificationBlock", ^{
        
        describe(@"when the text field has been given some text", ^{
            
            beforeEach(^{
                
                [subject.valueTextField setText:@"Testing text"];
            });
            
            it(@"should return the text as the 'value'", ^{
                
                subject.value should equal(@"Testing text");
            });
        });
    });
});

describe(@"FormTableView with Text Entry", ^{
    
    __block FormTableView *ftvSubject = nil;
    __block FTVTextEntryView *subject = nil;
    
    beforeEach(^{
        
        ftvSubject = [[FormTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 500.0)];
        [ftvSubject setSectionedCellViews:@[@[(subject = [[FTVTextEntryView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)])]].mutableCopy];
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
                    
                    [ftvSubject validValues] should equal(YES);
                });
            });
            
            describe(@"and the text field does not have text", ^{
                
                beforeEach(^{
                    
                    [subject.valueTextField setText:nil];
                });
                
                it(@"the table's values should be valid", ^{
                    
                    [ftvSubject validValues] should equal(NO);
                });
            });
        });
    });
});

SPEC_END
