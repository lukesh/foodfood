//
//  EUIFormField.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormField.h"
#import "EUIFormDatePicker.h"
#import "EUIFormFieldList.h"
#import "EUIFormStringsEditor.h"
#import "EUIFormTextEditor.h"
#import "EUIForm.h"
#import "EUIObject.h"
#import "EUIPhoneNumber.h"
#import <objc/runtime.h>

@implementation EUIFormField

#pragma mark Synthesize

@synthesize type = _type;
@synthesize control = _control;
@synthesize name = _name;
@synthesize object = _object;
@synthesize property = _property;
@synthesize action = _action;
@synthesize options = _options;
@synthesize optionsProperty = _optionsProperty;
@synthesize optionsValueProperty = _optionsValueProperty;
@synthesize optionsChildrenProperty = _optionsChildrenProperty;
@synthesize optionsSectionProperty = _optionsSectionProperty;
@synthesize optionsIconProperty = _optionsIconProperty;
@synthesize height = _height;
@synthesize stringValue = _stringValue;
@synthesize editable = _editable;
@synthesize labelColor = _labelColor;
@synthesize highlightColor = _highlightColor;
@synthesize labelFont = _labelFont;
@synthesize controlFont = _controlFont;
@synthesize controlColor = _controlColor;
@synthesize controlAlignment = _controlAlignment;
@synthesize maxLength = _maxLength;
@synthesize form = _form;
@synthesize labelWidth = _labelWidth;
@synthesize padding = _padding;
@synthesize dateFormatter = _dateFormatter;
@synthesize numberFormatter = _numberFormatter;
@synthesize viewController = _viewController;
@synthesize icon = _icon;
@synthesize dataType = _dataType;
@synthesize delegate = _delegate;
@synthesize value = _value;
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize required = _required;
@synthesize noValueLabelText = _noValueLabelText;
@synthesize showLabel = _showLabel;
@synthesize labelAlignment = _labelAlignment;
@synthesize suffix = _suffix;
@synthesize scale = _scale;
@synthesize showsSliderStatus = _showsSliderStatus;

#pragma mark Initialization

-(id)init{
	if(self = [super init]) {
		self.labelColor = nil;
		self.controlColor = nil;
		self.highlightColor = nil;
		self.labelFont = [EUIForm defaultLabelFont];
		self.controlFont = [EUIForm defaultControlFont];
		self.height = [EUIForm defaultFieldHeight];
		_controlAlignment = [EUIForm defaultControlAlignment];
		_viewController = nil;
		_dateFormatter = nil;
		_editable = YES;
		_labelWidth = -1;
		_maxLength = -1;
		_padding = -1;
		_noValueLabelText = nil;
		_showLabel = YES;
		_controlAlignmentSet = NO;
	}
	return self;
}

-(id)initWithType:(EUIFormFieldType) fieldType{
	if(self = [self init]) {
		self.type = fieldType;
	}
	return self;
}

-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name {
	if(self = [self initWithType:fieldType]) {
		self.name = name;
	}
	return self;
}

-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name object: (id) object property: (NSString*) property {
	if(self = [self initWithType:fieldType name:name]) {
		self.object = object;
		self.property = property;
	}
	return self;
}

-(id)initWithType:(EUIFormFieldType) fieldType name: (NSString*) name object: (id) object property: (NSString*) property action: (SEL) action {
	if(self = [self initWithType:fieldType name:name object:object property:property]) {
		self.action = action;
	}
	return self;
}

-(id)initWithCustom:(UIControl*) control{
	if(self = [self init]) {
		self.type = EUIFormFieldTypeCustom;
		self.control = control;
	}
	return self;
}

-(id)initWithCustom:(UIControl*) control name: (NSString*) name {
	if(self = [self initWithCustom:control]) {
		self.name = name;
	}
	return self;
}

-(id)initWithCustom:(UIControl*) control name: (NSString*) name object: (id) object property: (NSString*) property {
	if(self = [self initWithCustom:control name:name]) {
		self.object = object;
		self.property = property;
	}
	return self;
}

-(id)initWithCustom:(UIControl*) control name: (NSString*) name object: (id) object property: (NSString*) property action: (SEL) action {
	if(self = [self initWithCustom:control name:name object:object property:property]) {
		self.action = action;
	}
	return self;
}

-(id)initWithValue:(NSString*) stringValue name: (NSString*) name {
	if(self = [self init]) {
		self.type = EUIFormFieldTypeLabel;
		self.name = name;
		self.stringValue = stringValue;
	}
	return self;
}

#pragma mark Getter Overrides

// Get the type of the object
-(NSString*)dataType{
	if(_dataType == nil) {
		if([self.object isKindOfClass:[NSDictionary class]]) {
			return @"@";
		}
		objc_property_t property = class_getProperty([self.object class], [self.property cStringUsingEncoding:NSASCIIStringEncoding]);
		if(property!=nil) {
			NSString* attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];
			NSArray* a = [attributes componentsSeparatedByString:@","];
			_dataType = [[a objectAtIndex:0] substringFromIndex:1];
		}
	}
	return _dataType;
}

