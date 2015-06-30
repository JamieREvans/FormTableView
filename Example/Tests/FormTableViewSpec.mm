#import <Cedar/Cedar.h>
#import "FormTableView.h"
#import "FTVTextEntryView.h"
#import "FormTableView+Initializers.h"
#import "FTVStyle.h"

@interface FormTableView () <UITableViewDelegate, UITableViewDataSource>

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture;

@end

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FormTableViewSpec)

describe(@"FormTableView", ^{
    
    __block FormTableView *subject;

    beforeEach(^{
        
        subject = [FormTableView new];
    });
    
    describe(@"when creating the tableview", ^{
        
        it(@"should have set header and footer views", ^{
            
            subject.tableHeaderView should_not be_nil;
            subject.tableFooterView should_not be_nil;
        });
        
        it(@"should have set the content insets to have a -20 pixel bottom inset", ^{
            
            round(subject.contentInset.bottom) should equal(-20.0f);
        });
        
        it(@"should have setup autoresizing", ^{
            
            subject.autoresizingMask should equal(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
        });
        
        it(@"should be editable", ^{
            
            subject.editable should equal(true);
        });
        
        it(@"should be it's own delegate and datasource", ^{
            
            subject.delegate should equal(subject);
            subject.dataSource should equal(subject);
        });
        
        it(@"should have a tap gesture", ^{
            
            [subject.gestureRecognizers.lastObject isKindOfClass:[UITapGestureRecognizer class]] should be_truthy;
        });
        
        it(@"should have set it's separator insets to be UIEdgeInsetsZero", ^{
            
            subject.separatorInset should equal(UIEdgeInsetsZero);
        });
        
        it(@"should have set it's cellBackgroundColor to match FTVStyle", ^{
            
            subject.cellBackgroundColor should equal([FTVStyle sharedInstance].cellBackgroundColor);
        });
    });
    
    describe(@"when setting the cellBackgroundColor", ^{
        
        beforeEach(^{
            
            [subject setCellBackgroundColor:[UIColor blueColor]];
            [subject setSectionedCellViews:@[@[[UIView new]]].mutableCopy];
            [subject reloadData];
            
            [subject tableView:subject cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
        
        it(@"should set the cell's background color to blue", ^{
            
            UITableViewCell *cell = [subject tableView:subject cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.backgroundColor should equal([UIColor blueColor]);
        });
    });
    
    describe(@"when a view has a FTVTextEntryView", ^{
        
        beforeEach(^{
            
            [subject setSectionedCellViews:@[@[[FormTableView textFieldWithTitle:@"Title" type:FormTextFieldTypePlain isLastTextField:YES],
                                               [UIView new]]].mutableCopy];
        });
        
        describe(@"and the text entry view is selected", ^{
            
            beforeEach(^{
                
                spy_on(subject);
                subject stub_method(@selector(resignEverything:));
                
                [subject tableView:subject didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
            afterEach(^{
                
                stop_spying_on(subject);
            });
            
            it(@"should not call resignEverything", ^{
                
                subject should_not have_received(@selector(resignEverything:));
            });
        });
        
        describe(@"and another view is tapped", ^{
            
            beforeEach(^{
                
                spy_on(subject);
                subject stub_method(@selector(resignEverything:));
                
                [subject tableView:subject didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            });
            
            afterEach(^{
                
                stop_spying_on(subject);
            });
            
            it(@"should not call resignEverything", ^{
                
                subject should have_received(@selector(resignEverything:)).with(nil);
            });
        });
    });
});

SPEC_END
