//
//  EUIFormDatePicker.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/7/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIFormField.h"

@interface EUIFormDatePicker : UIViewController {
	UIDatePicker* datePicker;
	EUIFormField* field;
	UILabel* label;
}

@property (nonatomic, retain) EUIFormField* field;
@property (nonatomic, retain) UIDatePicker* datePicker;

@end
