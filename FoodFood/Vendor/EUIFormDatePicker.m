//
//  EUIFormDatePicker.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/7/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormDatePicker.h"


@implementation EUIFormDatePicker

@synthesize datePicker, field;

- (id)init{
    if (self = [super init]) {
		// Set the background color
		self.view.backgroundColor = [UIColor colorWithRed:(float)37/255 green:(float)38/255 blue:(float)53/255 alpha:1];
		
		// Creates a date picker
		datePicker = [[UIDatePicker alloc] init];
		datePicker.minuteInterval = 15;
		[datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
		[self.view addSubview:datePicker];
		
		// Add the label to explain what to do
		label = [[UILabel alloc] initWithFrame:CGRectMake(25, datePicker.frame.size.height, datePicker.frame.size.width - 50, 125)];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.opaque = NO;
		label.shadowColor = [UIColor colorWithRed:(float)20/255 green:(float)21/255 blue:(float)29/255 alpha:1];
		label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.text = @"Select a date/time from the picker.\nTap \"Done\" to complete your changes.\nTap \"Back\" to keep your original value.";
		[self.view addSubview:label];
    }
    return self;
}

-(void)dateChanged{
	if(self.field != nil) {
		UILabel* lbl = (UILabel*)self.field.control;
		lbl.text = [self.field.dateFormatter stringFromDate:self.datePicker.date];
		if(lbl.text == nil || lbl.text.length == 0) {
			lbl.text = self.field.noValueLabelText;
		}
		[self.field updateDataSourceValue];
	}
}

-(void)setField:(EUIFormField*)value{
	[field autorelease];
	field = [value retain];
	switch (field.type) {
		case EUIFormFieldTypeDate:
			self.datePicker.datePickerMode = UIDatePickerModeDate;
			self.navigationItem.title = @"Change Date";
			break;
		case EUIFormFieldTypeTime:
			self.datePicker.datePickerMode = UIDatePickerModeTime;
			self.navigationItem.title = @"Change Time";
			break;
		case EUIFormFieldTypeDateAndTime:
			self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
			self.navigationItem.title = @"Change Date/Time";
			break;
		default:
			break;
	}
	NSString* s = ((UITextField*)self.field.control).text;
	if(s != nil && s.length > 0) {
		@try {
			self.datePicker.date = [self.field.dateFormatter dateFromString: s];
		} @catch (NSError*) {
			// Nada
		}
	}
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
}
	
-(void)done{
	[self dateChanged];
	[self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	datePicker = nil;
}


- (void)dealloc {
	[datePicker release];
	[field release];
	[label release];
    [super dealloc];
}


@end
