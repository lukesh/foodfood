    //
//  EUIFormTextEditor.m
//  MedKit
//
//  Created by Jason Kichline on 3/4/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import "EUIFormTextEditor.h"


@implementation EUIFormTextEditor

@synthesize field = _field;

-(id)initWithField:(EUIFormField*)field {
	if(self = [self init]) {
		self.field = field;
	}
	return self;
}

-(NSString*)stringForField:(EUIFormField *)field{
	if (field.value == nil || [field.value length] < 1) {
		return field.noValueLabelText;
	} else {
		return field.value;
	}
}

-(NSString*)htmlForField:(EUIFormField *)field{
	NSString* html = [self stringForField:field];
	return [html stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
}

-(void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = self.field.name;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	textView.font = [UIFont systemFontOfSize:16];
	textView.text = self.field.value;
	[textView becomeFirstResponder];
	[self.view addSubview:textView];
}

-(void)done{
	self.field.value = textView.text;
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	textView.text = self.field.value;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    textView = nil;
}


- (void)dealloc {
	[_field release];
	[textView release];
    [super dealloc];
}


@end
