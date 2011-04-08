//
//  MainForm.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "MainForm.h"
#import "EUIFormField.h"
#import "EUIFormSampleObject.h"

@implementation MainForm

@synthesize go;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Main Form";
    }
    return self;
}

- (void)dealloc {
    [form dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EUIFormField* field;
    NSMutableArray* t = [[NSMutableArray alloc] init];
    for(NSString* name in [NSTimeZone knownTimeZoneNames]) {
        [t addObject:[NSTimeZone timeZoneWithName:name]];
    }
    
    form = [[EUIFormSampleObject alloc] init];
    
    [self addGroup:@"Group One"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"Username" fromObject:form valueOfProperty:@"username"];
    [self addFieldOfType:EUIFormFieldTypePassword withName:@"Password" fromObject:form valueOfProperty:@"password"];
    [self addFieldOfType:EUIFormFieldTypeURL withName:@"URL" fromObject:form valueOfProperty:@"url"];
    [self addFieldOfType:EUIFormFieldTypeEmail withName:@"Email" fromObject:form valueOfProperty:@"email"];
    
    [self addGroup:@"Group Two"];
    [self addFieldOfType:EUIFormFieldTypePhone withName:@"Phone" fromObject:form valueOfProperty:@"phone"];
    [self addFieldOfType:EUIFormFieldTypeDate withName:@"Date" fromObject:form valueOfProperty:@"date"];
    [self addFieldOfType:EUIFormFieldTypeTime withName:@"Time" fromObject:form valueOfProperty:@"time"];
    
    field = [self addFieldOfType:EUIFormFieldTypeList withName:@"Time Zone" fromObject:form valueOfProperty:@"timezone"];
    field.optionsProperty = @"name";
    field.options = t;
    
    field = [self addFieldOfType:EUIFormFieldTypeCheckList withName:@"Time Zones" fromObject:form valueOfProperty:@"timezones"];
    field.optionsProperty = @"name";
    field.options = t;
    
    [self addFieldOfType:EUIFormFieldTypeNumber withName:@"Number" fromObject:form valueOfProperty:@"number"];
    [self addFieldOfType:EUIFormFieldTypeSlider withName:@"Slider" fromObject:form valueOfProperty:@"value"];
    [self addFieldOfType:EUIFormFieldTypeBoolean withName:@"Is Active?" fromObject:form valueOfProperty:@"active"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction methods

- (IBAction)goClick:(id)sender {
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
