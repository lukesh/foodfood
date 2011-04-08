//
//  MainModel.h
//  FoodFood
//
//  Created by Francis Lukesh on 4/8/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MainModel : NSObject {
    NSString* sku;
	NSString* name;
	NSString* manufacturer_id;
	NSString* photo;
	NSString* ocr;
}

@property (nonatomic, retain) NSString* sku;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* manufacturer_id;
@property (nonatomic, retain) NSString* photo;
@property (nonatomic, retain) NSString* ocr;

@end
