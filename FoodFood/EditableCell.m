//
//  EditableCell.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "EditableCell.h"
#import "FormSingleton.h"

@implementation EditableCell

@synthesize input;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.input = [[[UITextField alloc] initWithFrame:self.frame] autorelease];
        //[self addSubview:self.input];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"Did being editting...");
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"CellEdited" object:self];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"Finished editing %i", self.tag);
    [[FormSingleton instance] setValue:textField.text forTag:self.tag];
}

#pragma mark - Memory Management
- (void)dealloc
{
    NSLog(@"Deallocating cell");
    self.input = nil;
    [super dealloc];
}

@end
