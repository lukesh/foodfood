//
//  EUIFormFieldSubList.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/11/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormFieldSubList.h"
#import "EUIFormFieldList.h"

@implementation EUIFormFieldSubList

@synthesize data = _data;
@synthesize object = _object;
@synthesize parent = _parent;

-(id)initWithParent:(EUIFormFieldList*) parent andObject: (id)object {
    if (self = [super init]) {
		self.object = object;
		self.parent = parent;
		
		// Set the data to the children
		NSString* p = self.parent.field.optionsChildrenProperty;
		if(p != nil && p.length > 0) {
			SEL childrenSelector = NSSelectorFromString(p);
			if([object respondsToSelector:childrenSelector]) {
				self.data = (NSArray*)[object performSelector:childrenSelector];
			}
		}
		
		// Set the title to the text of the parent object
		p = self.parent.field.optionsProperty;
		if(p != nil && p.length > 0) {
			SEL selector = NSSelectorFromString(p);
			if([self.object respondsToSelector:selector]) {
				self.navigationItem.title = [self.object performSelector:selector];
			}
		}
    }
    return self;
}

-(void)setData:(NSArray*)value{
	[_data autorelease];
	_data = [value retain];
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.data == nil) { return 0; }
    return self.data.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// Get the item
	id item = [self.data objectAtIndex:indexPath.row];
    
	// Set the text of the option
	cell.textLabel.text = [NSString stringWithFormat:@"%@", item];
	if(self.parent.field.optionsProperty != nil && self.parent.field.optionsProperty.length > 0) {
		SEL selector = NSSelectorFromString(self.parent.field.optionsProperty);
		if([item respondsToSelector:selector]) {
			cell.textLabel.text = [NSString stringWithFormat:@"%@", [item performSelector: selector]];
		}
	}
	
	// Set the background color of the cell's selected state
	if(self.parent.field.highlightColor != nil) {
		CGSize size = CGSizeMake(cell.contentView.frame.size.width + cell.accessoryView.frame.size.width, cell.contentView.frame.size.height + cell.accessoryView.frame.size.height);
		UIView* background = [[UIView alloc] initWithFrame:cell.frame];
		background.backgroundColor = self.parent.field.highlightColor;
		background.frame = CGRectMake(0, 0, size.width, size.height);
		UIImageView* backgroundImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"FormHighlight.png"]];
		backgroundImage.frame = CGRectMake(1, 1, size.width, size.height);
		[background addSubview:backgroundImage];
		cell.selectedBackgroundView = background;
		[backgroundImage release];
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	// determine if a checkmark is placed
	if(self.parent.field.type == EUIFormFieldTypeCheckList) {
		if([self.parent.field isItem:item inList:self.parent.selected]) {
			cell.imageView.image = [UIImage imageNamed:@"Checked.png"];
		} else {
			cell.imageView.image = [UIImage imageNamed:@"Unchecked.png"];
		}
	} else {
		if([self.parent.field isItem:item inList:self.parent.selected]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}

		// Add an icon if we have one
		if(self.parent.field.optionsIconProperty != nil && self.parent.field.optionsIconProperty.length > 0) {
			id image = nil;
			if([item isKindOfClass:[NSDictionary class]]) {
				image = [item objectForKey:self.parent.field.optionsIconProperty];
			} else {
				SEL selector = NSSelectorFromString(self.parent.field.optionsIconProperty);
				if([item respondsToSelector:selector]) {
					image = [item performSelector: selector];
				}
			}
			
			if([image isKindOfClass:[UIImage class]]) {
				image = image;
			} else if ([image isKindOfClass:[NSData class]] ) {
				image = [UIImage imageWithData:image];
			} else {
				image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", image]];
			}
			cell.imageView.image = image;
		}
	}
	
	// Enabled drill into hierarchy
	if(self.parent.field.optionsChildrenProperty != nil && self.parent.field.optionsChildrenProperty.length > 0) {
		SEL childSelector = NSSelectorFromString(self.parent.field.optionsChildrenProperty);
		if([item respondsToSelector:childSelector]) {
			NSArray* children = [item performSelector:childSelector];
			if(children != nil && [children isKindOfClass:[NSArray class]] && children.count > 0) {
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			}
		}
	}
	
	// Return the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	// Get the item
	id item = [self.data objectAtIndex:indexPath.row];
	
	// If this isn't a checklist then just set it and forget
	if(self.parent.field.type != EUIFormFieldTypeCheckList) {
		[self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:NO];
		[self.parent setItem: item];
		[self.parent close];
		return;
	}
	
	// Set the selected array
	int index = [self.parent.field findIndexOf: item inList: self.parent.selected];
	if(index >= 0) {
		[self.parent.selected removeObjectAtIndex:index];
	} else {
		[self.parent.selected addObject:item];
	}
	[self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	// Get the item
	id item = [self.data objectAtIndex:indexPath.row];
	
	// If we have data, then let's push a sublist controller
	EUIFormFieldSubList* sublist = [[EUIFormFieldSubList alloc] initWithParent:self.parent andObject: item];
	[self.navigationController pushViewController:sublist animated:YES];
	[sublist release];
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
	[_parent release];
	[_data release];
	[_object release];
    [super dealloc];
}


@end

