//
//  EUIFormField.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EUIForm;
@class EUIFormField;

#pragma mark Protocols

@protocol EUIFormFieldDelegate <NSObject>
@optional
-(NSString*)stringForField:(EUIFormField*) field;
-(NSString*)htmlForField:(EUIFormField*) field;
-(void)fieldHasChanged:(EUIFormField*) field;
-(void)fieldSelected:(EUIFormField*) field;
@end

#pragma mark Enums

typedef enum {
	EUIFormFieldTypeText,
	EUIFormFieldTypeStrings,
	EUIFormFieldTypePassword,
	EUIFormFieldTypeTextArea,
	EUIFormFieldTypeURL,
	EUIFormFieldTypeEmail,
	EUIFormFieldTypeDate,
	EUIFormFieldTypeTime,
	EUIFormFieldTypeDateAndTime,
	EUIFormFieldTypeNumber,
	EUIFormFieldTypeInteger,
	EUIFormFieldTypePhone,
	EUIFormFieldTypeSlider,
	EUIFormFieldTypeBoolean,
	EUIFormFieldTypeColor,
	EUIFormFieldTypeList,
	EUIFormFieldTypeCheckList,
	EUIFormFieldTypeLabel,
	EUIFormFieldTypeTextEditor,
	EUIFormFieldTypeCustom
} EUIFormFieldType;

@interface EUIFormField : NSObject <UITextFieldDelegate, UITextViewDelegate> {
	
	// Function
	EUIFormFieldType _type;
	UIView* _control;
	NSString* _name;
	id _object;
	NSString* _property;
	SEL _action;
	EUIForm* _form;
	NSArray* _options;
	id _value;
	NSString* _optionsProperty;
	NSString* _optionsValueProperty;
	NSString* _optionsChildrenProperty;
	NSString* _optionsSectionProperty;
	NSString* _optionsIconProperty;
	NSString* _dataType;
	NSString* _noValueLabelText;
	UITextAlignment _labelAlignment;
	id<EUIFormFieldDelegate> _delegate;
	
	// Interaction
	NSString* _stringValue;
	int _maxLength;
	BOOL _editable;
	BOOL _required;
	BOOL _showLabel;

	// Appearance
	UIImage* _icon;
	NSDateFormatter* _dateFormatter;
	NSNumberFormatter* _numberFormatter;
	UIViewController* _viewController;
	UIColor* _labelColor;
	UIColor* _highlightColor;
	UIFont* _controlFont;
	UIColor* _controlColor;
	UITextAlignment _controlAlignment;
	BOOL _controlAlignmentSet;
	UIFont* _labelFont;
	float _labelWidth;
	float _padding;
	float _height;
	
	// Suffixes
	UILabel* _suffix;
	float _scale;
	BOOL _showsSliderStatus;
	
	// Custom action
	id _target;
	SEL _selector;
}

@property EUIFormFieldType type;
@property (nonatomic, retain) UIView* control;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString* property;
@property (nonatomic, retain) EUIForm* form;
@property (nonatomic, retain) id options;
@property (nonatomic, retain) NSString* optionsProperty;
@property (nonatomic, retain) NSString* optionsValueProperty;
@property (nonatomic, retain) NSString* optionsChildrenProperty;
@property (nonatomic, retain) NSString* optionsSectionProperty;
@property (nonatomic, retain) NSString* optionsIconProperty;
@property (nonatomic, retain) id<EUIFormFieldDelegate> delegate;
@property (nonatomic, retain) NSString* noValueLabelText;
@property SEL action;

@property (nonatomic, retain) NSString* stringValue;
@property BOOL editable;
@property BOOL required;
@property BOOL showLabel;
@property int maxLength;
@property UITextAlignment labelAlignment;

@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSString* dataType;
@property (nonatomic, retain) UIImage* icon;
@property (nonatomic, retain) NSDateFormatter* dateFormatter;
@property (nonatomic, retain) NSNumberFormatter* numberFormatter;
@property (nonatomic, retain) UIViewController* viewController;
@property (nonatomic, retain) UIColor* labelColor;
@property (nonatomic, retain) UIColor* highlightColor;
@property (nonatomic, retain) UIFont* labelFont;
@property (nonatomic, retain) UIFont* controlFont;
@property (nonatomic, retain) UIColor* controlColor;
@property UITextAlignment controlAlignment;
@property float height;
@property float labelWidth;
@property float padding;

@property (nonatomic, retain) UIView* suffix;
@property float scale;
@property BOOL showsSliderStatus;

@property (retain, nonatomic, readonly) id target;
@property (readonly) SEL selector;
@property (readonly) NSString* html;

#pragma mark Internal Methods

-(void)updateFieldDisplay;
-(void)updateDataSourceValue;
-(void)updateDataSourceValue:(id)value;
-(BOOL)validateIntoArray:(NSMutableArray*)errors;

#pragma mark Creation Methods

// Creates a new field with a built-in type
-(id)initWithType:(EUIFormFieldType) fieldType;
-(id)initWithType:(EUIFormFieldType) fieldType;
-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name;
-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name object: (id) object property: (NSString*) property;
-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name object: (id) object property: (NSString*) property action: (SEL) action;

// Creates a new field with a custom type
-(id)initWithCustom:(UIControl*) control;
-(id)initWithCustom:(UIControl*) control;
-(id)initWithCustom:(UIControl*) control name: (NSString*) name;
-(id)initWithCustom:(UIControl*) control name: (NSString*) name object: (id) object property: (NSString*) property;
-(id)initWithCustom:(UIControl*) control name: (NSString*) name object: (id) object property: (NSString*) property action: (SEL) action;

// Creates a new label field with a static value
-(id)initWithValue:(NSString*) stringValue name: (NSString*) name;

// Draws the field into a UITableViewCell
-(void)drawCell:(UITableViewCell*)cell;
+(NSString*)getString:(id)value forField:(EUIFormField*)field;
+(NSString*)getHtml:(id)value forField:(EUIFormField*)field;

-(int)findIndexOf:(id)item inList:(NSArray*)list;
-(BOOL)isItem:(id)item inList:(NSArray*)list;

-(void)addTarget: (id) target action: (SEL) action;
-(void)selectFromList;

@end
