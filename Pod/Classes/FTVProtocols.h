//
//  FTVProtocols.h
//  FormTableView
//
//  Created by James Evans on 2015-04-02.
//  Copyright (c) 2015 Jamie Riley Evans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKitPlus/UIKitPlus+Basic.h>

@protocol FormCellExpansionProtocol <NSObject>
@required

- (BOOL)isOpen;
- (void)toggleExpansion;

@optional

- (NSArray *)subcells;

@end

@protocol FormCellStyleProtocol <NSObject>
@optional

- (UIEdgeInsets)separatorInsets;

@end

@protocol FormCellSelectionProtocol <NSObject>
@required

- (UITableViewCellSelectionStyle)cellSelectionStyle;
- (void)selectedCell;

@end

@protocol FormCellDeletionProtocol <NSObject>
@required

- (BOOL)allowsDelete;
- (void)deleteCell;

@end

typedef void (^FormValueCallback)(id value, NSString *valueStringRepresentation);

@protocol FormValueCallbackProtocol <NSObject>
@required

@property (nonatomic, strong) FormValueCallback callback;

+ (NSString *)stringRepresentationOfValue:(id)value;

@end

typedef BOOL(^ValueVerificationBlock)(id valueObject);

@protocol FormValueVerificationProtocol <NSObject>
@required

@property (nonatomic, copy) ValueVerificationBlock verificationBlock;

- (id)value;

@end

@protocol FormCellOverrideProtocol <NSObject>
@optional

// Default for views not conforming to this protocol is YES
- (BOOL)allowsTapToResign;

@end
