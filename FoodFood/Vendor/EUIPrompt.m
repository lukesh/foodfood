//
//  EUIPrompt.m
//  MedKit
//
//  Created by Jason Kichline on 3/23/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import "EUIPrompt.h"


@implementation EUIPrompt

@synthesize title = _title;
@synthesize message = _message;
@synthesize delegate = _delegate;
@synthesize cancelButtonTitle = _cancelButtonTitle;
@synthesize confirmButtonTitle = _confirmButtonTitle;
@synthesize fields = _fields;

-(id)init {
	if(self = [super init]) {
		_fields = [[NSMutableArray alloc] init];
	}
	return self;
}

-(id)initWithTitle:(NSString*)title 
			message:(NSString*)message 
		   delegate:(id)delegate 
  cancelButtonTitle:(NSString*)cancelButtonTitle 
confirmButtonTitle:(NSString*)confirmButtonTitle 
{
	if(self = [self init]) {
		self.title = title;
		self.message = message;
		self.delegate = delegate;
		self.cancelButtonTitle = cancelButtonTitle;
		self.confirmButtonTitle = confirmButtonTitle;
	}
	return self;
}

-(void)addTextFieldOfType:(EUIPromptType)type withLabel:(NSString*)label value:(NSString*)value {
	UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 30)];
	field.backgroundColor = [UIColor whiteColor];
	field.borderStyle = UITextBorderStyleBezel;
	if(label != nil) { field.placeholder = label; }
	if(value != nil) { field.text = value; }
	switch (type) {
		case EUIPromptTypePassword: {
			field.adjustsFontSizeToFitWidth = YES;
			field.secureTextEntry = YES;
			break;
		}
		case EUIPromptTypeEmail:
			field.keyboardType = UIKeyboardTypeEmailAddress;
			break;
		case EUIPromptTypeURL:
			field.keyboardType = UIKeyboardTypeURL;
			break;
		case EUIPromptTypeNumber:
			field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			break;
		case EUIPromptTypeInteger:
			field.keyboardType = UIKeyboardTypeNumberPad;
			break;
		default:
			break;
	}
	[_fields addObject:field];
	[field release];
}

-(UIAlertView*)show {
	float offset = 50;
	NSMutableString* m = [NSMutableString string];
	if(self.message != nil) {
		[m appendFormat:@"%@\n", self.message];
		offset += 24;
	}
	for (int i=0;i<(int)(_fields.count*2);i++) {
		[m appendString:@"\n"];
	}
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.title message:m delegate:[self retain]
										  cancelButtonTitle:self.cancelButtonTitle otherButtonTitles:self.confirmButtonTitle, nil];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 30200
	[alert setTransform:CGAffineTransformMakeTranslation(0.0, 110.0)];
#endif
	
	for (UITextField* field in _fields) {
		field.frame = CGRectMake(field.frame.origin.x, offset, field.frame.size.width, field.frame.size.height);
		offset += field.frame.size.height + 10;
		[alert addSubview:field];
	}
	if(_fields.count > 0) {
		[[_fields objectAtIndex:0] becomeFirstResponder];
	}
	[alert show];
	return [alert autorelease];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: {
			if(self.delegate != nil && [self.delegate respondsToSelector:@selector(promptDidCancel:)]) {
				[self.delegate performSelector:@selector(promptDidCancel:) withObject:self];
			}
			break;
		}
		case 1: {
			if(self.delegate != nil && [self.delegate respondsToSelector:@selector(promptDidConfirm:)]) {
				[self.delegate performSelector:@selector(promptDidConfirm:) withObject:self];
			}
			break;
		}
		default:
			break;
	}
	[alertView.delegate release];
}

- (void)dealloc {
	[_delegate release];
	[_title release];
	[_message release];
	[_cancelButtonTitle release];
	[_confirmButtonTitle release];
	[_fields release];
    [super dealloc];
}


@end
