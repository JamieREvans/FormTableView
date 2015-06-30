#import <Cedar/Cedar.h>
#import "FTVPickerView.h"
#import "FormTableView.h"

@interface FTVPickerView ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *valueLabel;

@property (nonatomic) FTVInternalPickerView *pickerView;

@end

@interface FormTableView () <UITableViewDelegate, UITableViewDataSource>

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FTVPickerViewSpec)

describe(@"FTVPickerView", ^{
    
    __block FTVPickerView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    });
    
    it(@"should have allocated it's views", ^{
        
        subject.titleLabel should_not be_nil;
        subject.valueLabel should_not be_nil;
        subject.pickerView should_not be_nil;
    });
    
    it(@"should have a subcell that is it's internal picker", ^{
        
        subject.subcells.count should equal(1);
        subject.subcells.firstObject should equal(subject.pickerView);
    });
});

describe(@"FormTableView with Text Entry", ^{
    
    __block FormTableView *ftvSubject = nil;
    __block FTVPickerView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
        
        ftvSubject = [[FormTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 500.0)];
        [ftvSubject setSectionedCellViews:@[[@[subject] arrayByAddingObjectsFromArray:subject.subcells]].mutableCopy];
    });
    
    context(@"FormValueVerificationBlock", ^{
        
        it(@"should have a 0 height for the second cell", ^{
            
            [ftvSubject tableView:ftvSubject heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should equal((CGFloat)0.0);
        });
        
        describe(@"when the picker is toggled", ^{
            
            beforeEach(^{
                
                spy_on(subject);
                
                spy_on(subject.pickerView);
                subject.pickerView stub_method(@selector(height)).and_return((CGFloat)40.0);
                
                [ftvSubject tableView:ftvSubject didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
            afterEach(^{
                
                stop_spying_on(subject);
                stop_spying_on(subject.pickerView);
            });
            
            it(@"should toggle the picker", ^{
                
                subject should have_received(@selector(toggleExpansion));
                subject.pickerView should have_received(@selector(toggleExpansion));
            });
            
            it(@"should have expanded the picker view", ^{
                
                [ftvSubject tableView:ftvSubject heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should equal((CGFloat)40.0);
            });
        });
    });
});

SPEC_END
