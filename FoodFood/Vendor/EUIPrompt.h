//
//  EUIPrompt.h
//  MedKit
//
//  Created by Jason Kichline on 3/23/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EUIPrompt;

@protocol EUIPromptDelegate <NSObject>
@optional
-(void)promptDidCancel:(EUIPrompt*)prompt;
-(void)promptDidConfirm:(EUIPrompt*)prompt;
@end

typedef enum {
	EUIPromptTypeText,
	EUIPromptTypePassword,
	EUIPromptTypeURL,
	EUIPromptTypeEmail,
	EUIPromptTypeNumber,
	EUIPromptTypeInteger
} EUIPromptType;

@interface EUIPrompt : UIView <UIAlertViewDelegate> {
	id<EUIPromptDelegate> _delegate;
	NSString* _title;
	NSString* _message;
	NSString* _cancelButtonTitle;
	NSString* _confirmButtonTitle;
	NSMutableArray* _fields;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* cancelButtonTitle;
@property (nonatomic, retain) NSString* confirmButtonTitle;
@property (readonly) NSMutableArray* fields;

-(id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<EUIPromptDelegate>)delegate cancelButtonTitle:(NSString*)cancelButtonTitle confirmButtonTitle:(NSString*)confirmButtonTitle;
-(void)addTextFieldOfType:(EUIPromptType)type withLabel:(NSString*)label value:(NSString*)value;
-(UIAlertView*)show;

@end
