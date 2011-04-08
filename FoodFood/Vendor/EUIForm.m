//
//  EUIForm.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIForm.h"

@implementation EUIForm

@synthesize fields = _fields;
@synthesize groups = _groups;
@synthesize labelWidth = _labelWidth;
@synthesize padding = _padding;
@synthesize labelColor = _labelColor;
@synthesize parent = _parent;
@synthesize labelFont = _labelFont;
@synthesize selectedField = _selectedField;
@synthesize noValueLabelText = _noValueLabelText;
@synthesize editable = _editable;
@synthesize labelAlignment = _labelAlignment;
@synthesize mode = _mode;
@synthesize rewireViewMethods = _rewireViewMethods;
@synthesize controlFont = _controlFont;
@synthesize controlColor = _controlColor;
@synthesize controlAlignment = _controlAlignment;
@synthesize changed = _changed;

#pragma mark Initialization

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.padding = [EUIForm defaultPadding];
		self.labelWidth = [EUIForm defaultLabelWidth];
		self.labelAlignment = [EUIForm defaultLabelAlignment];
		self.controlAlignment = [EUIForm defaultControlAlignment];
		self.groups = [[NSMutableArray alloc] init];
		self.fields = [[NSMutableArray alloc] init];
		self.editable = YES;
		footerHeight = 226;
		_lookup = [[NSMutableDictionary alloc] init];
		_noValueLabelText = [[EUIForm defaultNoValueLabelText] retain];
		_mode = @"";
		_changed = NO;
    }
    return self;
}

#pragma mark Keyboard Methods

- (void)keyboardToggle:(NSNotification *)notification { 
	CGRect keyboardFrame = [[notification.userInfo objectForKey: @"UIKeyboardBoundsUserInfoKey"] CGRectValue];
	
	if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
		footerHeight = keyboardFrame.size.height;
		[self.tableView setNeedsDisplay];
	}
	if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
		footerHeight = 0;
		[self.tableView setNeedsDisplay];
	}
}

#pragma mark Custom Getters

-(UIColor*)labelColor{
	if(_labelColor == nil) {
		return self.tintColor;
	}
	return _labelColor;
}

-(UIFont*)labelFont{
	if(_labelFont == nil) { return [EUIForm defaultLabelFont]; }
	return _labelFont;
}

-(UIColor*)controlColor{
	if(_controlColor == nil) {
		return [EUIForm defaultControlColor];
	}
	return _controlColor;
}

-(UIFont*)controlFont{
	if(_controlFont == nil) { return [EUIForm defaultControlFont]; }
	return _controlFont;
}

#pragma mark Custom Getters

-(NSString*)html {
	NSMutableString* o = [NSMutableString string];
	for(EUIFormGroup* group in self.groups) {
		[o appendString:group.html];
	}
	return o;
}

#pragma mark Custom Setters

-(void)setMode:(NSString *) value{
	[self setMode:value withAnimation:UITableViewRowAnimationFade];
}

-(void)setMode:(NSString *) value withAnimation:(UITableViewRowAnimation)animation {
	if(value != _mode) {
		[value retain];
		[_mode release];
		_mode = value;
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.groups.count)] withRowAnimation:animation];
	}
}

-(void)setEditable:(BOOL)value{
	_editable = value;
	for (EUIFormField* field in self.fields) {
		field.editable = _editable;
	}
	[self.tableView reloadData];
	[self.view setNeedsDisplay];
}

#pragma mark Adding Items

-(EUIFormGroup*)addGroup:(NSString*) groupName{
	return [self addGroup:groupName withDescription: nil];
}

-(EUIFormGroup*)addGroup:(NSString*) groupName withDescription:(NSString*)description{
	EUIFormGroup* group = [EUIFormGroup groupWithName:groupName andDescription:description];
	group.form = self;
	[self.groups addObject:group];
	if(group.description != nil) {
		[self addLabel:group.description withName:nil];
	}
	return group;
}

-(UIButton*)addButton: (NSString*) name target: (id) target action: (SEL) action {
	return [self addButton:name target:target action:action intoFormMode:@""];
}

-(UIButton*)addButton: (NSString*) name target: (id) target action: (SEL) action intoFormMode:(NSString*)mode {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame: CGRectMake(0, 0, self.view.frame.size.width - 20, [EUIForm defaultFieldHeight] + (self.padding * 2))];
	[button setTitle: name forState: UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[button setBackgroundColor:self.tintColor];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	return [self addItem:button withName:name intoFormMode:mode];
}

