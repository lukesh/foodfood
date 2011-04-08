//
//  EUIFormSampleObject.m
//  Leiodromos
//
//  Created by Jason Kichline on 8/8/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIFormSampleObject.h"


@implementation EUIFormSampleObject

@synthesize username;
@synthesize password;
@synthesize url;
@synthesize email;
@synthesize description;
@synthesize phone;
@synthesize date;
@synthesize time;
@synthesize items;
@synthesize timezone;
@synthesize timezones;
@synthesize number;
@synthesize value;
@synthesize active;

-(id)init {
	if(self = [super init]) {
		self.username = @"jkichline";
		self.password = @"12345678";
		self.url = @"http://www.google.com";
		self.email = @"jkichline@gmail.com";
		self.description = @"This is just a basic description that I want to describe.";
		self.phone = @"(717) 555-1234";
		self.date = [NSDate date];
		self.time = [NSDate date];
		self.timezone = [NSTimeZone timeZoneWithName:@"UTC"];
		self.timezones = [[NSMutableArray alloc] init];
		[self.timezones addObject:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
		[self.timezones addObject:[NSTimeZone timeZoneWithAbbreviation:@"CST"]];
		self.number = 20;
		self.value = 0.5;
		self.active = YES;
	}
	return self;
}

-(void)dealloc{
	[username release];
	[password release];
	[url release];
	[email release];
	[description release];
	[phone release];
	[date release];
	[time release];
	[items release];
	[timezone release];
	[timezones release];
	[super dealloc];
}

@end
