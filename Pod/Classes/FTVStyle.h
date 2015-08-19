//
//  FTVStyles.h
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "UIKitPlus+Basic.h"
#import <Foundation/Foundation.h>

@class FTVStyle;
// Convenience method - returns the same value as [FTVStyle sharedInstance]
FTVStyle * style();

@interface FTVStyle : NSObject

// Sizes
@property (nonatomic) CGFloat horizontalInset;
// Used in cellFrame for creating template cell views
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat headerTitleBottomInset;
@property (nonatomic) CGFloat footerVerticalPadding;

// Fonts
@property (nonatomic) UIFont *cellTitleFont;
@property (nonatomic) UIFont *cellValueFont;
@property (nonatomic) UIFont *headerTitleFont;
@property (nonatomic) UIFont *footerTitleFont;

// Colors
@property (nonatomic) UIColor *cellBackgroundColor;
@property (nonatomic) UIColor *cellTitleTextColor;
@property (nonatomic) UIColor *cellValueTextColor;
@property (nonatomic) UIColor *headerBackgroundColor;
@property (nonatomic) UIColor *headerTextColor;
@property (nonatomic) UIColor *footerTextColor;

+ (instancetype)sharedInstance;

@end