-(NSDateFormatter*)dateFormatter{
	if(_dateFormatter == nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		switch(self.type) {
			case EUIFormFieldTypeDate:
				[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
				break;
			case EUIFormFieldTypeTime:
				[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
				break;
			case EUIFormFieldTypeDateAndTime:
				[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
				[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
				break;
		}
	}
	return _dateFormatter;
}

-(NSNumberFormatter*)numberFormatter{
	if(_numberFormatter == nil) {
		_numberFormatter = [[NSNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	return _numberFormatter;
}

-(float)labelWidth{
	if(_labelWidth < 0) {
		if(self.form == nil) {
			return [EUIForm defaultLabelWidth];
		} else {
			return self.form.labelWidth;
		}
	} else {
		return _labelWidth;
	}
}

-(UIColor*)labelColor{
	if(_labelColor == nil) {
		if(self.form == nil) {
			return [EUIForm defaultLabelColor];
		} else {
			return self.form.labelColor;
		}
	} else {
		return _labelColor;
	}
}

-(UIColor*)controlColor{
	if(_controlColor == nil) {
		if(self.form == nil) {
			return [EUIForm defaultControlColor];
		} else {
			return self.form.controlColor;
		}
	} else {
		return _controlColor;
	}
}

-(UIColor*)highlightColor{
	if(_highlightColor == nil) {
		if(self.form == nil) {
			return nil;
		} else {
			return self.form.highlightColor;
		}
	} else {
		return _highlightColor;
	}
}

-(float)padding{
	if(_padding < 0) {
		if(self.form == nil) {
			return [EUIForm defaultPadding];
		} else {
			return self.form.padding;
		}
	} else {
		return _padding;
	}
}

-(NSString*)noValueLabelText{
	NSString* o = @"";
	if (_noValueLabelText == nil) {
		if(self.form == nil) {
			o = [EUIForm defaultNoValueLabelText];
		} else {
			o = self.form.noValueLabelText;
		}
	} else {
		o = _noValueLabelText;
	}
	if(o == nil) { o = @""; }
	return o;
}

-(id)value{
	if(self.object != nil && self.property != nil) {
		id anotherValue = nil;
		if([self.object isKindOfClass:[NSDictionary class]]) {
			anotherValue = [(NSDictionary*)self.object objectForKey:self.property];
		} else {
			SEL getter = NSSelectorFromString(self.property);
			if([self.object respondsToSelector:getter]) {
				anotherValue = [self.object performSelector:getter];
			}
		}
		if(_value != anotherValue) {
			[_value release];
			[anotherValue retain];
			_value = anotherValue;
		}
	}
	return _value;
}

-(NSString*)html {
	if(self.showLabel && self.name != nil) {
		return [NSString stringWithFormat:@"<label>%@</label><div>%@</div>", self.name, [EUIFormField getHtml:self.value forField:self]];
	} else {
		return [NSString stringWithFormat:@"<div>%@</div>", [EUIFormField getHtml:self.value forField:self]];
	}
}

#pragma mark Setter Overrides

-(void)setValue:(id)value{
	if(_value != value) {
		[value retain];
		[_value release];
		_value = value;
	}
	[self updateDataSourceValue: _value];
	[self updateFieldDisplay];
}

-(void)setOptions:(id)value{
	NSArray* list;
	if([value isKindOfClass:[NSDictionary class]]) {
		self.optionsValueProperty = @"key";
		self.optionsProperty = @"value";
		list = [[[NSMutableArray alloc] initWithCapacity:[[value allKeys] count]] autorelease];
		for(NSString* key in [value allKeys]) {
			[(NSMutableArray*)list addObject: [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", [value objectForKey:key], @"value", nil]];
		}
	} else if ([value isKindOfClass: [NSArray class]]) {
		list = value;
	} else {
		list = [[[NSArray alloc] initWithObjects:value, nil] autorelease];
	}
	
	[_options release];
	_options = [list retain];
	
	if([self.viewController isKindOfClass:[UITableViewController class]]) {
		[[(UITableViewController*)self.viewController tableView] reloadData];
	}
	[self selectFromList];
}

-(void)setOptionsProperty:(NSString*)value{
	[_optionsProperty release];
	[value retain];
	_optionsProperty = value;
	[self selectFromList];
	[self updateFieldDisplay];
}

-(void)setOptionsValueProperty:(NSString*)value{
	[_optionsValueProperty release];
	[value retain];
	_optionsValueProperty = value;
	[self selectFromList];
}

-(void)setType:(EUIFormFieldType)value{
	_type = value;
	if(self.control == nil) {
		
		// Creates a control to handle the type
		switch (value) {
			case EUIFormFieldTypeBoolean: {
				self.control = [[UISwitch alloc] init];
				break;
			}
			case EUIFormFieldTypeSlider: {
				self.control = [[UISlider alloc] init];
				break;
			}
			case EUIFormFieldTypeTextArea: {
				self.control = [[UITextView alloc] init];
				((UITextView*)self.control).font = self.controlFont;
				((UITextView*)self.control).textColor = self.controlColor;
				((UITextView*)self.control).textAlignment = self.controlAlignment;
				((UITextView*)self.control).contentInset = UIEdgeInsetsMake(-8,-8,0,0);
				break;
			}
			case EUIFormFieldTypeDate: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).numberOfLines = 0;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				self.viewController = [[EUIFormDatePicker alloc] init];
				((EUIFormDatePicker*)self.viewController).field = self;
				break;
			}
			case EUIFormFieldTypeTime: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				self.viewController = [[EUIFormDatePicker alloc] init];
				((EUIFormDatePicker*)self.viewController).field = self;
				break;
			}
			case EUIFormFieldTypeDateAndTime: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).numberOfLines = 0;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				self.viewController = [[EUIFormDatePicker alloc] init];
				((EUIFormDatePicker*)self.viewController).field = self;
				break;
			}
			case EUIFormFieldTypeLabel: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				((UILabel*)self.control).numberOfLines = 0;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				break;
			}
			case EUIFormFieldTypeList: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).numberOfLines = 0;
				self.viewController = [[EUIFormFieldList alloc] initWithField:self];
				break;
			}
			case EUIFormFieldTypeCheckList: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).numberOfLines = 0;
				self.viewController = [[EUIFormFieldList alloc] initWithField:self];
				break;
			}
			case EUIFormFieldTypeStrings: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).numberOfLines = 0;
				self.viewController = [[EUIFormStringsEditor alloc] initWithField:self];
				break;
			}
			case EUIFormFieldTypeCustom: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				break;
			}
			case EUIFormFieldTypeColor: {
				break;
			}
			case EUIFormFieldTypeTextEditor: {
				self.control = [[UILabel alloc] init];
				((UILabel*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				((UILabel*)self.control).lineBreakMode = UILineBreakModeWordWrap;
				((UILabel*)self.control).numberOfLines = 0;
				self.viewController = [[EUIFormTextEditor alloc] initWithField:self];
				break;
			}
			default: {
				self.control = [[UITextField alloc] init];
				((UITextField*)self.control).font = self.controlFont;
				((UILabel*)self.control).textColor = self.controlColor;
				((UILabel*)self.control).textAlignment = self.controlAlignment;
				break;
			}
		}
		
		// Set the editable status of the control
		if([self.control isKindOfClass:[UIControl class]]) {
			((UIControl*)self.control).enabled = self.editable;
		}
		
		// Update the default value of the UILabel
		if([self.control isKindOfClass:[UILabel class]]) {
			((UILabel*)self.control).text = self.noValueLabelText;
		}
		
		// Sets the keyboard type of the control
		if([self.control conformsToProtocol:@protocol(UITextInputTraits)]) {
			if(self.type != EUIFormFieldTypeTextArea) {
				[(id<UITextInputTraits>)self.control setReturnKeyType: UIReturnKeyDone];				
			}
			switch(value) {
				case EUIFormFieldTypePassword:
					[(id<UITextInputTraits>)self.control setSecureTextEntry: YES];
					break;
				case EUIFormFieldTypeEmail:
					[(id<UITextInputTraits>)self.control setKeyboardType: UIKeyboardTypeEmailAddress];
					[(id<UITextInputTraits>)self.control setAutocorrectionType: UITextAutocorrectionTypeNo];
					[(id<UITextInputTraits>)self.control setAutocapitalizationType: UITextAutocapitalizationTypeNone];
					break;
				case EUIFormFieldTypeInteger:
					[(id<UITextInputTraits>)self.control setKeyboardType: UIKeyboardTypeNumberPad];
					break;
				case EUIFormFieldTypeNumber:
					[(id<UITextInputTraits>)self.control setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
					break;
				case EUIFormFieldTypePhone:
					[(id<UITextInputTraits>)self.control setKeyboardType: UIKeyboardTypePhonePad];
					break;
				case EUIFormFieldTypeURL:
					[(id<UITextInputTraits>)self.control setKeyboardType: UIKeyboardTypeURL];
					break;
				default:
					break;
			}
		}
	}
}

