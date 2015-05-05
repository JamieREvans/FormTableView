//
//  ArrayTests.m
//  FoundationPlus
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVPickerView+Private.h"
#import "FormTableView.h"

@interface FTVPickerView ()
{
    TitleCallback _titleCallback;
    
    CGFloat width, height;
}

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *valueLabel;

@property (nonatomic) FTVInternalPickerView *pickerView;

@end

@interface FormTableView () <UITableViewDelegate, UITableViewDataSource>

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture;

@end

SPEC_BEGIN(FTVPickerViewTests)

describe(@"FTVPickerView", ^{
    
    __block FTVPickerView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    });
    
    it(@"should have allocated it's views", ^{
        
        [[subject.titleLabel should] beNonNil];
        [[subject.valueLabel should] beNonNil];
        [[subject.pickerView should] beNonNil];
    });
    
    it(@"should have a subcell that is it's internal picker", ^{
        
        [[theValue(subject.subcells.count) should] equal:theValue(1)];
        [[subject.subcells.firstObject should] equal:subject.pickerView];
    });
});

describe(@"FormTableView with Text Entry", ^{
    
    __block FormTableView *ftvSubject = nil;
    __block FTVPickerView *subject = nil;
    
    beforeEach(^{
        
        subject = [[FTVPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        
        ftvSubject = [[FormTableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 500.0f)];
        [ftvSubject setSectionedCellViews:@[[@[subject] arrayByAddingObjectsFromArray:subject.subcells]].mutableCopy];
    });
    
    context(@"FormValueVerificationBlock", ^{
        
        it(@"should have a 0 height for the second cell", ^{
            
            [[theValue([ftvSubject tableView:ftvSubject heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) should] equal:theValue(0.0f)];
        });
        
        describe(@"when the picker is toggled", ^{
            
            __block id pickerPartialMock = nil;
            
            beforeEach(^{
                
                pickerPartialMock = OCMPartialMock(subject);
                
                [ftvSubject tableView:ftvSubject didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
            it(@"should toggle the picker", ^{
                
                OCMVerify([pickerPartialMock toggleExpansion]);
            });
            
            it(@"should have expanded the picker view", ^{
                
                [[theValue([ftvSubject tableView:ftvSubject heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) shouldNot] equal:theValue(0.0f)];
            });
        });
    });
});

SPEC_END
