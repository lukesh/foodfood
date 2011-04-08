//
//  UISampleForm.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/8/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormSample.h"


@implementation EUIFormSample

- (void)viewDidLoad {
    [super viewDidLoad];
	
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  	[object release];
}


- (void)dealloc {
    [super dealloc];
}


@end
