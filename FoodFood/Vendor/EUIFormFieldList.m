//
//  EUIFormFieldList.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/8/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormFieldList.h"


@implementation EUIFormFieldList

@synthesize data = _data;
@synthesize field = _field;
@synthesize sections = _sections;
@synthesize selected = _selected;

- (id)initWithField: (EUIFormField*) field {
    if (self = [self init]) {
		self.field = field;
//		self.field.delegate = self;
    }
    return self;
}

-(void)setField:(EUIFormField*)value{
	[_field autorelease];
	_field = [value retain];
	_selected = nil;
}

-(id)selected{
	if(_selected == nil) {
		// Get the item
		id item = nil;
		if(self.field.object != nil && self.field.property != nil) {
			SEL selector = NSSelectorFromString(self.field.property);
			if([self.field.object respondsToSelector:selector]) {
				item = [self.field.object performSelector: selector];
			}
		}
		self.selected = item;
	}
	return _selected;
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(self.sections == nil || section >= self.sections.count) { return nil; }
	return [self.sections objectAtIndex:section];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

	if(self.field != nil) {
		self.navigationItem.title = self.field.name;
		if(self.field.type == EUIFormFieldTypeCheckList) {
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
		}
	}
}

-(void)done{
	[self setItem:self.selected];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.data = [NSMutableArray array];
	self.sections = nil;
	if(self.field.options == nil) {
		self.field.options = [NSArray array];
	}
	if(self.field.optionsSectionProperty == nil) {
		[self.data addObject: self.field.options];
	} else {
		self.sections = [NSMutableArray array];
		SEL getter = NSSelectorFromString(self.field.optionsSectionProperty);
		
		NSString* section = nil;
		NSString* lastSection = nil;
		NSMutableArray* list = [NSMutableArray array];
		for (int i = 0;i<[self.field.options count];i++) {
			id item = [self.field.options objectAtIndex:i];
			if([item isKindOfClass:[NSDictionary class]]) {
				section = [item objectForKey:self.field.optionsSectionProperty];
			} else {
				section = [item performSelector:getter];
			}
			if ([section isEqualToString:lastSection] == NO) {
				[self.sections addObject:section];
				if(lastSection != nil) {
					[self.data addObject:list];
					list = [NSMutableArray array];
				}
			}
			[list addObject:item];
			lastSection = section;
		}
		[self.data addObject:list];
	}
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(self.sections == nil) { return 1; }
	return self.sections.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(self.data == nil || [self.data count] < 1) { return 0; }
    return [[self.data objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// Get the item
	id item = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
	// Set the text of the option
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.text = [NSString stringWithFormat:@"%@", item];
	if(self.field.optionsProperty != nil && self.field.optionsProperty.length > 0) {
		if([item isKindOfClass:[NSDictionary class]]) {
			cell.textLabel.text = [NSString stringWithFormat:@"%@", [item objectForKey:self.field.optionsProperty]];
		} else {
			SEL selector = NSSelectorFromString(self.field.optionsProperty);
			if([item respondsToSelector:selector]) {
				cell.textLabel.text = [NSString stringWithFormat:@"%@", [item performSelector: selector]];
			}
		}
	}
	
	// Determine if a checkmark is placed
	if(self.field.type == EUIFormFieldTypeCheckList) {
		if([self.field isItem:item inList:self.selected]) {
			cell.imageView.image = [UIImage imageNamed:@"Checked.png"];
		} else {
			cell.imageView.image = [UIImage imageNamed:@"Unchecked.png"];
		}
	} else {
		if([self.field isItem:item inList:self.selected]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		
		// Add an icon if we have one
		if(self.field.optionsIconProperty != nil && self.field.optionsIconProperty.length > 0) {
			id image = nil;
			if([item isKindOfClass:[NSDictionary class]]) {
				image = [item objectForKey:self.field.optionsIconProperty];
			} else {
				SEL selector = NSSelectorFromString(self.field.optionsIconProperty);
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
	
	// Set the background color of the cell's selected state
	if(self.field.highlightColor != nil) {
		CGSize size = CGSizeMake(cell.contentView.frame.size.width + cell.accessoryView.frame.size.width, cell.contentView.frame.size.height + cell.accessoryView.frame.size.height);
		UIView* background = [[UIView alloc] initWithFrame:cell.frame];
		background.backgroundColor = self.field.highlightColor;
		background.frame = CGRectMake(0, 0, size.width, size.height);
		UIImageView* backgroundImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"FormHighlight.png"]];
		backgroundImage.frame = CGRectMake(1, 1, size.width, size.height);
		[background addSubview:backgroundImage];
		cell.selectedBackgroundView = background;
		[backgroundImage release];
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	// Enabled drill into hierarchy
	if(self.field.optionsChildrenProperty != nil && self.field.optionsChildrenProperty.length > 0) {
		if([item isKindOfClass:[NSDictionary class]]) {
			NSArray* children = [item objectForKey:self.field.optionsChildrenProperty];
			if(children != nil && [children isKindOfClass:[NSArray class]] && children.count > 0) {
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			}			
		} else {
			SEL childSelector = NSSelectorFromString(self.field.optionsChildrenProperty);
			if([item respondsToSelector:childSelector]) {
				NSArray* children = [item performSelector:childSelector];
				if(children != nil && [children isKindOfClass:[NSArray class]] && children.count > 0) {
					cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				}
			}
		}
	}
	
	// Return the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Get the item
	id item = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	// If this isn't a checklist then just set it and forget
	if(self.field.type != EUIFormFieldTypeCheckList) {
		[self setItem: item];
		self.selected = item;
		[self.tableView reloadData];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	// Set the selected array
	if(self.selected == nil) { self.selected = [NSMutableArray array]; }
	int index = [self.field findIndexOf: item inList: self.selected];
	if(index >= 0) {
		[self.selected removeObjectAtIndex:index];
	} else {
		[self.selected addObject:item];
	}
	[self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:NO];
	[self performSelector: @selector(unHighlight) withObject:nil afterDelay:0.5];
}

-(void)unHighlight{
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	// Get the item
	id item = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

	// If we have data, then let's push a sublist controller
	EUIFormFieldSubList* sublist = [[EUIFormFieldSubList alloc] initWithParent:self andObject: item];
	[self.navigationController pushViewController:sublist animated:YES];
	[sublist release];
}

-(id)getItemValue:(id)value{
	if(self.field.optionsValueProperty != nil) {
		if([value isKindOfClass:[NSArray class]]) {
			NSMutableArray* a = [NSMutableArray array];
			for(id subvalue in value) {
				[a addObject:[self getItemValue: subvalue]];
			}
			value = a;
		} else if([value isKindOfClass:[NSDictionary class]]) {
			value = [value objectForKey:self.field.optionsValueProperty];
		} else {
			SEL valueSelector = NSSelectorFromString(self.field.optionsValueProperty);
			if([value respondsToSelector:valueSelector]) {
				value = [value performSelector:valueSelector];
			}
		}
	}
	return value;
}

-(id)getItemName:(id)value{
	if(self.field.optionsProperty != nil) {
		if([value isKindOfClass:[NSArray class]]) {
			NSMutableArray* a = [NSMutableArray array];
			for(id subvalue in value) {
				[a addObject:[self getItemName: subvalue]];
			}
			value = a;
		} else if([value isKindOfClass:[NSDictionary class]]) {
			value = [value objectForKey:self.field.optionsProperty];
		} else {
			SEL valueSelector = NSSelectorFromString(self.field.optionsProperty);
			if([value respondsToSelector:valueSelector]) {
				value = [value performSelector:valueSelector];
			}
		}
	}
	return value;
}

-(void)setItem:(id)value{
	// Get a string value to display
	((UILabel*)self.field.control).text = [EUIFormField getString: value forField: self.field];
	
	// Set the value
	value = [self getItemValue:value];
	self.field.value = value;

	if(self.field.delegate != nil && [self.field.delegate respondsToSelector:@selector(fieldHasChanged:)]) {
		[self.field.delegate fieldHasChanged: self.field];
	}
}

-(void)close{
	int i = [self.navigationController.viewControllers indexOfObject:self];
	UIViewController* form = [self.navigationController.viewControllers objectAtIndex:i-1];
	[self.navigationController popToViewController: form animated:YES];
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
	[_field release];
	[_selected release];
	[_data release];
	[_sections release];
    [super dealloc];
}


@end

