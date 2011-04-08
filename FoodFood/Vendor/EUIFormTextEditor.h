//
//  EUIFormTextEditor.h
//  MedKit
//
//  Created by Jason Kichline on 3/4/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIFormField.h"

@interface EUIFormTextEditor : UIViewController <EUIFormFieldDelegate> {
	UITextView* textView;
	EUIFormField* _field;
}

@property (nonatomic, retain) EUIFormField* field;

-(id)initWithField:(EUIFormField*)field;

@end
