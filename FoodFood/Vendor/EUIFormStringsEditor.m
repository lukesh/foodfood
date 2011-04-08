//
//  EUIFormStringsEditor.m
//  TourGuide
//
//  Created by Jason Kichline on 10/2/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormStringsEditor.h"
#import <objc/runtime.h>

@implementation EUIFormStringsEditor

@synthesize field = _field;
@synthesize array = _array;

- (id)initWithField: (EUIFormField*) field {
    if (self = [self init]) {
		self.field = field;
    }
    return self;
}

-(void)setField:(EUIFormField*)value{
	[_field autorelease];
	_field = [value retain];
}

-(void)setArray:(id)value{
	[_array release];
	if([value isKindOfClass:[NSSet class]]) {
		_array = [[NSMutableArray alloc] initWithArray:[value allObjects]];
	} else if ([value isKindOfClass:[NSString class]]) {
		if([value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
			_array = [[NSMutableArray alloc] init];
		} else {
			_array = [[NSMutableArray alloc] initWithArray:[value componentsSeparatedByString:@"\n"]];
		}
	} else {
		_array = [[NSMutableArray alloc] initWithArray:value];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Add a no results label
	noResults = [[UILabel alloc] initWithFrame:CGRectMake(0, 132, 320, 44)];
	noResults.backgroundColor = [UIColor clearColor];
	noResults.opaque = NO;
	noResults.text = [NSString stringWithFormat:@"No %@ Found", self.field.name];
	noResults.textColor = [UIColor lightGrayColor];
	noResults.font = [UIFont boldSystemFontOfSize:20];
	noResults.textAlignment = UITextAlignmentCenter;
	noResults.hidden = YES;
	[self.tableView addSubview:noResults];
	
	self.tableView.editing = YES;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	if(self.field != nil) {
		self.navigationItem.title = self.field.name;
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)] autorelease];
	}
}

-(void)add{
	EUIPrompt* prompt = [[EUIPrompt alloc] initWithTitle:@"Add a new value" message:nil delegate:self cancelButtonTitle:@"Cancel" confirmButtonTitle:@"OK"];
	[prompt addTextFieldOfType:EUIPromptTypeText withLabel:@"Enter Value" value:nil];
	[prompt show];
	[prompt release];
}

-(void)promptDidConfirm:(EUIPrompt*)prompt {
	NSString* value = [[[prompt fields] objectAtIndex:0] text];
	if([self.array respondsToSelector:@selector(addObject:)]) {
		[self.array addObject:value];
	}
	[self.tableView reloadData];
	
}

-(void)done{
	[self setValue: self.array];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)setValue:(NSArray*)value{
	// Get a string value to display
	((UILabel*)self.field.control).text = [EUIFormField getString: value forField: self.field];
	
	// Handle if we have a dictionary
	if([self.field.object isKindOfClass:[NSMutableDictionary class]]) {
		[(NSMutableDictionary*)self.field.object setObject:value forKey:self.field.property];
		
	// Otherwise set it using KVC
	} else {
		NSString* attributes = nil;
		objc_property_t property = class_getProperty([self.field.object class], [self.field.property cStringUsingEncoding: NSASCIIStringEncoding]);
		if(property != nil) {
			attributes = [NSString stringWithCString: property_getAttributes(property) encoding:NSASCIIStringEncoding];
		}
		
		// Set the value
		SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[self.field.property substringToIndex:1] uppercaseString], [self.field.property substringFromIndex:1]]);
		if([self.field.object respondsToSelector:setter]) {
			if(attributes != nil && [attributes rangeOfString:@"NSSet"].length > 0) {
				[self.field.object performSelector:setter withObject: [NSSet setWithArray: value]];
			} else if (attributes != nil && [attributes rangeOfString:@"NSString"].length > 0) {
				[self.field.object performSelector:setter withObject: [value componentsJoinedByString:@"\n"]];
			} else {
				[self.field.object performSelector:setter withObject: value];
			}
		}
	}
}

-(void)close{
	int i = [self.navigationController.viewControllers indexOfObject:self];
	UIViewController* form = [self.navigationController.viewControllers objectAtIndex:i-1];
	[self.navigationController popToViewController: form animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	noResults = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.array == nil || self.array.count == 0) {
		noResults.hidden = NO;
		return 0;
	} else {
		noResults.hidden = YES;
		return self.array.count;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.array objectAtIndex:indexPath.row]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	[self.array exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)dealloc {
	[noResults release];
	[_field release];
	[_array release];
    [super dealloc];
}


@end

