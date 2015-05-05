//
//  FTVPickerView+Private.h
//  FormTableView
//
//  Created by Jamie Evans on 2015-05-05.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVPickerView.h"

// Exposed for subclassing
@interface FTVInternalPickerView : UIView <FormCellExpansionProtocol>

@property (nonatomic) NSArray *components;
@property (nonatomic, strong) void (^selectionCallback)(NSArray *titles);
@property (nonatomic) NSArray *componentWeights;

- (NSArray *)selectedRows;

@end