-(void)setEditable:(BOOL)value{
	_editable = value;
	if(self.control != nil && [self.control isKindOfClass:[UIControl class]]) {
		((UIControl*)self.control).enabled = value;
	}
}

-(void)setProperty:(NSString*)value{
	[_property release];
	[value retain];
	_property = value;
	if(self.action == nil && value != nil && value.length > 0) { 
		self.action = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[_property substringToIndex:1] uppercaseString], [_property substringFromIndex:1]]);
	}
	_dataType = nil;
	[self updateFieldDisplay];
}

-(void)setObject:(id)value{
/*
	if([value isKindOfClass:[NSDictionary class]]) {
		value = [[EUIObject alloc] initWithDictionary:value];
	} else {
		[value retain];
	}
*/
	[value retain];
	[_object release];
	_object = value;
	_dataType = nil;
	[self updateFieldDisplay];
}

-(void)setDelegate:(id<EUIFormFieldDelegate>)delegate{
	[_delegate release];
	[delegate retain];
	_delegate = delegate;
	[self updateFieldDisplay];
}

-(void)setStringValue:(NSString*)stringValue{
	[_stringValue release];
	[stringValue retain];
	_stringValue = stringValue;
	[self updateFieldDisplay];
}

-(void)setControl:(UIView*)value{
	[_control release];
	[value retain];
	_control = value;
	
	// Handle each change for a text field
	if([self.control isKindOfClass:[UITextField class]]) {
		((UITextField*)self.control).delegate = self;
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(updateDataSourceValue) name:@"UITextFieldTextDidChangeNotification" object:self.control];
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(scrollIntoView:) name:@"UITextFieldTextDidBeginEditingNotification" object:self.control];
		
		// Handle each change for a text view
	} else if([self.control isKindOfClass:[UITextView class]]) {
		((UITextView*)self.control).delegate = self;
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(updateDataSourceValue) name:@"UITextViewTextDidChangeNotification" object:self.control];
		[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(scrollIntoView:) name:@"UITextViewTextDidBeginEditingNotification" object:self.control];
		
		// Handle each change for any other change
	} else if([_control isKindOfClass:[UIControl class]]) {
		[(UIControl*)_control addTarget:self action:@selector(updateDataSourceValue) forControlEvents:UIControlEventValueChanged];
	}
}

-(void)setNoValueText:(NSString *)value{
	[value retain];
	[_noValueLabelText release];
	_noValueLabelText = value;
	if([self.control isKindOfClass:[UILabel class]]) {
		((UILabel*)self.control).text = value;
	}
}

-(void)setForm:(EUIForm *)value{
	[_form release];
	[value retain];
	_form = value;
	self.editable = _form.editable;
}

-(void)setViewController:(UIViewController *)value {
	if(value != _viewController) {
		[value retain];
		[_viewController release];
		_viewController = value;
	}
	if (_delegate == nil && [_viewController conformsToProtocol:@protocol(EUIFormFieldDelegate)]) {
		self.delegate = (id)_viewController;
	}
}

-(void)setScale:(float)value {
	_scale = value;
	[self updateFieldDisplay];
}

-(void)setControlAlignment:(UITextAlignment)value {
	_controlAlignment = value;
	_controlAlignmentSet = YES;
}

-(UITextAlignment)controlAlignment {
	if(_controlAlignmentSet == NO) {
		if(self.form == nil) {
			[EUIForm defaultControlAlignment];
		} else {
			return self.form.controlAlignment;
		}
	}
	return _controlAlignment;
}

-(void)setShowsSliderStatus:(BOOL)value {
	_showsSliderStatus = value;
	if(value) {
		[(UISlider*)self.control addTarget:self action:@selector(updateSliderStatus:) forControlEvents:UIControlEventValueChanged];
		UILabel* suffixLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 35, 35)];
		suffixLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
		suffixLabel.textColor = self.labelColor;
		suffixLabel.opaque = YES;
		suffixLabel.backgroundColor = [UIColor clearColor];
		suffixLabel.adjustsFontSizeToFitWidth = YES;
		self.suffix = suffixLabel;
		[suffixLabel release];
		[self performSelector:@selector(updateSliderStatus:) withObject:self.control];
	} else {
		[(UISlider*)self.control removeTarget:self action:@selector(updateSliderStatus:) forControlEvents:UIControlEventValueChanged];
		self.suffix = nil;
	}
}

-(void)updateSliderStatus:(UISlider*)slider {
	NSNumber* value;
	if(self.scale > 0) {
		value = [NSNumber numberWithInt:(int)(slider.value*self.scale)];
	} else {
		value  = [NSNumber numberWithFloat:slider.value];
	}
	
	((UILabel*)self.suffix).text = [NSString stringWithFormat:@"%@", value];
}

#pragma mark Validation

-(BOOL)validateIntoArray:(NSMutableArray*)errors{
	int errorCount = errors.count;
	
	// Determine the plurality of the name.
	NSString* isAre = @"is";
	if([self.name hasSuffix:@"s"]) {
		if ([self.name hasSuffix:@"ss"] == NO && [self.name hasSuffix:@"'s"] == NO) {
			isAre = @"are";
		}
	}
	
	// Check for required values
	if(self.required) {
		if(self.value == nil) {
			[errors addObject:[NSString stringWithFormat:@"%@ %@ required", self.name, isAre]];
		} else {
			NSLog(@"Field named %@ has a value of: %@", self.name, self.value);

			if([self.value isKindOfClass:[NSString class]]) {
				if([(NSString*)self.value length] < 1) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ required", self.name, isAre]];
				}
			} else if([self.value isKindOfClass:[NSNumber class]]) {
				if([[(NSNumber*)self.value stringValue] length] < 1) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ required", self.name, isAre]];
				}
			} else if([self.value isKindOfClass:[NSArray class]]) {
				if([(NSArray*)self.value count] < 1) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ required", self.name, isAre]];
				}
			} else if([self.value isKindOfClass:[NSDictionary class]]) {
				if([[(NSDictionary*)self.value allKeys] count] < 1) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ required", self.name, isAre]];
				}
			}
		}
	}
	
	// Check for typed values
	if(errors.count == errorCount) {
		switch (self.type) {
			case EUIFormFieldTypeURL:{
				NSURL* url = [NSURL URLWithString:self.value];
				if(url == nil) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ not a valid URL", isAre, self.name]];
				}
				break;
			}
			case EUIFormFieldTypePhone:{
				if(self.value != nil && [self.value length] > 0) {
					NSString *phoneRegex = @"^(\\+\\d)*\\s*(\\(\\d{3}\\)\\s*)*\\d{3}(-{0,1}|\\s{0,1})\\d{2}(-{0,1}|\\s{0,1})\\d{2}$"; 
					NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
					if([phoneTest evaluateWithObject:self.value] == NO) {
						NSDictionary* phoneNumber = [EUIPhoneNumber phoneNumberToDictionary:self.value];
						if ([[phoneNumber objectForKey:@"areacode"] length] == 3 &&
							[[phoneNumber objectForKey:@"phone1"] length] == 3 &&
							[[phoneNumber objectForKey:@"phone2"] length] == 4)
						{
							// Works...
						} else {
							[errors addObject:[NSString stringWithFormat:@"%@ %@ not a valid phone number", self.name, isAre]];
						}
					}
				}
				break;
			}
			case EUIFormFieldTypeEmail:{
				NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
				NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
				if([emailTest evaluateWithObject:self.value] == NO) {
					[errors addObject:[NSString stringWithFormat:@"%@ %@ not a valid email address", self.name, isAre]];				
				}
				break;
			}
			default:
				break;
		}
	}
	
	return (errors.count > errorCount);
}

