//
//  MainForm.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "MainForm.h"
#import "MainModel.h"
#import "EUIFormField.h"

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
    
    form = [[MainModel alloc] init];
    
    [self addGroup:@"Product Information"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"SKU" fromObject:form valueOfProperty:@"sku"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"Name" fromObject:form valueOfProperty:@"name"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"Mfg. ID" fromObject:form valueOfProperty:@"manufacturer_id"];
    [self addFieldOfType:EUIFormFieldTypeText withName:@"Photo URL" fromObject:form valueOfProperty:@"photo"];
    [self addFieldOfType:EUIFormFieldTypeTextEditor withName:@"OCR Text" fromObject:form valueOfProperty:@"ocr"];
    
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
