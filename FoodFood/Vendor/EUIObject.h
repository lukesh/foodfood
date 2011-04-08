//
//  EUIObject.h
//  Strine
//
//  Created by Jason Kichline on 10/21/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EUIObject : NSObject {
	NSMutableDictionary* _dictionary;
}

@property (readonly) NSMutableDictionary* dictionary;

-(id)initWithDictionary:(NSDictionary*)dictionary;

-(NSString*)toPostData;
 
@end
