//
//  KeyboardListener.m
//  IP Workspace
//
//  Created by Jamie Evans on 2012-09-07.
//  Copyright (c) 2012 VRG Interactive Inc. All rights reserved.
//

#import <UIKitPlus+Basic.h>
#import "KeyboardListener.h"

static KeyboardListener *sharedInstance;

@implementation KeyboardListener

+ (void)load
{
    sharedInstance = [self new];
}

+ (KeyboardListener *)sharedInstance
{
    return sharedInstance;
}

+ (void)startListeningWithDelegate:(id <KeyboardListenerDelegate>)delegate
{
    if(delegate)
    {
        [[self sharedInstance] addDelegate:delegate];
    }
}

- (id)init
{
    self = [super init];
    if(self)
    {
        CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
        delegates = (__bridge_transfer NSMutableArray *)(CFArrayCreateMutable(0, 0, &callbacks));
        
        NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
        [noteCenter addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        [noteCenter addObserver:self selector:@selector(keyboardWillHideWithNotification:) name:UIKeyboardWillHideNotification object:nil];
        [noteCenter addObserver:self selector:@selector(keyboardWillChangeFrameWithNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addDelegate:(id<KeyboardListenerDelegate>)newDelegate
{
    @synchronized(self)
    {
        if(newDelegate)
        {
            [delegates addObject:newDelegate];
        }
    }
}

- (void)removeDelegate:(id <KeyboardListenerDelegate>)currentDelegate
{
    @synchronized(self)
    {
        if(currentDelegate)
        {
            [delegates removeObject:currentDelegate];
        }
    }
}

// Convenience
+ (void)adjustScrollView:(UIScrollView *)scrollView fullHeight:(CGFloat)fullHeight withKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)keyboardAnimationDuration
{
    CGFloat fullScreenHeight = [UIApplication sharedApplication].keyWindow.height;
    CGFloat extraHeight = (fullScreenHeight - (scrollView.superview.bottomOffset - (scrollView.superview.height - fullHeight)));
    NSTimeInterval delay = (MAX(extraHeight/(keyboardHeight != 0.0f ? keyboardHeight : FLT_MAX), 0.0f) * keyboardAnimationDuration);
    if(keyboardHeight > 0)
    {
        delay = keyboardAnimationDuration - 0.05f;
    }
    
    [UIView animateWithDuration:(keyboardAnimationDuration - delay)
                          delay:((scrollView.height != fullHeight) ? 0.0f : delay)
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGFloat newHeight = MIN(fullHeight, (fullHeight - (keyboardHeight - extraHeight)));
         CGFloat bottomInset = fullHeight - newHeight;
         UIEdgeInsets insets = scrollView.contentInset;
         insets.bottom = bottomInset;
         [scrollView setContentInset:insets];
         [scrollView setScrollIndicatorInsets:insets];
     }
                     completion:^(BOOL finished){}];
}

#pragma mark - NSNotificationCenter Methods -

- (void)alertDelegatesForNewKeyboardHeight:(CGFloat)keyboardHeight andAnimationDuration:(NSTimeInterval)animationDuration
{
    if(delegates)
    {
        for(id <KeyboardListenerDelegate> delegate in delegates)
        {
            if(!delegate)
            {
                [delegates removeObject:delegate];
            }
            else
            {
                if([delegate respondsToSelector:@selector(adjustForKeyboardWithKeyboardHeight:animationDuration:)])
                {
                    [delegate adjustForKeyboardWithKeyboardHeight:keyboardHeight animationDuration:animationDuration];
                }
                else if([delegate respondsToSelector:@selector(adjustForKeyboardWithKeyboardHeight:)])
                {
                    [delegate adjustForKeyboardWithKeyboardHeight:keyboardHeight];
                }
            }
        }
    }
}

- (CGFloat)keyboardHeightFromNotification:(NSNotification *)notification
{
    return CGRectGetHeight([(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
}

- (NSTimeInterval)animationDurationFromNotification:(NSNotification *)notification
{
    return [(notification.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardWillShowWithNotification:(NSNotification *)note
{
    [self alertDelegatesForNewKeyboardHeight:[self keyboardHeightFromNotification:note]
                        andAnimationDuration:[self animationDurationFromNotification:note]];
}

- (void)keyboardWillHideWithNotification:(NSNotification *)note
{
    [self alertDelegatesForNewKeyboardHeight:0.0f
                        andAnimationDuration:[self animationDurationFromNotification:note]];
}

- (void)keyboardWillChangeFrameWithNotification:(NSNotification *)note
{
    [self alertDelegatesForNewKeyboardHeight:[self keyboardHeightFromNotification:note]
                        andAnimationDuration:[self animationDurationFromNotification:note]];
}

@end