//
//  FTVNotifications.h
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

void postEditingChangedNotificationWithObject(id object);
void subscribeToEditingChangedNotificationsWithObjectAndSelector(id object, SEL selector);
void unsubscribeObjectFromNotifications(id object);
