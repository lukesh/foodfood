//
//  EUIFormSampleObject.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/8/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EUIFormSampleObject : NSObject {
	NSString* username;
	NSString* password;
	NSString* url;
	NSString* email;
	NSString* description;
	NSString* phone;
	NSDate* date;
	NSDate* time;
	NSArray* items;
	NSTimeZone* timezone;
	NSMutableArray* timezones;
	int number;
	float value;
	BOOL active;
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSDate* time;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSTimeZone* timezone;
@property (nonatomic, retain) NSMutableArray* timezones;
@property int number;
@property float value;
@property BOOL active;

@end