-(id)addItem:(id)item withName:(NSString*)name intoFormMode:(NSString*)mode {
	[self.fields addObject:item];
	if(name != nil) {
		[_lookup setObject:item forKey:name];
	}
	if(self.groups.count < 1) { [self addGroup:nil]; }
	NSMutableDictionary* f = [[self.groups objectAtIndex:self.groups.count-1] fields];
	if([f objectForKey:mode] == nil) {
		[f setObject:[NSMutableArray array] forKey:mode];
	}
	[[f objectForKey:mode] addObject:item];
	return item;
}

-(EUIFormField*)addFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property {
	return [self addFieldOfType:fieldType withName:name fromObject:object valueOfProperty:property intoFormMode:@""];
}
  
-(EUIFormField*)addFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*)mode {
	EUIFormField* field = [[EUIFormField alloc] initWithType:fieldType name:name object:object property:property];
	field.form = self;
	return [self addItem:field withName:name intoFormMode:mode];
}
  
-(EUIFormField*)addRequiredFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property {
	return [self addRequiredFieldOfType:fieldType withName:name fromObject:object valueOfProperty:property intoFormMode:@""];
}

-(EUIFormField*)addRequiredFieldOfType:(EUIFormFieldType)fieldType withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*)mode {
	EUIFormField* field = [self addFieldOfType:fieldType withName:name fromObject:object valueOfProperty:property intoFormMode:mode];
	field.required = YES;
	return field;
}

-(EUIFormField*)addCustomField:(UIControl*)control withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property {
	return [self addCustomField:control withName:name fromObject:object valueOfProperty:property intoFormMode:@""];
}
  
-(EUIFormField*)addCustomField:(UIControl*)control withName: (NSString*) name fromObject: (id) object valueOfProperty: (NSString*) property intoFormMode:(NSString*)mode {
	EUIFormField* field = [[EUIFormField alloc] initWithCustom:control name:name object:object property:property];
	field.form = self;
	return [self addItem:field withName:name intoFormMode:mode];
}

-(EUIFormField*)addLabel:(NSString*) value withName: (NSString*) name {
	return [self addLabel:value withName:name intoFormMode:@""];
}

-(EUIFormField*)addLabel:(NSString*) value withName: (NSString*) name intoFormMode:(NSString*)mode {
	EUIFormField* field = [[EUIFormField alloc] initWithValue:value name:name];
	field.form = self;
	return [self addItem:field withName:name intoFormMode:mode];
}

-(void)clear{
	[self.groups removeAllObjects];
	[self.fields removeAllObjects];
	[_lookup removeAllObjects];
}

#pragma mark -
#pragma mark View Controller Management

-(void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

#pragma mark Retrieving Fields

-(EUIFormField*)getField:(NSString*)name{
	return [_lookup objectForKey:name];
}

#pragma mark Default Values

+(UITextAlignment)defaultLabelAlignment{
	return UITextAlignmentLeft;
}
	
+(UIColor*)defaultLabelColor{
	return [UIColor colorWithRed:(float)56/255 green:(float)84/255 blue:(float)135/255 alpha:1];
}

+(UIFont*)defaultLabelFont{
	return [UIFont boldSystemFontOfSize:14];
}

+(UITextAlignment)defaultControlAlignment{
	return UITextAlignmentLeft;
}

+(UIFont*)defaultControlFont{
	return [UIFont systemFontOfSize:14];
}

+(UIColor*)defaultControlColor{
	return [UIColor blackColor];
}

+(float)defaultFieldHeight{
	return 34;
}

+(float)defaultLabelWidth{
	return 80;
}

+(float)defaultPadding{
	return 10;
}

+(NSString*)defaultNoValueLabelText{
	return @"";
}

#pragma mark Validation

-(NSMutableArray*)validate{
	NSMutableArray* errors = [[NSMutableArray alloc] init];
	for (EUIFormField* field in self.fields) {
		[field validateIntoArray:errors];
	}
	return [errors autorelease];
}

#pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(self.groups == nil) { return 0; }
    return self.groups.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.fields == nil) { return 0; }
	return [[[[self.groups objectAtIndex:section] fields] objectForKey:self.mode] count];
}

// Get the title of the section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(self.groups == nil || self.groups.count == 0) { return nil; }
	return	[[self.groups objectAtIndex: section] name];
}

// Get the height of the table cell
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
	id item = [[[[self.groups objectAtIndex: indexPath.section] fields] objectForKey:self.mode] objectAtIndex: indexPath.row];
	if([item isKindOfClass:[EUIFormField class]]) {
		return ((EUIFormField*)item).height + 10;
	} else {
		return ((UIView*)item).frame.size.height;
	}
}

