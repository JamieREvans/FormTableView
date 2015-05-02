//
//  FTWViewController.m
//  FormTableView
//
//  Created by Jamie Riley Evans on 04/02/2015.
//  Copyright (c) 2014 Jamie Riley Evans. All rights reserved.
//

#import <FormTableView/FormTableView.h>
#import "FTVViewController.h"
#import "FormTableView+Initializers.h"

@interface FTVViewController ()

@end

@implementation FTVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildUI];
}

- (void)buildUI
{
    FormTableView *tableView = [[FormTableView alloc] initWithFrame:self.view.bounds];
    [tableView setSectionedCellViews:(@[@[[FormTableView textFieldWithTitle:@"Sample Field" type:FormTextFieldTypeNumbers isLastTextField:YES]],
                                        @[[self viewWithColor:[UIColor redColor]], [self viewWithColor:[UIColor orangeColor]], [self viewWithColor:[UIColor yellowColor]]],
                                        @[[self viewWithColor:[UIColor greenColor]], [self viewWithColor:[UIColor blueColor]]],
                                        @[[self viewWithColor:[UIColor purpleColor]], [self viewWithColor:[UIColor magentaColor]]]].mutableCopy)];
    [tableView setHeaderViews:[FormTableView headerViewsWithTitles:@[@"", @"Hot", @"Cool", @"Warm"]]];
    [tableView setFooterViews:[FormTableView footerViewsWithTitles:@[@"",
                                                                     @"Above are our 'hot' colors",
                                                                     @"Above are our 'cold' colors",
                                                                     @"Above are our 'warm' colors"]]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

- (UIView *)viewWithColor:(UIColor *)color
{
    UIView *colorView = [UIView viewWithSize:CGSizeMake(self.view.width, 60.0f)];
    [colorView setBackgroundColor:color];
    return colorView;
}

@end
