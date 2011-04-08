//
//  MainForm.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "MainForm.h"
#import "FormSingleton.h"
#import "EUIFormField.h"
#import "EUIFormSampleObject.h"

@implementation MainForm

@synthesize goButton;

Boolean keyboardIsShowing;
CGRect keyboardBounds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Main Form";
    }
    return self;
}

- (void)dealloc
{
    [object dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Setters

- (void)setGoButton:(UIButton *)_goButton
{
    if(goButton != _goButton) {
        [goButton release];
        goButton = [_goButton retain];
    }
    NSLog(@"Done set mah gobutton");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    EUIFormField* field;
    NSMutableArray* t = [[NSMutableArray alloc] init];
    for(NSString* name in [NSTimeZone knownTimeZoneNames]) {
        [t addObject:[NSTimeZone timeZoneWithName:name]];
    }
    
    object = [[EUIFormSampleObject alloc] init];
    
    [self addGroup:@"Group One"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"Username" fromObject:object valueOfProperty:@"username"];
    [self addFieldOfType:EUIFormFieldTypePassword withName:@"Password" fromObject:object valueOfProperty:@"password"];
    [self addFieldOfType:EUIFormFieldTypeURL withName:@"URL" fromObject:object valueOfProperty:@"url"];
    [self addFieldOfType:EUIFormFieldTypeEmail withName:@"Email" fromObject:object valueOfProperty:@"email"];
    
    [self addGroup:@"Group Two"];
    [self addFieldOfType:EUIFormFieldTypePhone withName:@"Phone" fromObject:object valueOfProperty:@"phone"];
    [self addFieldOfType:EUIFormFieldTypeDate withName:@"Date" fromObject:object valueOfProperty:@"date"];
    [self addFieldOfType:EUIFormFieldTypeTime withName:@"Time" fromObject:object valueOfProperty:@"time"];
    
    field = [self addFieldOfType:EUIFormFieldTypeList withName:@"Time Zone" fromObject:object valueOfProperty:@"timezone"];
    field.optionsProperty = @"name";
    field.options = t;
    
    field = [self addFieldOfType:EUIFormFieldTypeCheckList withName:@"Time Zones" fromObject:object valueOfProperty:@"timezones"];
    field.optionsProperty = @"name";
    field.options = t;
    
    [self addFieldOfType:EUIFormFieldTypeNumber withName:@"Number" fromObject:object valueOfProperty:@"number"];
    [self addFieldOfType:EUIFormFieldTypeSlider withName:@"Slider" fromObject:object valueOfProperty:@"value"];
    [self addFieldOfType:EUIFormFieldTypeBoolean withName:@"Is Active?" fromObject:object valueOfProperty:@"active"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction methods

- (IBAction)goButtonOnClick:(id)sender
{
    NSLog(@"Button clicked");
}

#pragma mark - UITableView delegate methods

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"FormCell";
    
    EditableCell * cell = (EditableCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"EditableCell" owner:self options:nil];
        cell = [self.editableCell retain];
    }
    
    cell.tag = 1000 + indexPath.row;
    cell.input.placeholder = [[NSNumber numberWithInt:indexPath.row] stringValue];
    cell.input.text = [[FormSingleton instance] getValueForTag:cell.tag];

    return cell;
}

#pragma mark - UITableViewDataSource delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0F;    
}
 
 */
@end