// Custom headers
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
	
	NSString* text = [self tableView:tableView titleForHeaderInSection:section];
	if(text == nil || text.length < 1) { return nil; }

	// Setup padding
	float topPadding = 8;
	float bottomPadding = 5;
	float sidePadding = 20;
	if(section == 0) {
		topPadding += 9;
	}
	
	// Create the label
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, topPadding, tableView.frame.size.width-(sidePadding*2), 100)];
	label.text = text;
	label.font = self.headerFont;
	label.textColor = self.headerColor;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.shadowColor = [UIColor whiteColor];
	label.lineBreakMode = UILineBreakModeWordWrap;
	label.numberOfLines = 0;
	
	// Adjust the size of the label to fit
	CGSize s = [label.text sizeWithFont: label.font constrainedToSize: label.frame.size lineBreakMode: label.lineBreakMode];
	label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, s.height);
	
	// Return the custom view
	UILabel* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, label.frame.size.height+topPadding+bottomPadding)];
	view.opaque = NO;
	view.backgroundColor = [UIColor clearColor];
	[view addSubview:label];
	[label release];
	
	return [view autorelease];;
}
	
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	UIView* view = [self tableView:tableView viewForHeaderInSection:section];
	if(view == nil) { return 0; }
	return view.frame.size.height;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section{
	if(self.editable && section == (self.groups.count - 1)) {
		return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, footerHeight)] autorelease];
	} else {
		return nil;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if(section == (self.groups.count - 1)) {
		return footerHeight;
	} else {
		return 0;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	// Get the form field
	id item = [[[[self.groups objectAtIndex:indexPath.section] fields] objectForKey:self.mode] objectAtIndex:indexPath.row];
	
	// Draw the form field
	if([item isKindOfClass:[EUIFormField class]]) {
		[(EUIFormField*)item drawCell:cell];
		
	// Draw it as a button
	} else if([item isKindOfClass:[UIButton class]]) {
		[cell.contentView addSubview:item];
	}

	// Return the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Remove the responder from the last field, if applicable
	if(self.selectedField != nil && [self.selectedField.control respondsToSelector:@selector(resignFirstResponder)]) {
		[self.selectedField.control resignFirstResponder];
	}
	
	// Get the form field
	EUIFormField* field = [[[[self.groups objectAtIndex:indexPath.section] fields] objectForKey:self.mode] objectAtIndex:indexPath.row];
	self.selectedField = field;
	
	// Open up a view controller if applicable
	if(field.viewController != nil && field.editable) {
		UINavigationController* nav = self.navigationController;
		if(_rewireViewMethods) {
			[field.viewController viewWillAppear:YES];
		}
		if(nav == nil) {
			[self.parent.navigationController pushViewController: field.viewController animated:YES];
		} else {
			[nav pushViewController:field.viewController animated:YES];
		}
		[self performSelector:@selector(deselect:) withObject:nil afterDelay:1];
	}
	
	// Fire the selected delgate
	if(field.delegate != nil && [field.delegate respondsToSelector:@selector(fieldSelected:)]) {
		[field.delegate performSelector:@selector(fieldSelected:) withObject:field];
	}
	
	// Handle the target/selector
	if(field.target != nil && field.selector != nil && [field.target respondsToSelector:field.selector]) {
		[field.target performSelector:field.selector withObject:field];
	}
}

-(void) deselect:(id)sender{ 
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES]; 
} 

#pragma mark -
#pragma mark Animation Helpers

// Reveal the view with an animation.
+(void)revealView:(UIView*)viewToReveal inViews:(NSArray*) views {
	[EUIForm revealView:viewToReveal inViews:views withAnimationDuration: 0.3];
}

+(void)revealView:(UIView*)viewToReveal inViews:(NSArray*) views withAnimationDuration:(float)duration {
	
	// Animate the hiding and revealing of the proper form.
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations: @"FadeFormScreens" context: context];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: duration];
	
	if(viewToReveal.hidden == YES) {
		viewToReveal.alpha = 0;
		viewToReveal.hidden = NO;
	}
	
	for (UIView* view in views) {
		if([view isEqual:viewToReveal] == NO) {
			view.alpha = 0;
		}
	}
	viewToReveal.alpha = 1;
	[UIView commitAnimations];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[_groups release];
	[_fields release];
	[_lookup release];
	[_labelColor release];
	[_parent release];
	[_labelFont release];
	[_selectedField release];
	[_noValueLabelText release];
    [super dealloc];
}


@end

