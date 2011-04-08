//
//  EUIUtility.m
//  Strine
//
//  Created by Jason Kichline on 12/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIUtility.h"


@implementation EUIUtility

+(BOOL)isBlank:(id)value{
	if(value == nil) { return YES; }
	if([[NSString stringWithFormat:@"%@", value] isEqualToString: @""]) { return YES; }
	return NO;
}

+(NSString*)coalesce:(id)value with:(id)replacement{
	if(value == nil) { return [NSString stringWithFormat:@"%@", replacement]; }
	return [NSString stringWithFormat:@"%@", value];
}

@end