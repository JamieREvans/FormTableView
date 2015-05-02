//
//  FTVPickerView.m
//  FormTableView
//
//  Created by James Evans on 2015-05-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import "FTVPickerView.h"
#import "FTVViewStyle.h"
#import "FTVNotifications.h"

@interface FTVPickerView ()
{
    TitleCallback _titleCallback;
    
    CGFloat width, height;
}

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *valueLabel;

@property (nonatomic) FTVInternalPickerView *pickerView;

@end

@implementation FTVPickerView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        width = frame.size.width, height = frame.size.height;
        
        [self setClipsToBounds:YES];
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    CGFloat horizontalInset = style().horizontalInset, splitPosition = viewStyle().cellValueFieldXPosition;
    
    self.titleLabel = [UILabel labelForString:nil
                                   attributes:[NSAttributes attributesWithFont:style().cellTitleFont
                                                                     textColor:style().cellTitleTextColor]
                                    yPosition:0.0f
                                    xPosition:horizontalInset
                                     maxWidth:width - (horizontalInset * 2.0f + splitPosition)];
    [self.titleLabel centerInHeight:self.height forYOffset:0.0f];
    [self addSubview:self.titleLabel];
    
    self.valueLabel = [UILabel labelForString:nil
                              attributes:[NSAttributes attributesWithFont:style().cellValueFont
                                                                textColor:style().cellValueTextColor]
                               yPosition:0.0f
                               xPosition:splitPosition
                                maxWidth:(width - (splitPosition + horizontalInset))];
    [self.valueLabel centerInHeight:height forYOffset:0.0f];
    [self addSubview:self.valueLabel];
    
    __block UILabel *valueLabelBlockReference = self.valueLabel;
    __block typeof(self) selfBlockReference = self;
    self.pickerView = [[FTVInternalPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 0.0f)];
    [self.pickerView setSelectionCallback:^(NSArray *titles)
     {
         [valueLabelBlockReference setText:selfBlockReference.titleCallback(titles)];
         
         // Form Editing Changed Notification
         postEditingChangedNotificationWithObject(selfBlockReference);
     }];
}

- (void)updateValue
{
    if(self.titleCallback && self.components.count)
    {
        NSMutableArray *titles = [NSMutableArray new];
        NSArray *selectedRows = [self selectedRows];
        for(int i = 0; i < self.components.count; i++)[titles addObject:self.components[i][[selectedRows[i] intValue]]];
        
        [self.valueLabel setText:self.titleCallback(titles)];
    }
}

- (void)setComponents:(NSArray *)components
{
    _components = components;
    
    [self.pickerView setComponents:self.components];
}

- (void)setComponentWidthWeights:(NSArray *)componentWidthWeights
{
    CGFloat weightSum = [[componentWidthWeights valueForKeyPath:@"@sum.self"] doubleValue];
    
    if(weightSum != 1.0f)
    {
        NSMutableArray *newWeights = [NSMutableArray new];
        for(NSNumber *weight in componentWidthWeights)[newWeights addObject:@(weight.doubleValue/weightSum)];
        
        _componentWidthWeights = newWeights;
    }
    else _componentWidthWeights = componentWidthWeights;
    
    [self.pickerView setComponentWeights:self.componentWidthWeights];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.titleLabel setText:title];
}

- (TitleCallback)titleCallback
{
    if(!_titleCallback)
    {
        return ^NSString * (NSArray *titles)
        {
            return [titles componentsJoinedByString:@" "];
        };
    }
    else return _titleCallback;
}

- (void)setTitleCallback:(NSString *(^)(NSArray *))titleCallback
{
    _titleCallback = titleCallback;
    
    [self updateValue];
}

- (void)setSelectedRows:(NSArray *)selectedRows
{
    UIPickerView *picker = [self.pickerView subviewOfClass:[UIPickerView class]];
    for(int i = 0; i < selectedRows.count; i++)[picker selectRow:[selectedRows[i] integerValue] inComponent:i animated:NO];
    [self updateValue];
}

- (void)setSelectedValues:(NSArray *)selectedValues
{
    UIPickerView *picker = [self.pickerView subviewOfClass:[UIPickerView class]];
    for(int i = 0; i < selectedValues.count; i++)
    {
        NSInteger index = [self.components[i] indexOfObject:selectedValues[i]];
        if(index != NSNotFound)[picker selectRow:index inComponent:i animated:NO];
    }
    [self updateValue];
}

- (NSArray *)values
{
    NSArray *selectedRows = [self selectedRows];
    NSMutableArray *values = [NSMutableArray new];
    for(int i = 0; i < selectedRows.count; i++)[values addObject:self.components[i][[selectedRows[i] integerValue]]];
    return values;
}

- (FTVInternalPickerView *)pickerView{return self.pickerView;}
- (BOOL)isOpen{return self.pickerView.isOpen;}
- (void)toggleExpansion
{
    [self.pickerView toggleExpansion];
    
    [self updateValue];
}

- (NSArray *)subCells{return @[self.pickerView];}
- (NSArray *)selectedRows{return [self.pickerView selectedRows];}

@end

#pragma mark - Date Selector View -

@interface FTVInternalPickerView () <UIPickerViewDataSource, UIPickerViewDelegate, FormCellStyleProtocol>
{
    CGFloat width, height;
    
    BOOL isHidden;
}

@property (nonatomic) UIPickerView *pickerView;

@end

@implementation FTVInternalPickerView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        width = frame.size.width;
        
        isHidden = YES;
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    CGFloat verticalInset = viewStyle().pickerVerticalPadding, pickerHeight = viewStyle().pickerViewHeight;
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, verticalInset, width, pickerHeight)];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self addSubview:self.pickerView];
    
    [self setHeight:(height = self.pickerView.bottomOffset + verticalInset)];
}

- (BOOL)isOpen{return !isHidden;}
- (void)toggleExpansion{isHidden = !isHidden;}
- (CGFloat)viewHeight{return (isHidden ? 0.0f : height);}

- (NSArray *)selectedRows
{
    NSMutableArray *selectedRows = [NSMutableArray arrayWithCapacity:[self.pickerView numberOfComponents]];
    for(int i = 0; i < self.pickerView.numberOfComponents; i++)[selectedRows addObject:@([self.pickerView selectedRowInComponent:i])];
    return selectedRows.copy;
}

- (NSArray *)titles
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[self.pickerView numberOfComponents]];
    NSArray *selectedRows = [self selectedRows];
    for(int i = 0; i < self.pickerView.numberOfComponents; i++)[titles addObject:self.components[i][[selectedRows[i] intValue]]];
    return titles.copy;
}

- (void)setComponents:(NSArray *)components
{
    _components = components;
    
    [self.pickerView reloadAllComponents];
}

- (UIEdgeInsets)separatorInsets{return UIEdgeInsetsZero;}

#pragma mark - Picker View Methods -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{return self.components.count;}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{return [self.components[component] count];}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{return self.components[component][row];}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.selectionCallback)self.selectionCallback(self.titles);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(self.componentWeights.count > component)return width * [self.componentWeights[component] doubleValue];
    return width/self.components.count;
}

@end
