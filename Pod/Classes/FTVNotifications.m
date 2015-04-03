//
//  FTVNotifications.m
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#define FORM_EDITING_CHANGED_NOTIFICATION @"FormEditingChangedNotificationKey"

void postEditingChangedNotificationWithObject(id object)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FORM_EDITING_CHANGED_NOTIFICATION object:object];
}

void subscribeToEditingChangedNotificationsWithObjectAndSelector(id object, SEL selector)
{
    [[NSNotificationCenter defaultCenter] addObserver:object selector:selector name:FORM_EDITING_CHANGED_NOTIFICATION object:nil];
}

void unsubscribeObjectFromNotifications(id object)
{
    [[NSNotificationCenter defaultCenter] removeObserver:object];
}
