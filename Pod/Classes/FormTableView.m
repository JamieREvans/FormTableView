//
//  FormTableView.m
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FormTableView.h"
#import "KeyboardListener.h"
#import "FTVStyle.h"

#define MINIMUM_TABLE_FOOTER 20.0f

@interface TableHeaderView : UIView
@end

@implementation TableHeaderView
@end

@interface FormTableView () <UITableViewDelegate, UITableViewDataSource, KeyboardListenerDelegate, UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *resigningTapGesture;
    
    CGFloat width, height;
}

@end

@implementation FormTableView

+ (NSMutableArray *)headerViewsWithTitles:(NSArray *)titles
{
    CGFloat horizontalInset = style().horizontalInset;
    CGFloat headerHeight = style().headerHeight;
    CGFloat headerBottomInset = style().headerTitleBottomInset;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    NSMutableArray *headerViews = [NSMutableArray new];
    for(NSString *title in titles)
    {
        if(title.length)
        {
            TableHeaderView *containerView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, headerHeight)];
            
            [containerView setBackgroundColor:style().headerBackgroundColor];
            
            UILabel *titleLabel = [UILabel labelForString:title
                                               attributes:[NSAttributes attributesWithFont:style().headerTitleFont
                                                                                 textColor:style().headerTextColor]
                                                yPosition:0.0f
                                                xPosition:horizontalInset
                                                 maxWidth:width - 2.0f * horizontalInset];
            [titleLabel alignBaselineToYPosition:containerView.height - headerBottomInset];
            [containerView addSubview:titleLabel];
            
            [headerViews addObject:containerView];
        }
        else [headerViews addObject:[UIView new]];
    }
    return headerViews;
}

+ (NSMutableArray *)footerViewsWithTitles:(NSArray *)titles
{
    CGFloat horizontalInset = style().horizontalInset;
    CGFloat topInset = style().footerVerticalPadding;
    CGFloat bottomInset = style().footerVerticalPadding;
    
    NSMutableArray *footerViews = [NSMutableArray new];
    for(NSString *title in titles)
    {
        if(title.length)
        {
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 0.0f)];
            
            UILabel *footerLabel = [UILabel labelForString:title
                                                attributes:[NSAttributes attributesWithFont:style().footerTitleFont
                                                                                  textColor:style().footerTextColor]
                                                 yPosition:topInset
                                                 xPosition:horizontalInset
                                                  maxWidth:containerView.width - horizontalInset * 2.0f];
            [containerView addSubview:footerLabel];
            [containerView setHeight:footerLabel.bottomOffset + bottomInset];
            
            [footerViews addObject:containerView];
        }
        else
        {
            [footerViews addObject:[UIView new]];
        }
    }
    return footerViews;
}

- (id)init
{
    if(self = [super init])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame style:UITableViewStyleGrouped])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    // Don't allow the user to set the table style
    return [self initWithFrame:frame];
}

- (void)commonInit
{
    width = self.width, height = self.height;
    
    self.defaultSeparatorInsets = UIEdgeInsetsZero;
    [self setSeparatorInset:self.defaultSeparatorInsets];
    
    // Remove bottom table view inset
    [self setContentInset:UIEdgeInsetsZero];
    
    // Listen for keyboard notifications
    [[KeyboardListener sharedInstance] addDelegate:self];
    
    // Add tap to resign
    [self addGestureRecognizer:(resigningTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignEverything:)])];
    [resigningTapGesture setDelegate:self];
    
    // Defaults to YES
    [self setEditable:YES];
    
    [super setDelegate:self];
    [super setDataSource:self];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];
    
    // These values will remove odd margins
    [self setTableHeaderView:[UIView viewWithSize:CGSizeMake(width, FLT_MIN)]];
    [self setTableFooterView:[UIView viewWithSize:CGSizeMake(width, FLT_MIN)]];
}

- (void)dealloc
{
    [[KeyboardListener sharedInstance] removeDelegate:self];
}

// Removes extra 20pt inset at bottom of the table view
- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom - 20.0f, contentInset.right)];
}

- (void)resignEverything:(UITapGestureRecognizer *)tapGesture
{
    [self endEditing:YES];
    [self resignPickersExcludingPicker:nil];
}

