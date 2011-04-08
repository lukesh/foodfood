//
//  FormSingleton.h
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FormSingleton : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary * dictionary;

+(id)instance;
-(void)setValue:(id)value forTag:(int)tag;
-(id)getValueForTag:(int)tag;
    
@end
