//
//  MainForm.h
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIForm.h"
#import "EditableCell.h"
#import "EUIFormSampleObject.h"

@interface MainForm : EUIForm {
    Boolean keyboardIsShowing;
    CGRect keyboardBounds;
    EUIFormSampleObject* object;
}

@property (nonatomic, retain) IBOutlet UIButton * goButton;

- (IBAction)goButtonOnClick:(id)sender;
- (void)resizeViewControllerToFitScreen;

@end
