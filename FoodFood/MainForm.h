//
//  MainForm.h
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIForm.h"
#import "EUIFormSampleObject.h"

@interface MainForm : EUIForm {
    EUIFormSampleObject* form;
}

@property (nonatomic, retain) IBOutlet UIButton * go;

- (IBAction)goClick:(id)sender;

@end
