//
//  FTVStyles.m
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVStyle.h"

static FTVStyle * styleInstance = nil;

FTVStyle * style()
{
    return styleInstance;
}

@implementation FTVStyle

+ (void)load
{
    styleInstance = [FTVStyle new];
}

+ (instancetype)sharedInstance
{
    return styleInstance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.horizontalInset        = 8.0f;
        self.cellHeight             = 44.0f;
        self.headerHeight           = 40.0f;
        self.headerTitleBottomInset = 5.0f;
        self.footerVerticalPadding  = self.horizontalInset;
        
        self.cellTitleFont   = [UIFont fontWithType:FontTypeRegular andSize:14.0f];
        self.cellValueFont   = [UIFont fontWithType:FontTypeRegular andSize:14.0f];
        self.headerTitleFont = [UIFont fontWithType:FontTypeRegular andSize:16.0f];
        self.footerTitleFont = [UIFont fontWithType:FontTypeRegular andSize:10.0f];
        
        self.cellBackgroundColor   = [UIColor whiteColor];
        self.cellTitleTextColor    = [UIColor color256WithWhite:111.0f];
        self.cellValueTextColor    = [UIColor color256WithWhite:90.0f];
        self.headerBackgroundColor = [UIColor color256WithWhite:239.0f];
        self.headerTextColor       = self.cellValueTextColor;
        self.footerTextColor       = self.cellTitleTextColor;
    }
    return self;
}

@end