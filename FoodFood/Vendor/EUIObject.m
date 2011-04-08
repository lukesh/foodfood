//
//  EUIObject.m
//  Strine
//
//  Created by Jason Kichline on 10/21/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIObject.h"
#import "EUIPostData.h"
#import <objc/runtime.h>

static id getter(id self, SEL _cmd) {
	NSString* key = [NSString stringWithCString:sel_getName(_cmd) encoding: NSASCIIStringEncoding];
	id value = [[self dictionary] objectForKey:key];
	return value;
}

static void setter(id self, SEL _cmd, id value) {
	if ([self dictionary] == nil) {
		return;
	}
	NSString* key = [NSString stringWithCString:sel_getName(_cmd) encoding: NSASCIIStringEncoding];
	key = [key substringToIndex:[key rangeOfString:@":"].location];
	if([key hasPrefix:@"set"]) {
		key = [key substringFromIndex:3];
		key = [NSString stringWithFormat:@"%@%@", [[key substringToIndex:1] lowercaseString], [key substringFromIndex:1]];
	}
	if([[self dictionary] isKindOfClass:[NSMutableDictionary class]]) {
		NSMutableDictionary* d = [self dictionary];
		if(value != nil) {
			[d setObject:value forKey:key];
		} else {
			[d setObject:[NSNull null] forKey:key];
		}
	} else {
		NSLog(@"Could not set the dictionary value for '%@' because the dictionary is read-only", key);
	}
}

@implementation EUIObject

@synthesize dictionary = _dictionary;

-(id)initWithDictionary:(NSDictionary*)dictionary {
	if(self = [self init]) {
		if([dictionary isKindOfClass:[NSMutableDictionary class]] == NO) {
			dictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
		}
		[_dictionary release];
		[dictionary retain];
		_dictionary = (NSMutableDictionary*)dictionary;
		
		for(id key in [dictionary allKeys]) {
			SEL setterSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]]);
			class_replaceMethod([self class], NSSelectorFromString(key), (IMP)getter, "@@:");
			class_replaceMethod([self class], setterSelector, (IMP)setter, "v@:@");
		}
	}
	return self;
}

-(NSString*)description{
	return [self.dictionary objectForKey:@"description"];
}

-(void)setDescription:(NSString*)value{
	[self.dictionary setObject:value forKey:@"description"];
}

+(BOOL)resolveInstanceMethod:(SEL)selector{
	NSString* key = [NSString stringWithCString:sel_getName(selector) encoding: NSASCIIStringEncoding];
	if([key rangeOfString:@":"].length == 1) {
		class_replaceMethod([self class], selector, (IMP)setter, "v@:@");	
	} else {
		class_replaceMethod([self class], selector, (IMP)getter, "@@:");
	}
	return YES;
}

-(NSString*)toPostData{
	EUIPostData* postData = [[EUIPostData alloc] initWithDictionary:self.dictionary];
	NSString* s = [postData serialize];
	[postData release];
	return s;
}

-(void)dealloc{
	[_dictionary release];
	[super dealloc];
}

@end