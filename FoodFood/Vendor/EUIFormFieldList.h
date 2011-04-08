//
//  EUIFormFieldList.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/8/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIFormField.h"
#import "EUIFormFieldSubList.h"

@interface EUIFormFieldList : UITableViewController <EUIFormFieldDelegate> {
	EUIFormField* _field;
	id _selected;
	NSMutableArray* _data;
	NSMutableArray* _sections;
}

@property (nonatomic, retain) EUIFormField* field;
@property (nonatomic, retain) id selected;
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic, retain) NSMutableArray* sections;

-(id)initWithField: (EUIFormField*) field;
-(id)getItemValue:(id)value;
-(id)getItemName:(id)name;
-(void)setItem:(id)item;
-(void)close;

@end
