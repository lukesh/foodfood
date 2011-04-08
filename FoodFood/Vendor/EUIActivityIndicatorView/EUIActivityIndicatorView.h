//
//  PieActivityIndicator.h
//  Support
//
//  Created by Jason Kichline on 8/19/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	EUIActivityIndicatorTypePie,
	EUIActivityIndicatorTypeBubble,
	EUIActivityIndicatorTypeSpokes
} EUIActivityIndicatorType;

@interface EUIActivityIndicatorView : UIView {
	BOOL isAnimating;
	UIImageView* images;
	UILabel* statusLabel;
	UILabel* percentLabel;
	float percent;
	NSString* status;
	NSTimeInterval fadeDuration;
	NSTimeInterval animationDuration;
	float initialAlpha;
	EUIActivityIndicatorType type;
}

@property EUIActivityIndicatorType type;
@property (nonatomic, retain) NSString* status;
@property float percent;
@property BOOL isAnimating;
@property NSTimeInterval fadeDuration;
@property NSTimeInterval animationDuration;

-(void)startAnimating;
-(void)stopAnimating;

@end
