//
//  FormTableView.h
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVProtocols.h"

@interface FormTableView : UITableView

@property (nonatomic) NSMutableArray *sectionedCellViews; // <NSArray> of <NSArray> of <UIView>
@property (nonatomic) NSMutableArray *headerViews; // <UIView>
@property (nonatomic) NSMutableArray *footerViews; // <UIView>
@property (nonatomic) BOOL canEdit; // Only used for FormCellViews

@property (nonatomic) UIEdgeInsets defaultSeparatorInsets;

// Easily Create Section Views
+ (NSMutableArray *)headerViewsWithTitles:(NSArray *)titles;
+ (NSMutableArray *)footerViewsWithTitles:(NSArray *)titles;

// Make these methods private
- (void)setDelegate:(id<UITableViewDelegate>)delegate       UNAVAILABLE_ATTRIBUTE;
- (void)setDataSource:(id<UITableViewDataSource>)dataSource UNAVAILABLE_ATTRIBUTE;

@end