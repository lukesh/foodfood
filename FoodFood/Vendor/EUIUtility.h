//
//  EUIUtility.h
//  Strine
//
//  Created by Jason Kichline on 12/22/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EUIUtility : NSObject {

}

+(BOOL)isBlank:(id)value;
+(NSString*)coalesce:(id)value with:(id)replacement;

@end