- (void)resignPickersExcludingPicker:(UIView <FormCellExpansionProtocol> *)pickerToExclude
{
    [self beginUpdates];
    
    // Exclude the picker's subcells from the toggle
    NSSet *cellsToExclude = nil;
    if([pickerToExclude respondsToSelector:@selector(subcells)])
    {
        cellsToExclude = [NSSet setWithArray:pickerToExclude.subcells];
    }
    
    for(NSArray *section in self.sectionedCellViews)
    {
        for(UIView <FormCellExpansionProtocol> *cellView in section)
        {
            if(cellView != pickerToExclude && [cellView conformsToProtocol:@protocol(FormCellExpansionProtocol)])
            {
                if(cellView.isOpen && ![cellsToExclude containsObject:cellView])
                {
                    [cellView toggleExpansion];
                }
            }
        }
    }
    
    [self endUpdates];
}

- (void)setSectionedCellViews:(NSMutableArray *)sectionedCellViews
{
    _sectionedCellViews = sectionedCellViews;
    
    [self reloadData];
}

- (void)setHeaderViews:(NSMutableArray *)headerViews
{
    _headerViews = headerViews;
    
    [self reloadData];
}

- (void)setFooterViews:(NSMutableArray *)footerViews
{
    _footerViews = footerViews;
    
    [self reloadData];
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    
    [self reloadData];
}

- (BOOL)validValues
{
    for(NSObject <FormValueVerificationProtocol> *cellView in self.sectionedCellViews)
    {
        if([cellView conformsToProtocol:@protocol(FormValueVerificationProtocol)] && !cellView.verificationBlock(cellView.value))
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - TableView Methods -

- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath
{
    return self.sectionedCellViews[indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return self.sectionedCellViews.count;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionedCellViews[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *header = (self.headerViews.count > section ? self.headerViews[section] : nil);
    return (header.height ? : FLT_MIN);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = (self.headerViews.count > section ? self.headerViews[section] : nil);
    return (header.height ? header : nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UIView *footer = (self.footerViews.count > section ? self.footerViews[section] : nil);
    return (footer.height ? : FLT_MIN);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return (self.footerViews.count > section ? self.footerViews[section] : nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self viewForIndexPath:indexPath] height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"FormTableViewCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setClipsToBounds:YES];
        
        // Prevent the cell from inheriting the table view's margin settings
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    UIView *contentView = [self viewForIndexPath:indexPath];
    [cell.contentView removeSubviews];
    [cell.contentView addSubview:contentView];
    
    // Set separator insets
    if([contentView respondsToSelector:@selector(separatorInsets)])
    {
        [cell setSeparatorInset:[(id <FormCellStyleProtocol>)contentView separatorInsets]];
    }
    else
    {
        [cell setSeparatorInset:self.defaultSeparatorInsets];
    }
    
    // Set selection style
    if([contentView conformsToProtocol:@protocol(FormCellSelectionProtocol)])
    {
        [cell setSelectionStyle:[(UIView <FormCellSelectionProtocol> *)contentView cellSelectionStyle]];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if(self.editable && !cell.userInteractionEnabled)[cell setUserInteractionEnabled:YES];
    else if(!self.editable && cell.userInteractionEnabled)[cell setUserInteractionEnabled:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIView <FormCellExpansionProtocol> *cellView = (UIView <FormCellExpansionProtocol> *)[self viewForIndexPath:indexPath];
    if([cellView conformsToProtocol:@protocol(FormCellExpansionProtocol)])
    {
        [self endEditing:YES];
        [self resignPickersExcludingPicker:cellView];
        
        [self beginUpdates];
        [cellView toggleExpansion];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self endUpdates];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    if([cellView conformsToProtocol:@protocol(FormCellSelectionProtocol)])
    {
        [(UIView <FormCellSelectionProtocol> *)cellView selectedCell];
    }
}

#pragma mark - Keyboard Methods -

- (void)adjustForKeyboardWithKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)keyboardAnimationDuration
{
    [self resignPickersExcludingPicker:nil];
    
    [KeyboardListener adjustScrollView:self
                            fullHeight:height
                    withKeyboardHeight:keyboardHeight
                     animationDuration:keyboardAnimationDuration];
}

#pragma mark - UIGestureRecognizerDelegate Methods -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // We want to disallow the resign tap gesture if the touch is on a form table view cell
    return (gestureRecognizer != resigningTapGesture ||
             touch.view       == self                ||
            [touch.view isKindOfClass:[TableHeaderView class]]);
}

@end