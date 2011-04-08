//
//  EUITableViewController.h
//  Leiodromos
//
//  Created by Jason Kichline on 8/6/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIActivityIndicatorView.h"

@interface EUITableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UIColor* _tintColor;
	UIColor* _headerColor;
	UIColor* _highlightColor;
	UIView* _background;
	UIView* _busyOverlay;
	EUIActivityIndicatorView* _spinner;
	UIImageView* _backgroundPattern;
	UITableView* _tableView;
	UIFont* _headerFont;
	BOOL _busy;
	UITableViewStyle _tableStyle;
}

@property BOOL busy;
@property (nonatomic, retain) UIColor* tintColor;
@property (nonatomic, retain) UIColor* headerColor;
@property (nonatomic, retain) UIColor* highlightColor;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UIView* background;
@property (nonatomic, retain) UIView* busyOverlay;
@property (nonatomic, retain) UIImageView* backgroundPattern;
@property (nonatomic, retain) EUIActivityIndicatorView* spinner;
@property (nonatomic, retain) UIFont* headerFont;

-(void)setBusy:(BOOL)busy withStatus:(NSString*)status;
-(id)initWithStyle:(UITableViewStyle)style;
+(UIColor*)defaultTintColor;
+(UIColor*)defaultHeaderColor;
+(UIFont*)defaultHeaderFont;


@end
