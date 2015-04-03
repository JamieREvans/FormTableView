//
//  KeyboardListener.h
//  IP Workspace
//
//  Created by Jamie Evans on 2012-09-07.
//  Copyright (c) 2012 VRG Interactive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardListenerDelegate;
@interface KeyboardListener : NSObject
{
    NSMutableArray *delegates;
}

+ (void)startListeningWithDelegate:(id <KeyboardListenerDelegate>)delegate;
+ (KeyboardListener *)sharedInstance;

- (void)addDelegate:(id <KeyboardListenerDelegate>)newDelegate;
- (void)removeDelegate:(id <KeyboardListenerDelegate>)currentDelegate;

// Convenience
// Pass the UIScrollView's original height to fullHeight
+ (void)adjustScrollView:(UIScrollView *)scrollView fullHeight:(CGFloat)fullHeight withKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)keyboardAnimationDuration;

@end

@protocol KeyboardListenerDelegate <NSObject>
@optional

- (void)adjustForKeyboardWithKeyboardHeight:(CGFloat)keyboardHeight;
- (void)adjustForKeyboardWithKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)keyboardAnimationDuration;

@end