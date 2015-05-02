//
//  FTVViewStyle.m
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVViewStyle.h"
#import "FTVStyle.h"

static FTVViewStyle * styleInstance = nil;

FTVViewStyle * viewStyle()
{
    return styleInstance;
}

@implementation FTVViewStyle

+ (void)load
{
    styleInstance = [self new];
}

+ (instancetype)sharedInstance
{
    return styleInstance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.cellTitleWidth         = 120.0f;
        self.pickerViewHeight       = 180.0f;
        self.pickerVerticalPadding  = 20.0f;
    }
    return self;
}

- (CGFloat)cellValueFieldXPosition{return self.cellTitleWidth + style().horizontalInset * 2.0f;}

@end