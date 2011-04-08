//
//  EUIFormStringsEditor.h
//  TourGuide
//
//  Created by Jason Kichline on 10/2/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIFormField.h"
#import "EUIPrompt.h"

@interface EUIFormStringsEditor : UITableViewController <EUIPromptDelegate> {
	EUIFormField* _field;
	NSMutableArray* _array;
	UILabel* noResults;
}

@property (nonatomic, retain) EUIFormField* field;
@property (nonatomic, retain) NSMutableArray* array;

-(void)setValue:(id)value;
-(id)initWithField: (EUIFormField*) field;
-(void)close;

@end
