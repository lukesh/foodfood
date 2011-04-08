//
//  EditableCell.h
//  FoodFood
//
//  Created by Francis Lukesh on 4/7/11.
//  Copyright 2011 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableCell : UITableViewCell <UITextFieldDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField * input;

@end
