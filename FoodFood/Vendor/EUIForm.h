//
//  EUIForm.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIFormField.h"
#import "EUIFormGroup.h"
#import "EUITableViewController.h"

@interface EUIForm : EUITableViewController {
	NSMutableArray* _groups;
	NSMutableArray* _fields;
	NSMutableDictionary* _lookup;
	float _labelWidth;
	float _padding;
	UIViewController* _parent;
	UIColor* _labelColor;
	UIFont* _labelFont;
	int footerHeight;
	EUIFormField* _selectedField;
	NSString* _noValueLabelText;
	BOOL _editable;
	UITextAlignment _labelAlignment;
	NSString* _mode;
	BOOL _rewireViewMethods;
	UIColor* _controlColor;
	UIFont* _controlFont;	
	UITextAlignment _controlAlignment;
	BOOL _changed;
}

@property float padding;
@property float labelWidth;
@property BOOL editable;
@property BOOL changed;
@property UITextAlignment labelAlignment;
@property (nonatomic, retain) NSMutableArray* groups;
@property (nonatomic, retain) NSMutableArray* fields;
@property (nonatomic, retain) UIViewController* parent;
@property (nonatomic, retain) UIColor* labelColor;
@property (nonatomic, retain) UIFont* labelFont;
@property (nonatomic, retain) UIColor* controlColor;
@property (nonatomic, retain) UIFont* controlFont;
@property UITextAlignment controlAlignment;
@property (nonatomic, retain) EUIFormField* selectedField;
@property (nonatomic, retain) NSString* noValueLabelText;
@property (nonatomic, retain) NSString* mode;
@property (readonly) NSString* html;
@property BOOL rewireViewMethods;

-(EUIFormField*)getField:(NSString*)name;
-(EUIFormGroup*)addGroup:(NSString*) groupName;
-(EUIFormGroup*)addGroup:(NSString*) groupName withDescription:(NSString*)description;
-(EUIFormField*)addFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property;
-(EUIFormField*)addRequiredFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property;
-(UIButton*)addButton: (NSString*) name target: (id) target action: (SEL) action;
-(EUIFormField*)addCustomField:(UIControl*)control withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property;
-(EUIFormField*)addLabel:(NSString*) value withName: (NSString*) name;
-(EUIFormField*)addFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*) mode;
-(EUIFormField*)addRequiredFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*) mode;
-(UIButton*)addButton: (NSString*) name target: (id) target action: (SEL) action intoFormMode:(NSString*) mode;
-(EUIFormField*)addCustomField:(UIControl*)control withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*) mode;
-(EUIFormField*)addLabel:(NSString*) value withName: (NSString*) name intoFormMode:(NSString*) mode;
-(void)clear;
-(id)addItem:(id)item withName:(NSString*)name intoFormMode:(NSString*)mode;
-(void)setMode:(NSString *) value withAnimation:(UITableViewRowAnimation)animation;

-(NSMutableArray*)validate;
+(void)revealView:(UIView*)viewToReveal inViews:(NSArray*) views;
+(void)revealView:(UIView*)viewToReveal inViews:(NSArray*) views withAnimationDuration:(float)duration;
+(UITextAlignment)defaultLabelAlignment;
+(UIColor*)defaultLabelColor;
+(UIFont*)defaultLabelFont;

+(UITextAlignment)defaultControlAlignment;
+(UIFont*)defaultControlFont;
+(UIColor*)defaultControlColor;
+(float)defaultFieldHeight;
+(float)defaultLabelWidth;
+(float)defaultPadding;
+(NSString*)defaultNoValueLabelText;

@end
