//
//  EUIFormGroup.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EUIForm;

@interface EUIFormGroup : NSObject {
	NSString* _name;
	NSString* _description;
	NSMutableDictionary* _fields;
	EUIForm* _form;
}

@property (nonatomic, retain) EUIForm* form;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSMutableDictionary* fields;
@property (readonly) NSString* html;

-(id)initWithName:(NSString*)name;
-(id)initWithName:(NSString*)name andDescription:(NSString*)description;
+(EUIFormGroup*)group;
+(EUIFormGroup*)groupWithName:(NSString*)name;
+(EUIFormGroup*)groupWithName:(NSString*)name andDescription:(NSString*)description;

@end
