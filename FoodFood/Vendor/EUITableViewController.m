//
//  EUITableViewController.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUITableViewController.h"

@implementation EUITableViewController

@synthesize tintColor = _tintColor;
@synthesize headerColor = _headerColor;
@synthesize highlightColor = _highlightColor;
@synthesize tableView = _tableView;
@synthesize background = _background;
@synthesize backgroundPattern = _backgroundPattern;
@synthesize busy = _busy;
@synthesize busyOverlay = _busyOverlay;
@synthesize spinner = _spinner;
@synthesize headerFont = _headerFont;

#pragma mark Initialization

-(id)init{
	return [self initWithStyle:UITableViewStylePlain];
}

-(id)initWithStyle:(UITableViewStyle)value {
    if (self = [super init]) {
		_tableStyle = value;
    }
    return self;
}

#pragma mark Custom Getters

-(UIColor*)headerColor{
	if(_headerColor == nil) {
		return self.tintColor;
	}
	return _headerColor;
}

-(UIColor*)tintColor{
	if(_tintColor == nil) {
		return [EUITableViewController defaultTintColor];
	}
	return _tintColor;
}

-(UIColor*)highlightColor{
	return _highlightColor;
}

-(UIFont*)headerFont{
	if(_headerFont == nil) { return [EUITableViewController defaultHeaderFont]; }
	return _headerFont;
}

#pragma mark Custom Setter

-(void)setTintColor:(UIColor*)value{
	[_tintColor release];
	_tintColor = [value retain];
	[self.background setBackgroundColor:self.tintColor];
}

-(void)setBusy:(BOOL)busy{
	if(busy != _busy) {
		float alpha = 0;
		if(busy) {
			alpha = 0.5;
			[self.spinner startAnimating];
		} else {
			[self.spinner stopAnimating];
		}
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations: @"BusyAnimation" context: context];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration: self.spinner.fadeDuration];
		self.busyOverlay.alpha = alpha;
		[UIView commitAnimations];
	}
	_busy = busy;
}

-(void)setBusy:(BOOL)busy withStatus:(NSString*)status {
	self.spinner.status = status;
	self.busy = busy;
}

#pragma mark Default Values

+(UIColor*)defaultTintColor{
	return [UIColor colorWithRed:(float)64/255 green:(float)86/255 blue:(float)103/255 alpha:1];
}

+(UIColor*)defaultHeaderColor{
	return [UIColor colorWithRed:(float)56/255 green:(float)84/255 blue:(float)135/255 alpha:1];
}

+(UIFont*)defaultHeaderFont{
	return [UIFont boldSystemFontOfSize:17];
}

#pragma mark View Controller Overrides

-(void)loadView{
	[super loadView];
	
	// Create the content view
	UIView* contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// Add the background color
	if(_tableStyle == UITableViewStyleGrouped) {
		self.background = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		self.background.frame = CGRectMake(0, 0, self.background.frame.size.width, self.background.frame.size.height);
		self.background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.background.opaque = NO;
		self.background.backgroundColor = self.tintColor;
		[contentView addSubview:self.background];
	
	// Add the semi-transparent pattern to look like the iPhone background
		self.backgroundPattern = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EUIFormBackground.png"]];
		self.background.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundPattern.opaque = NO;
		[self.background addSubview:self.backgroundPattern];
	}
	
	// Add the table to the view
	UITableView* tempTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style: _tableStyle];
	tempTable.frame = CGRectMake(0, 0, tempTable.frame.size.width, tempTable.frame.size.height);
	tempTable.delegate = self;
	tempTable.dataSource = self;
	tempTable.opaque = NO;
	tempTable.backgroundColor = [UIColor clearColor];
	tempTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView = tempTable;
	[contentView addSubview:tempTable];
	[tempTable release];
	
	// Add an invisible loading screen
	self.busyOverlay = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.busyOverlay.frame = CGRectMake(0, 0, self.busyOverlay.frame.size.width, self.busyOverlay.frame.size.height);	
	self.busyOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.busyOverlay.opaque = NO;
	self.busyOverlay.backgroundColor = [UIColor whiteColor];
	self.busyOverlay.alpha = 0;
	[contentView addSubview:self.busyOverlay];
	
	// Add the spinner to the busy overlay
	self.spinner = [[EUIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
	CGRect r = CGRectMake((self.busyOverlay.frame.size.width-self.spinner.frame.size.width)/2, self.spinner.frame.size.height, self.spinner.frame.size.width, self.spinner.frame.size.width);
	self.spinner.frame = r;
	self.spinner.alpha = 0.4;
	[contentView addSubview:self.spinner];
	
	// Set the content view of the view controller
	self.view = contentView;
	[contentView release];
}

#pragma mark Table View Methods

// Custom headers
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
	
	if([self respondsToSelector:@selector(tableView:titleForHeaderInSection:)]==NO) { return nil; }
	
	// Setup padding
	float topPadding = 8;
	float bottomPadding = 5;
	float sidePadding = 20;
	if(section == 0) {
		topPadding += 9;
	}
	
	// Create the label
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, topPadding, tableView.frame.size.width-(sidePadding*2), 100)];
	label.text = [self tableView:tableView titleForHeaderInSection:section];
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
	
	return [view autorelease];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	UIView* view = [self tableView:tableView viewForHeaderInSection:section];
	if(view == nil) { return 0; }
	return view.frame.size.height;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// Return the cell
    return cell;
}

- (void)dealloc {
	[_tintColor release];
	[_headerColor release];
	[_highlightColor release];
	[_background release];
	[_busyOverlay release];
	[_spinner release];
	[_backgroundPattern release];
	[_tableView release];
	[_headerFont release];
    [super dealloc];
}


@end

