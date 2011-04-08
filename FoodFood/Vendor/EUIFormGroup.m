//
//  EUIFormGroup.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormGroup.h"
#import "EUIFormField.h"

@implementation EUIFormGroup

@synthesize form = _form;
@synthesize name = _name;
@synthesize description = _description;
@synthesize fields = _fields;

-(id)initWithName:(NSString*)name{
	if(self = [self init]) {
		self.name = name;
		self.fields = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@""];
	}
	return self;
}

-(id)initWithName:(NSString*)name andDescription:(NSString*)description{
	if(self = [self init]) {
		self.name = name;
		self.description = description;
		self.fields = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@""];
	}
	return self;
}

-(NSString*)html {
	NSMutableString* o = [NSMutableString string];
	[o appendFormat:@"<h2>%@</h2>", self.name];
	if(self.description != nil) {
		[o appendFormat:@"<p>%@</p>", self.description];
	}
	if(self.fields != nil && [[self.fields objectForKey:@""] count] > 0){
		for(id field in [self.fields objectForKey:@""]) {
			if([field isKindOfClass:[EUIFormField class]]) {
				[o appendString:[(EUIFormField*)field html]];
			} else {
				[o appendFormat:@"%@", field];
			}
		}
	}
	return o;
}

+(EUIFormGroup*)group{
	return [[[EUIFormGroup alloc] init] autorelease];
}

+(EUIFormGroup*)groupWithName:(NSString*)name{
	return [[[EUIFormGroup alloc] initWithName:name] autorelease];
}

+(EUIFormGroup*)groupWithName:(NSString*)name andDescription:(NSString*)description{
	return [[[EUIFormGroup alloc] initWithName:name andDescription:description] autorelease];
}

-(void)dealloc{
	[_name release];
	[_description release];
	[_fields release];
	[_form release];
	[super dealloc];
}

@end
