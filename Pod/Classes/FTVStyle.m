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
        self.horizontalInset        = 8.0;
        self.cellHeight             = 44.0;
        self.headerHeight           = 40.0;
        self.headerTitleBottomInset = 5.0;
        self.footerVerticalPadding  = self.horizontalInset;
        
        self.cellTitleFont   = [UIFont fontWithType:FontTypeRegular andSize:14.0];
        self.cellValueFont   = [UIFont fontWithType:FontTypeRegular andSize:14.0];
        self.headerTitleFont = [UIFont fontWithType:FontTypeRegular andSize:16.0];
        self.footerTitleFont = [UIFont fontWithType:FontTypeRegular andSize:10.0];
        
        self.cellBackgroundColor   = [UIColor whiteColor];
        self.cellTitleTextColor    = [UIColor color256WithWhite:111.0];
        self.cellValueTextColor    = [UIColor color256WithWhite:90.0];
        self.headerBackgroundColor = [UIColor color256WithWhite:239.0];
        self.headerTextColor       = self.cellValueTextColor;
        self.footerTextColor       = self.cellTitleTextColor;
    }
    return self;
}

@end