#pragma mark Overrides

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(void)scrollIntoView:(NSNotification*)notification{
	// Set the field as the selected one
	self.form.selectedField = self;
	
	// Scroll the cell into view
	UIView* cell = [[[notification object] superview] superview];
	if([cell isKindOfClass:[UITableViewCell class]]) {
		NSIndexPath* indexPath = [self.form.tableView indexPathForCell:(UITableViewCell*)cell];
		[self.form.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

#pragma mark Custom Actions

-(void)addTarget: (id) target action: (SEL) action {
	_target = [target retain];
	_selector = action;
}

#pragma mark Internal Methods

// Updates the display value of the control based on the current value
-(void)updateFieldDisplay{
	
	// If we have no control to update, bail out now
	if(self.control == nil) {
		_value = nil;
		return;
	}
	
	// Set the control to the static value
	if(self.object == nil || self.property == nil) {
		if(self.stringValue != nil) {
			if([self.control isKindOfClass:[UISlider class]]) {
				if(self.scale > 0) {
					((UISlider*)self.control).value = ([self.stringValue floatValue] / self.scale);
				} else {
					((UISlider*)self.control).value = [self.stringValue floatValue];
				}
			} else if([self.control isKindOfClass:[UISwitch class]]) {
				((UISwitch*)self.control).on = (self.value != nil && self.stringValue.length > 0 && [self.stringValue boolValue]);
			} else if([self.control respondsToSelector:@selector(setText:)]) {
				[self.control performSelector:@selector(setText:) withObject: self.stringValue];
			}
		}
		_value = self.stringValue;


	// Get the value from the object using the dictionary
	} else if([self.object isKindOfClass:[NSDictionary class]]) {
		_value = [(NSDictionary*)self.object objectForKey:self.property];
		
		// Set the value as a float if it's a slider
		if([self.control isKindOfClass:[UISlider class]]) {
			if(self.scale > 0) {
				((UISlider*)self.control).value = ([_value floatValue] / self.scale);
			} else {
				((UISlider*)self.control).value = [_value floatValue];
			}
			
			// Set the value as a boolean if it's a switch
		} else if([self.control isKindOfClass:[UISwitch class]]) {
			((UISwitch*)self.control).on = [_value boolValue];
			
			// Set the value as a string if it's a text view
		} else if([self.control isKindOfClass:[UITextView class]]) {
			((UITextView*)self.control).text = _value;
			
			// Set the value of a text field...
		} else if([self.control isKindOfClass:[UITextField class]]) {

			if(_value == nil) {
				((UITextField*)self.control).text = @"";
			} else {
				((UITextField*)self.control).text = [NSString stringWithFormat:@"%@", _value];
			}
			
			// Set the value of a label
		} else if([self.control isKindOfClass:[UILabel class]]) {
			if(self.type == EUIFormFieldTypeDate || self.type == EUIFormFieldTypeTime || self.type == EUIFormFieldTypeDateAndTime) {
				if(_value != nil) {
					((EUIFormDatePicker*)self.viewController).datePicker.date = _value;
					((UILabel*)self.control).text = [self.dateFormatter stringFromDate: _value];
				} else {
					((UILabel*)self.control).text = self.noValueLabelText;
				}
			} else if (self.type == EUIFormFieldTypeStrings) {
				id arrayValue = _value;
				if([arrayValue isKindOfClass:[NSSet class]]) {
					arrayValue = [arrayValue allObjects];
				}
				_value = arrayValue;
				if(arrayValue != nil) {
					if([self.viewController isKindOfClass:[EUIFormStringsEditor class]]) {
						((EUIFormStringsEditor*)self.viewController).array = arrayValue;
					}
					NSString* text = [arrayValue componentsJoinedByString:@", "];
					if(text.length == 0) { text = self.noValueLabelText; }
					((UILabel*)self.control).text = text;
				} else {
					((EUIFormStringsEditor*)self.viewController).array = nil;
					((UILabel*)self.control).text = self.noValueLabelText;
				}
			} else {
				((UILabel*)self.control).text = [EUIFormField getString:_value forField:self];
			}
			if(((UILabel*)self.control).text == nil || ((UILabel*)self.control).text.length == 0) {
				((UILabel*)self.control).text = self.noValueLabelText;
			}
		}

		
	} else {
		SEL getter = NSSelectorFromString(self.property);
		if([self.object respondsToSelector:getter]) {
			
			// Create the invocation
			NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: [self.object methodSignatureForSelector:getter]];
			[invocation setTarget:self.object];
			[invocation setSelector:getter];
			[invocation retainArguments];
			[invocation invoke];
			
			// Set the value as a float if it's a slider
			if([self.control isKindOfClass:[UISlider class]]) {
				NSNumber* number;
				if([self.dataType isEqualToString: @"i"]) {
					int intValue;
					[invocation getReturnValue:&intValue];
					number = [NSNumber numberWithInt:intValue];
				} else if([self.dataType isEqualToString: @"d"]) {
					double doubleValue;
					[invocation getReturnValue:&doubleValue];
					number = [NSNumber numberWithDouble:doubleValue];
				} else if([self.dataType isEqualToString: @"f"]) {
					float floatValue;
					[invocation getReturnValue:&floatValue];
					number = [NSNumber numberWithFloat:floatValue];
				} else if([self.dataType isEqualToString: @"l"]) {
					long longValue;
					[invocation getReturnValue:&longValue];
					number = [NSNumber numberWithLong:longValue];
				} else if([self.dataType isEqualToString: @"s"]) {
					short shortValue;
					[invocation getReturnValue:&shortValue];
					number = [NSNumber numberWithShort:shortValue];
				} else {
					number = [self.object performSelector:getter];
				}
				_value = number;
				float sliderValue = [number floatValue];
				if(self.scale > 0) {
					sliderValue = sliderValue / self.scale;
				}
				((UISlider*)self.control).value = sliderValue;
				
				// Set the value as a boolean if it's a switch
			} else if([self.control isKindOfClass:[UISwitch class]]) {
				id boolValue = [self.object performSelector:getter];
				if([boolValue isKindOfClass:[NSString class]]) {
					BOOL on = NO;
					if([boolValue length] > 0) { on = [boolValue boolValue]; }
					_value = [NSNumber numberWithBool:on];
				} else if([boolValue isKindOfClass:[NSNumber class]] == NO) {
					_value = [NSNumber numberWithBool:(BOOL)boolValue];
				} else {
					_value = boolValue;
				}
				BOOL on = [_value boolValue];
				((UISwitch*)self.control).on = on;
				
				// Set the value as a string if it's a text view
			} else if([self.control isKindOfClass:[UITextView class]]) {
				NSString* stringValue = [self.object performSelector:getter];;
				_value = stringValue;
				((UITextView*)self.control).text = stringValue;
				
				// Set the value of a text field...
			} else if([self.control isKindOfClass:[UITextField class]]) {
				
				// As a number...
				if(self.type == EUIFormFieldTypeNumber || self.type == EUIFormFieldTypeInteger) {
					NSNumber* number;
					if([self.dataType isEqualToString: @"i"]) {
						int intValue;
						[invocation getReturnValue:&intValue];
						number = [NSNumber numberWithInt:intValue];
					} else if([self.dataType isEqualToString: @"d"]) {
						double doubleValue;
						[invocation getReturnValue:&doubleValue];
						number = [NSNumber numberWithDouble:doubleValue];
					} else if([self.dataType isEqualToString: @"f"]) {
						float floatValue;
						[invocation getReturnValue:&floatValue];
						number = [NSNumber numberWithFloat:floatValue];
					} else if([self.dataType isEqualToString: @"l"]) {
						long longValue;
						[invocation getReturnValue:&longValue];
						number = [NSNumber numberWithLong:longValue];
					} else if([self.dataType isEqualToString: @"s"]) {
						short shortValue;
						[invocation getReturnValue:&shortValue];
						number = [NSNumber numberWithShort:shortValue];
					} else {
						number = [self.object performSelector:getter];
					}
					_value = number;
					if(self.type == EUIFormFieldTypeInteger && number != nil) {
						_value = [NSNumber numberWithInt:[number intValue]];
					}
					if(_value == nil) {
						((UITextField*)self.control).text = @"";
					} else {
						((UITextField*)self.control).text = [NSString stringWithFormat:@"%@", _value];
					}
					
					// As a string...
				} else {
					id value = [self.object performSelector:getter];
					_value = value;
					if(value == nil) {
						((UITextField*)self.control).text = @"";
					} else {
						((UITextField*)self.control).text = [NSString stringWithFormat:@"%@", value];
					}
				}
				
				// Set the value of a label
			} else if([self.control isKindOfClass:[UILabel class]]) {
				if(self.type == EUIFormFieldTypeDate || self.type == EUIFormFieldTypeTime || self.type == EUIFormFieldTypeDateAndTime) {
					NSDate* dateValue = [self.object performSelector:getter];
					_value = dateValue;
					if(dateValue != nil) {
						((EUIFormDatePicker*)self.viewController).datePicker.date = dateValue;
						((UILabel*)self.control).text = [self.dateFormatter stringFromDate: dateValue];
					} else {
						((UILabel*)self.control).text = self.noValueLabelText;
					}
				} else if (self.type == EUIFormFieldTypeStrings) {
					id arrayValue = [self.object performSelector:getter];
					if([arrayValue isKindOfClass:[NSSet class]]) {
						arrayValue = [arrayValue allObjects];
					}
					_value = arrayValue;
					if ([arrayValue isKindOfClass:[NSString class]]) {
						arrayValue = [arrayValue componentsSeparatedByString:@"\n"];
					}
					if(arrayValue != nil) {
						if([self.viewController isKindOfClass:[EUIFormStringsEditor class]]) {
							((EUIFormStringsEditor*)self.viewController).array = arrayValue;
						}
						NSString* text = [arrayValue componentsJoinedByString:@", "];
						if(text.length == 0) { text = self.noValueLabelText; }
						((UILabel*)self.control).text = text;
					} else {
						((EUIFormStringsEditor*)self.viewController).array = nil;
						((UILabel*)self.control).text = self.noValueLabelText;
					}
				} else {
					id value = [self.object performSelector:getter];
					_value = value;
					NSString* text = [EUIFormField getString:value forField:self];
					if(text != nil) {
						((UILabel*)self.control).text = text;
					}
				}
				if(((UILabel*)self.control).text == nil || ((UILabel*)self.control).text.length == 0) {
					((UILabel*)self.control).text = self.noValueLabelText;
				}
			}
		}
	}
}

+(NSString*)getHtml:(id)value forField:(EUIFormField*)field {
	// If we have a html field, then use it
	if(field.delegate != nil && [field.delegate conformsToProtocol:(@protocol(EUIFormFieldDelegate))]) {
		if([field.delegate respondsToSelector:@selector(htmlForField:)]) {
			NSString* text = [field.delegate performSelector:@selector(htmlForField:) withObject: field];
			if(text == nil || text.length == 0) {
				text = field.noValueLabelText;
			}
			return text;
		}
	}
	
	if(field.viewController == nil && [field.viewController isKindOfClass:[EUIForm class]]) {
		return [(EUIForm*)field.viewController html];
	}
	
	if([field.control isKindOfClass:[UISlider class]]) {
		return [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:((UISlider*)field.control).value]];
	}
	
	if([field.control isKindOfClass:[UISwitch class]]) {
		return ((UISwitch*)field.control).on ? @"Yes" : @"No";
	}
	
	if([field.control respondsToSelector:@selector(text)]) {
		return [field.control performSelector:@selector(text)];
	}
	
	if([field.control respondsToSelector:@selector(value)]) {
		return [NSString stringWithFormat:@"%@", [field.control performSelector:@selector(value)]];
	}
	
	return [self getString:value forField:field];
}

+(NSString*)getString:(id)value forField:(EUIFormField*)field {
	// If we have a string field, then use it
	if(field.delegate != nil && [field.delegate conformsToProtocol:(@protocol(EUIFormFieldDelegate))]) {
		if([field.delegate respondsToSelector:@selector(stringForField:)]) {
			NSString* text = [field.delegate performSelector:@selector(stringForField:) withObject: field];
			if(text == nil || text.length == 0) {
				text = field.noValueLabelText;
			}
			return text;
		}
	}
	
	// If we don't have a value, then just bail
	NSMutableString* o = [[NSMutableString alloc] init];
	if(value == nil) {
		[o appendString:field.noValueLabelText];
		return [o autorelease];
	}
	
	// If we have an array, then format
	if(field.optionsProperty != nil) {
		SEL getter = NSSelectorFromString(field.optionsProperty);
		if([value isKindOfClass:[NSArray class]]) {
			for(id item in value){
				if([o isEqualToString:@""] == NO) {
					[o appendString:@", "];
				}
				
				if([item isKindOfClass:[NSDictionary class]]) {
					[o appendFormat:@"%@", [item objectForKey:field.optionsProperty]];
				} else if([item respondsToSelector:getter]) {
					[o appendFormat:@"%@", [item performSelector: getter]];
				} else {
					[o appendFormat:@"%@", item];
				}
			}
			
			// Otherwise just use the getter
		} else {
			// Pick the name from the list
			if([value isKindOfClass:[NSDictionary class]]) {
				[o appendFormat:@"%@", [value objectForKey:field.optionsProperty]];
			} else if([value respondsToSelector:getter]) {
				[o appendFormat:@"%@", [value performSelector: getter]];
			} else {
				[o appendFormat:@"%@", value];
			}
		}
	} else {
		if([value isKindOfClass:[NSArray class]]) {
			for(id item in value){
				if([o isEqualToString:@""] == NO) {
					[o appendString:@", "];
				}
				[o appendFormat:@"%@", [item description]];
			}
		} else {
			if(value != nil) {
				NSString* description = [NSString stringWithFormat:@"%@", value];
				if(description != nil) {
					[o appendString:description];
				}
			}
		}
	}
	if(o.length == 0) {
		[o appendString:field.noValueLabelText]; 
	}
	return [o autorelease];
}

-(void)selectFromList{
	if(self.optionsValueProperty != nil && self.options != nil && [self.options isKindOfClass:[NSArray class]]) {
		SEL getter;
		if(self.optionsProperty == nil) {
			getter = @selector(description);
		} else {
			getter = NSSelectorFromString(self.optionsProperty);
		}
		NSMutableString* o = [[NSMutableString alloc] init];
		
		for (id item in self.options) {
			if([item isKindOfClass:[NSDictionary class]]) {
				item = [[[EUIObject alloc] initWithDictionary:item] autorelease];
			}
			SEL valueGetter = NSSelectorFromString(self.optionsValueProperty);
			if ([item respondsToSelector:valueGetter]) {
				NSArray* values;
				if([self.value isKindOfClass:[NSArray class]]) {
					values = self.value;
				} else if (self.value == nil) {
					values = [NSArray array];
				} else {
					values = [NSArray arrayWithObject:self.value];
				}
				
				for(id value in values) {
					if ([[[item performSelector:valueGetter] description] isEqualToString:[value description]]) {
						if (o.length > 0) {
							[o appendString:@", "];
						}
						if([item respondsToSelector:getter]) {
							[o appendFormat:@"%@", [item performSelector:getter]];
						} else {
							[o appendFormat:@"%@", item];
						}
					}
				}
			}
		}
		if(o.length == 0) { [o appendString: self.noValueLabelText]; }
		((UILabel*)self.control).text = o;
		[o release];
	}
}

// Method for determining if an object exists within a list
-(BOOL)isItem:(id)item inList:(NSArray*)list{
	return ([self findIndexOf:item inList:list] >= 0);
}

// Finds the index of the object in the list
-(int)findIndexOf:(id)item inList:(NSArray*)list{
	if(list == nil) { list = [NSArray array]; }
	if([list isKindOfClass:[NSArray class]] == NO) {
		list = [NSArray arrayWithObject:list];
	}
	for(int i=0;i<list.count;i++) {
		id selectedItem = [list objectAtIndex:i];
		if([selectedItem isEqual:item]) {
			return i;
			break;
		}
		if(self.optionsValueProperty != nil) {
			if([item isKindOfClass:[NSDictionary class]]) {
				if([selectedItem isKindOfClass:[NSString class]]) { 
					if([[item objectForKey:self.optionsValueProperty] isEqualToString:selectedItem]) {
						return i;
						break;
					}
				} else {
					if([[item objectForKey:self.optionsValueProperty] isEqual:selectedItem]) {
						return i;
						break;
					}
				}
				
			} else {
				if([selectedItem isKindOfClass:[NSString class]]) { 
					if ([[item performSelector:NSSelectorFromString(self.optionsValueProperty)] isEqualToString:selectedItem]) {
						return i;
						break;
					}
				} else {
					if ([[item performSelector:NSSelectorFromString(self.optionsValueProperty)] isEqual:selectedItem]) {
						return i;
						break;
					}
				}
			}
		}
	}
	return -1;
}

-(void)updateDataSourceValue:(id)value{
	if(self.object == nil) {
		self.object = [NSMutableDictionary dictionary];
	}
	if([self.object isKindOfClass:[NSMutableDictionary class]]) {
		[self performSelector:@selector(updateDictionaryValue:) withObject:value];
	} else {
		[self performSelector:@selector(updateObjectValue:) withObject:value];
	}
	// Set the form to being changed
	if(self.form != nil) {
		self.form.changed = YES;
	}
}

-(void)updateDataSourceValue{
	[self updateDataSourceValue:self.value];
}

-(void)updateObjectValue:(id)value{
	
	// Declare an invocation
	NSNumber* numberValue;
	NSInvocation* invocation = nil;
	NSMethodSignature* methodSignature = nil;
	
	// Set the invocation
	if(self.action != nil && [self.object respondsToSelector:self.action]) {
		methodSignature = [self.object methodSignatureForSelector:self.action];
		invocation = [NSInvocation invocationWithMethodSignature: methodSignature];
		[invocation setTarget:self.object];
		[invocation setSelector:self.action];
	}
	
	// If we don't alreeady have an invocation, then make one
	if(invocation == nil) {
		invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@"]];
		[invocation setTarget:self.object];
		[invocation setSelector:self.action];
	}
	
	// Determine if we are expecting an ID type
	NSString* t = @"@";
	if(methodSignature != nil) {
		t = [NSString stringWithCString:[methodSignature getArgumentTypeAtIndex:2] encoding:NSASCIIStringEncoding];
	}
	BOOL isID = [t isEqualToString:@"@"];
	
	// Handle the slider values as a float
	if([self.control isKindOfClass:[UISlider class]]) {
		float floatValue = ((UISlider*)self.control).value;
		if(self.scale > 0) {
			floatValue = (floatValue * self.scale);
		}
		if(isID){
			if(self.scale > 0) {
				numberValue = [NSNumber numberWithInt:(int)floatValue];
			} else {
				numberValue = [NSNumber numberWithFloat:floatValue];
			}
			[invocation setArgument: &numberValue atIndex:2];
		} else {
			[invocation setArgument: &floatValue atIndex:2];
		}
		
		// Handle the switch values as a boolean
	} else if([self.control isKindOfClass:[UISwitch class]]) {
		BOOL boolValue = ((UISwitch*)self.control).on;
		if(isID) {
			numberValue = [NSNumber numberWithBool:boolValue];
			[invocation setArgument: &numberValue atIndex:2];
		} else {
			[invocation setArgument: &boolValue atIndex:2];
		}
		
		// Handle the text view as a string.
	} else if([self.control isKindOfClass:[UITextView class]]) {
		NSString* stringValue = [(UITextView*)self.control text];
		if(self.maxLength > -1 && stringValue.length > self.maxLength) {
			((UITextView*)self.control).text = [stringValue substringToIndex:self.maxLength-1];
			return;
		}
		[invocation setArgument:&stringValue atIndex:2];
		
		// Handle the text field
	} else if([self.control isKindOfClass:[UITextField class]]) {
		NSString* stringValue = [(UITextView*)self.control text];
		
		// As a number...
		if(self.type == EUIFormFieldTypeNumber) {
			
			// Handle the max value
			int intValue = [stringValue intValue];
			if(self.maxLength > 0 && intValue > self.maxLength) {
				((UITextView*)self.control).text = [NSString stringWithFormat:@"%i", self.maxLength];
				return;
			}
			
			if([self.dataType isEqualToString: @"i"]) {
				int intValue = [stringValue intValue];
				[invocation setArgument: &intValue atIndex:2];
				
			} else if([self.dataType isEqualToString: @"d"]) {
				double doubleValue = [stringValue doubleValue];
				[invocation setArgument: &doubleValue atIndex:2];
				
			} else if([self.dataType isEqualToString: @"f"]) {
				float floatValue = [stringValue floatValue];
				[invocation setArgument: &floatValue atIndex:2];
				
			} else if([self.dataType isEqualToString: @"l"]) {
				long longValue = [stringValue longLongValue];
				[invocation setArgument: &longValue atIndex:2];
				
			} else if([self.dataType isEqualToString: @"s"]) {
				short shortValue = (short)[stringValue intValue];
				[invocation setArgument: &shortValue atIndex:2];
				
			} else {
				NSNumber* numberValue = [self.numberFormatter numberFromString:stringValue];
				[invocation setArgument: &numberValue atIndex:2];
			}
			
			
		// As an integer
		} else if(self.type == EUIFormFieldTypeInteger) {
			int intValue = [stringValue intValue];
			if(self.maxLength > 0 && intValue > self.maxLength) {
				intValue = self.maxLength;
				((UITextView*)self.control).text = [NSString stringWithFormat:@"%i", self.maxLength];
			}
			if(isID) {
				numberValue = [NSNumber numberWithInt:intValue];
				[invocation setArgument: &numberValue atIndex:2];
			} else {
				[invocation setArgument: &intValue atIndex:2];
			}
			
		// Or as a string...
		} else {
			if(self.maxLength > -1 && stringValue.length > self.maxLength) {
				((UITextView*)self.control).text = [stringValue substringToIndex:self.maxLength-1];
				return;
			}
			[invocation setArgument: &stringValue atIndex:2];
		}
		
		// Handle a label
	} else if([self.control isKindOfClass:[UILabel class]]) {
		NSString* stringValue = [(UILabel*)self.control text];
		
		if(self.type == EUIFormFieldTypeDate || self.type == EUIFormFieldTypeTime || self.type == EUIFormFieldTypeDateAndTime) {
			NSDate* dateValue = [self.dateFormatter dateFromString:stringValue];
			[invocation setArgument: &dateValue atIndex:2];
		} else if(self.type == EUIFormFieldTypeStrings) {
			id arrayValue = [NSMutableArray arrayWithArray: [stringValue componentsSeparatedByString:@", "]];
			if([self.value isKindOfClass:[NSSet class]]) {
				arrayValue = [NSSet setWithArray:arrayValue];
			}
			[invocation setArgument: &arrayValue atIndex:2];
		} else {
			[invocation setArgument:&value atIndex:2];
		}
		
	}
	
	// Invoke the setter or other method
	[invocation invoke];
	if(self.delegate != nil && [self.delegate respondsToSelector:@selector(fieldHasChanged:)]) {
		[self.delegate performSelector:@selector(fieldHasChanged:) withObject: self];
	}
}

-(void)updateDictionaryValue:(id)value{
	NSMutableDictionary* d = self.object;
	
	// Handle the slider values as a float
	if([self.control isKindOfClass:[UISlider class]]) {
		NSNumber* value;
		if(self.scale > 0) {
			value = [NSNumber numberWithInt: (int)(((UISlider*)self.control).value * self.scale)];
		} else {
			value = [NSNumber numberWithFloat: ((UISlider*)self.control).value];
		}
		[d setValue:value forKey:self.property];
		
		// Handle the switch values as a boolean
	} else if([self.control isKindOfClass:[UISwitch class]]) {
		[d setValue:[NSNumber numberWithBool:((UISwitch*)self.control).on] forKey:self.property];
		
		// Handle the text view as a string.
	} else if([self.control isKindOfClass:[UITextView class]]) {
		NSString* stringValue = [(UITextView*)self.control text];
		if(self.maxLength > -1 && stringValue.length > self.maxLength) {
			((UITextView*)self.control).text = [stringValue substringToIndex:self.maxLength-1];
			return;
		}
		[d setValue:stringValue forKey:self.property];
	
	// Handle the text field
	} else if([self.control isKindOfClass:[UITextField class]]) {
		NSString* stringValue = [(UITextView*)self.control text];
		
		// As a number...
		if(self.type == EUIFormFieldTypeNumber) {
			
			// Handle the max value
			int intValue = [stringValue intValue];
			if(self.maxLength > 0 && intValue > self.maxLength) {
				((UITextView*)self.control).text = [NSString stringWithFormat:@"%i", self.maxLength];
				return;
			}

			NSNumber* numberValue = [self.numberFormatter numberFromString:stringValue];
			[d setValue:numberValue forKey:self.property];
			
		// As an integer
		} else if(self.type == EUIFormFieldTypeInteger) {
			int intValue = [stringValue intValue];
			if(self.maxLength > 0 && intValue > self.maxLength) {
				intValue = self.maxLength;
				((UITextView*)self.control).text = [NSString stringWithFormat:@"%i", self.maxLength];
			}
			[d setValue:[NSNumber numberWithInt:intValue] forKey:self.property];
			
		// Or as a string...
		} else {
			if(self.maxLength > -1 && stringValue.length > self.maxLength) {
				((UITextView*)self.control).text = [stringValue substringToIndex:self.maxLength-1];
				return;
			}
			[d setValue:stringValue forKey:self.property];
		}
		
	// Handle a label
	} else if([self.control isKindOfClass:[UILabel class]]) {
		NSString* stringValue = [(UILabel*)self.control text];
		
		if(self.type == EUIFormFieldTypeDate || self.type == EUIFormFieldTypeTime || self.type == EUIFormFieldTypeDateAndTime) {
			NSDate* dateValue = [self.dateFormatter dateFromString:stringValue];
			[d setValue:dateValue forKey:self.property];
		} else if(self.type == EUIFormFieldTypeStrings) {
			id arrayValue = [NSMutableArray arrayWithArray: [stringValue componentsSeparatedByString:@", "]];
			if([self.value isKindOfClass:[NSSet class]]) {
				arrayValue = [NSSet setWithArray:arrayValue];
			}
			[d setValue:arrayValue forKey:self.property];
		} else {
			if(value == nil) {
				[d setValue:[NSNull null] forKey:self.property];
			} else {
				[d setValue:value forKey:self.property];
			}
		}
		
	}
	
	// Invoke the setter or other method
	if(self.delegate != nil && [self.delegate respondsToSelector:@selector(fieldHasChanged:)]) {
		[self.delegate performSelector:@selector(fieldHasChanged:) withObject: self];
	}
}


#pragma mark Cell Drawing

-(void)drawCell:(UITableViewCell*)cell {
	
	// Determine the label
	NSString* name = nil;
	if(self.showLabel) {
		name = self.name;
	}
	
	// Setup short variables
	float lw = (name == nil) ? 0 : self.labelWidth;
	float p = self.padding;
	float x = lw + (p * 2);
	float c = cell.frame.size.width - 20;
	float w = (c - (p * 3) - lw);
	
	// Create the label
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p, p, lw, self.height-p)];
	label.text = name;
	label.font = self.labelFont;
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 0;
	label.textColor = self.labelColor;
	label.textAlignment = self.labelAlignment;
	label.adjustsFontSizeToFitWidth = YES;
    
    // Type-specific adjustments
	switch (self.type) {
		case EUIFormFieldTypeBoolean:
			self.control.frame = CGRectMake((x+w)-self.control.frame.size.width, p, self.control.frame.size.width, self.control.frame.size.height);
			label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, c-self.control.frame.size.width - (p*3), label.frame.size.height);
			break;
		case EUIFormFieldTypeSlider:
			self.control.frame = CGRectMake(x, p, w, self.height - p);
			break;
		default:
			self.control.frame = CGRectMake(x, p, w, self.height - p);
			break;
	}
	
	// Adjust the size of the label to fit text
	CGSize size = [label.text sizeWithFont: label.font constrainedToSize: label.frame.size lineBreakMode: label.lineBreakMode];
	if(size.height < label.font.pointSize) { size.height = label.font.pointSize * 1.33; }
	label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, size.height);
	
	// Set the selection type to None
	cell.selectedBackgroundView = nil;
	
	if(self.editable == YES && 
	   (self.viewController != nil ||
		self.type == EUIFormFieldTypeDate || 
		self.type == EUIFormFieldTypeTime ||
		self.type == EUIFormFieldTypeDateAndTime || 
		self.type == EUIFormFieldTypeList || 
		self.type == EUIFormFieldTypeCheckList || 
		self.type == EUIFormFieldTypeCustom ||
		(self.target != nil && self.selector != nil && [self.target respondsToSelector:self.selector])
		))
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		if(self.highlightColor != nil) {
			//			float* rgb = CGColorGetComponents(self.highlightColor.CGColor);
			//			float lum = ((0.2126*rgb[0]) + (0.7152*rgb[1]) + (0.0722*rgb[2]));
			
			CGSize size = CGSizeMake(cell.contentView.frame.size.width + cell.accessoryView.frame.size.width, cell.contentView.frame.size.height + cell.accessoryView.frame.size.height);
			UIView* background = [[UIView alloc] initWithFrame:cell.frame];
			background.backgroundColor = self.highlightColor;
			background.frame = CGRectMake(0, 0, size.width, size.height);
			UIImageView* backgroundImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"FormHighlight.png"]];
			backgroundImage.frame = CGRectMake(1, 1, 300, 43);
			[background addSubview:backgroundImage];
			[backgroundImage release];
			cell.selectedBackgroundView = background;
		} else {
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
		
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// Adjust the size of the content if it's a label
	if([self.control isKindOfClass:[UILabel class]]) {
		UILabel* controlLabel = (UILabel*)self.control;
		if(self.viewController != nil) {
			controlLabel.frame = CGRectMake(controlLabel.frame.origin.x, controlLabel.frame.origin.y, controlLabel.frame.size.width-32, controlLabel.frame.size.height);
		}
		controlLabel.font = self.controlFont;
		controlLabel.textColor = self.controlColor;
		controlLabel.textAlignment = self.controlAlignment;
		controlLabel.lineBreakMode = UILineBreakModeWordWrap;
		controlLabel.numberOfLines = 0;
		size = [controlLabel.text sizeWithFont:controlLabel.font constrainedToSize:controlLabel.frame.size lineBreakMode:controlLabel.lineBreakMode];
		if(size.height < controlLabel.font.pointSize) { size.height = controlLabel.font.pointSize * 1.33; }
		controlLabel.frame = CGRectMake(controlLabel.frame.origin.x, controlLabel.frame.origin.y, controlLabel.frame.size.width, size.height);
	}
	
	// Add the label and control
	for(UIView* view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}
	
	// Set the icon if available
	if(self.icon != nil) {
		cell.imageView.image = self.icon;
		label.frame = CGRectMake(label.frame.origin.x + self.icon.size.width + self.padding, label.frame.origin.y, label.frame.size.width - self.icon.size.width - self.padding, label.frame.size.height);
	} else {
		cell.imageView.image = nil;
	}
	
	// Add the suffix if set
	if(self.suffix != nil) {
		self.suffix.frame = CGRectMake((self.control.frame.origin.x + self.control.frame.size.width) - self.suffix.frame.size.width + self.suffix.frame.origin.x, self.suffix.frame.origin.y, self.suffix.frame.size.width, self.suffix.frame.size.height);
		self.control.frame = CGRectMake(self.control.frame.origin.x, self.control.frame.origin.y, self.control.frame.size.width - self.suffix.frame.size.width - p, self.control.frame.size.height);
		[cell.contentView addSubview:self.suffix];
	}
	
	// Add the views to the content area
	[cell.contentView addSubview:label];
	[label release];
	[cell.contentView addSubview: self.control];
	
}

-(void)dealloc{
	[_control release];
	[_name release];
	[_object release];
	[_property release];
	[_form release];
	[_options release];
	[_optionsProperty release];
	[_optionsValueProperty release];
	[_optionsChildrenProperty release];
	[_optionsSectionProperty release];
	[_dataType release];
	[_noValueLabelText release];
	[_delegate release];
	[_stringValue release];
	[_icon release];
	[_dateFormatter release];
	[_numberFormatter release];
	[_viewController release];
	[_labelColor release];
	[_highlightColor release];
	[_controlFont release];
	[_controlColor release];
	[_labelFont release];
	[_target release];
	[super dealloc];
}

@end