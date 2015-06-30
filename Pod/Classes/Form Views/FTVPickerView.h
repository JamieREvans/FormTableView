//
//  FTVPickerView.h
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVProtocols.h"

@class FTVInternalPickerView;

typedef NSString * (^TitleCallback)(NSArray *titles);

@interface FTVPickerView : UIView <FormCellExpansionProtocol>

@property (nonatomic) NSArray *components; // NSArray of NSArray(s) of NSString(s)
@property (nonatomic) NSArray *componentWidthWeights; // <NSNumber> from 0.0 to 1.0, @sum should be 1.0
@property (nonatomic) NSString *title;
@property (nonatomic, strong) TitleCallback titleCallback;

- (FTVInternalPickerView *)pickerView;
- (NSArray *)selectedRows;
- (NSArray *)values;
- (void)setSelectedRows:(NSArray *)selectedRows;
- (void)setSelectedValues:(NSArray *)selectedValues;

@end
