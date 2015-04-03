//
//  ArrayTests.m
//  FoundationPlus
//
//  Created by Jamie Evans on 2015-03-16.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <FormTableView/FormTableView.h>
#import <FormTableView/KeyboardListener.h>

SPEC_BEGIN(UIFontTests)

describe(@"FormTableView", ^{
    
    __block FormTableView *subject = nil;
    
    context(@"when creating the tableview", ^{
        
        beforeEach(^{
            
            subject = [FormTableView new];
        });
        
        it(@"should have set header and footer views", ^{
            
            [[subject.tableHeaderView shouldNot] beNil];
            [[subject.tableFooterView shouldNot] beNil];
        });
        
        it(@"should have set the content insets to have a -20 pixel bottom inset", ^{
            
            [[@(round(subject.contentInset.bottom)) should] equal:@(-20.0f)];
        });
        
        it(@"should have setup autoresizing", ^{
            
            [[@(subject.autoresizingMask) should] equal:@(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin)];
        });
        
        it(@"should be editable", ^{
            
            [[@(subject.editable) should] equal:@(true)];
        });
        
        it(@"should be it's own delegate and datasource", ^{
            
            [[(NSObject *)subject.delegate should] equal:subject];
            [[(NSObject *)subject.dataSource should] equal:subject];
        });
        
        it(@"should have a tap gesture", ^{
            
            [[subject.gestureRecognizers.lastObject should] beKindOfClass:[UITapGestureRecognizer class]];
        });
        
        it(@"should have set it's separator insets to be UIEdgeInsetsZero", ^{
            
            [[[NSValue valueWithUIEdgeInsets:subject.separatorInset] should] equal:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]];
        });
    });
});

SPEC_END
