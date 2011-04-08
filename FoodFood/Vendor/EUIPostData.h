//
//  EUIPostData.h
//  Strine
//
//  Created by Jason Kichline on 10/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EUIPostData : NSObject {
	NSMutableDictionary* _dictionary;
	NSMutableDictionary* _keyReplacements;
	NSString* _keyPrefix;
	NSString* _assignmentSeperator;
	NSString* _concatentationSeperator;
	NSString* _keySeperator;
	NSString* _arraySeperator;
	NSDateFormatter* _dateFormatter;
	int _startArraysAt;
	BOOL _includeBlankValues;
	NSArray* _keysToIgnore;
}

@property (nonatomic, retain) NSMutableDictionary* dictionary;
@property (nonatomic, retain) NSMutableDictionary* keyReplacements;
@property (nonatomic, retain) NSString* keyPrefix;
@property (nonatomic, retain) NSString* assignmentSeperator;
@property (nonatomic, retain) NSString* concatentationSeperator;
@property (nonatomic, retain) NSString* keySeperator;
@property (nonatomic, retain) NSString* arraySeperator;
@property (nonatomic, retain) NSArray* keysToIgnore;
@property (nonatomic, retain) NSDateFormatter* dateFormatter;
@property int startArraysAt;
@property BOOL includeBlankValues;

-(id)initWithDictionary:(NSDictionary*)dictionary;

-(NSString*)serialize;
-(NSString*)serialize:(NSDictionary*)dictionary;
-(NSString*)serialize:(NSDictionary*)dictionary withPrefix:(NSString*)prefix;
-(NSString*)serialize:(id)value withKey:(id)key;
-(void)setArrayReplacementsFor:(NSString*)propertyName withType:(NSString*) type;
-(void)setArrayReplacementsFor:(NSString*)propertyName withTypes:(id) type, ...;
-(id)postToUrl:(id)url;

@end
