//
//  EUIPostData.m
//  Strine
//
//  Created by Jason Kichline on 10/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIPostData.h"


@implementation EUIPostData

@synthesize dictionary = _dictionary;
@synthesize keyReplacements = _keyReplacements;
@synthesize keyPrefix = _keyPrefix;
@synthesize assignmentSeperator = _assignmentSeperator;
@synthesize concatentationSeperator = _concatentationSeperator;
@synthesize keySeperator = _keySeperator;
@synthesize arraySeperator = _arraySeperator;
@synthesize startArraysAt = _startArraysAt;
@synthesize includeBlankValues = _includeBlankValues;
@synthesize dateFormatter = _dateFormatter;
@synthesize keysToIgnore = _keysToIgnore;

-(id)init{
	if(self = [super init]) {
		self.keyPrefix = nil;
		self.keyReplacements = [[NSMutableDictionary alloc] init];
		self.assignmentSeperator = @"=";
		self.concatentationSeperator = @"&";
		self.keySeperator = @"_";
		self.startArraysAt = 1;
		self.includeBlankValues = NO;
		self.dateFormatter = [[NSDateFormatter alloc] init];
		[self.dateFormatter setDateFormat:@"M/d/yyyy h:mm:ss a"];
	}
	return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
	if(self = [self init]) {
		if([dictionary isKindOfClass:[NSMutableDictionary class]] == NO) {
			self.dictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
		} else {
			self.dictionary = (NSMutableDictionary*)dictionary;
		}
	}
	return self;
}

-(NSString*)serialize{
	return [self serialize:self.dictionary];
}

-(NSString*)serialize:(NSDictionary*)dictionary{
	return [self serialize:dictionary withPrefix:self.keyPrefix];
}

-(NSString*)serialize:(NSDictionary*)dictionary withPrefix:(NSString*)prefix{
	if(prefix == nil) { prefix = @""; }
	NSMutableString* s = [[NSMutableString alloc] init];
	for (id key in [dictionary allKeys]) {
		id o = [dictionary objectForKey:key];
		NSString* serialized = [self serialize:o withKey:[NSString stringWithFormat:@"%@%@", prefix, key]];
		if(serialized != nil && serialized.length > 0) {
			if(s.length > 0) { [s appendString:self.concatentationSeperator]; }
			[s appendString:serialized];
		}
	}
	return [s autorelease];
}

-(NSString*)serialize:(id)value withKey:(id)key{
	
	// Bail out if we don't include blank values
	if(self.includeBlankValues == NO) {
		if(value == nil || [[NSString stringWithFormat:@"%@", value] isEqualToString:@""]) {
			return nil;
		}
	}
	
	// Set up the string
	NSMutableString* s = [[NSMutableString alloc] init];
	
	// Handle any key replacements
	if(self.keyReplacements != nil) {
		NSString* actualKey = [self.keyReplacements objectForKey:key];
		if(actualKey != nil) { key = actualKey; }
	}
	
	// If it's an array
	if([value isKindOfClass:[NSArray class]]) {
		if([value count] > 0) {
			for (int i=0;i<[value count];i++) {
				if (i > 0) { [s appendString:self.concatentationSeperator]; }
				if ([[value objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
					NSString* name = [NSString stringWithFormat:@"%@%@%@", key, self.keySeperator, [NSNumber numberWithInt:i+self.startArraysAt]];
					[s appendString: [self serialize:[value objectAtIndex:i] withKey:name]];
				} else {
					[s appendFormat:@"%@%@%@", key, self.assignmentSeperator, [value objectAtIndex:i]];
				}
			}
		}
		
	// If it's a dictionary
	} else if ([value isKindOfClass:[NSDictionary class]]) {
		[s appendString: [self serialize:value withPrefix:[NSString stringWithFormat:@"%@%@", key, self.keySeperator]]];
		
	} else if([value isKindOfClass:[NSDate class]]) {
		[s appendFormat:@"%@%@%@", 
			[key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
			self.assignmentSeperator,
			[[self.dateFormatter stringFromDate:value] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		
	// Just serialize the value
	} else {
		[s appendFormat:@"%@%@%@", 
		 [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
		 self.assignmentSeperator,
		 [[NSString stringWithFormat:@"%@", value] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
		];
	}
	
	// Return the string
	return [s autorelease];
}

-(void)setArrayReplacementsFor:(NSString*)propertyName withType:(id)type{
	[self setArrayReplacementsFor:propertyName withTypes:type,nil];
}

-(void)setArrayReplacementsFor:(NSString*)propertyName withTypes:(id)type,...{
	
	// Set up the type array
	NSMutableArray* types = [[NSMutableArray alloc] init];
	
	// Add any additional items from the variable list
	id eachType;
	va_list argumentList;
	if (type) {
		[types addObject: type];
		va_start(argumentList, type);
		while (eachType = va_arg(argumentList, id)) {
			[types addObject: eachType];
		}
		va_end(argumentList);
	}
	
	// For each item in the property do the replacement
	for(int i=0;i<[[self.dictionary objectForKey:propertyName] count]; i++) {
		NSDictionary* v = [[self.dictionary objectForKey:propertyName] objectAtIndex:i];
		id tk = [v objectForKey:type];
		if(tk == nil) {
			tk = [NSNumber numberWithInt:i+1];
		}
		[self.dictionary setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@%@", propertyName, self.keySeperator, tk]];
		for(NSString* key in [v allKeys]) {
			NSMutableString* typeKey = [[NSMutableString alloc] init];
			for (id type in types) {
				if([key isEqualToString:type]) {
					continue;
				}
				if(typeKey.length > 0) { [typeKey appendString:self.keySeperator]; }
				tk = [v objectForKey:type];
				if(tk == nil) {
					tk = [NSNumber numberWithInt:i+1];
				}
				[typeKey appendFormat:@"%@", tk];
			}
			// bindery_1_ID --> bindery_ID_
			NSString* replaceKey = [NSString stringWithFormat:@"%@%@%i_%@", propertyName, self.keySeperator, i+self.startArraysAt, key];
			NSString* withKey = [NSString stringWithFormat:@"%@%@%@%@%@", propertyName, self.keySeperator, key, self.keySeperator, typeKey];
			[self.keyReplacements setObject:withKey forKey:replaceKey];
			[typeKey release];
		}
	}
	[types release];
}

-(id)postToUrl:(id)url{
	// Post the data to the web server.
	if([url isKindOfClass:[NSString class]]) {
		url = [NSURL URLWithString:url];
	}
	if([url isKindOfClass:[NSURL class]] == NO) {
		return nil;
	}

	NSString* serializedString = [self serialize];
	NSData* postData = [serializedString dataUsingEncoding:NSASCIIStringEncoding];
	NSString* postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSError* error;
	NSHTTPURLResponse* response;
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	
	NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString* resultString = [[[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding] autorelease];
	id resultOutput = resultString;
	if ([resultString rangeOfString:@"<plist"].length > 0 && [resultString hasPrefix:@"<"]) {
		resultOutput = [resultString propertyList];
	}
	return resultOutput;
}

-(void)dealloc {
	[_dictionary release];
	[_keyReplacements release];
	[_keyPrefix release];
	[_assignmentSeperator release];
	[_concatentationSeperator release];
	[ _keySeperator release];
	[_arraySeperator release];
	[_dateFormatter release];
	[_keysToIgnore release];
	[super dealloc];
}


@end
