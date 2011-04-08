//
//  MainModel.m
//  FoodFood
//
//  Created by Francis Lukesh on 4/8/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

@synthesize sku;
@synthesize name;
@synthesize manufacturer_id;
@synthesize photo;
@synthesize ocr;

-(id)init {
    self = [super init];
	if(self) {
	}
	return self;
}

-(void)dealloc{
    [sku release];
    [name release];
    [manufacturer_id release];
    [photo release];
    [ocr release];
	[super dealloc];
}

@end
