//
//  FormSingleton.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "FormSingleton.h"


@implementation FormSingleton

@synthesize dictionary;

-(void)setValue:(id)value forTag:(int)tag {
    NSString * tagObject = [[NSNumber numberWithInt:tag] stringValue];
    [self.dictionary setValue:value forKey:tagObject];
}

-(id)getValueForTag:(int)tag {
    NSString * tagObject = [[NSNumber numberWithInt:tag] stringValue];    
    return [self.dictionary objectForKey:tagObject];
}

static FormSingleton * _instance = nil;

+(id)instance {
    @synchronized([FormSingleton class]) {
        if(!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

#pragma mark -
#pragma mark Constructor

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc
{
    self.dictionary = nil;
    [super dealloc];
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)retain
{
    return _instance;
}

- (id)autorelease
{
    return _instance;
}


@end
