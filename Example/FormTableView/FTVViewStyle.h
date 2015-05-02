//
//  FTVViewStyle.h
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTVStyle.h"

@class FTVViewStyle;
// Convenience method - returns the same value as [FTVStyle sharedInstance]
FTVViewStyle * viewStyle();

@interface FTVViewStyle : NSObject

// The width of the title - determines the size of the value field as (width - (cellTitleWidth + horizontalInset * 3))
@property (nonatomic) CGFloat cellTitleWidth;
// cellTitleWidth + horizontalInset * 2
@property (nonatomic, readonly) CGFloat cellValueFieldXPosition;
@property (nonatomic) CGFloat pickerViewHeight;
// Additional padding in the FTVInternalPickerView cell on the top and bottom of the UIPickerView
@property (nonatomic) CGFloat pickerVerticalPadding;

@end