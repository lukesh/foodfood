//
//  EUIFormFieldSubList.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/11/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EUIFormFieldList;

@interface EUIFormFieldSubList : UITableViewController {
	EUIFormFieldList* _parent;
	NSArray* _data;
	id _object;
}

@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSArray* data;
@property (nonatomic, retain) EUIFormFieldList* parent;

-(id)initWithParent:(EUIFormFieldList*) parent andObject: (id)object;

@end
