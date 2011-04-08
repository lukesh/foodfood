//
//  PieActivityIndicator.m
//  Support
//
//  Created by Jason Kichline on 8/19/09.
//  Copyright 2009 andCulture. All rights reserved.
//

#import "EUIActivityIndicatorView.h"


@implementation EUIActivityIndicatorView

@synthesize status, isAnimating, fadeDuration, animationDuration, type, percent;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Set up initial properties
		isAnimating = NO;
		fadeDuration = 0.5;
		animationDuration = 1.0;
		initialAlpha = 1;
		percent = -1;
		
		// Create the image animation and add it
		images = [[UIImageView alloc] initWithFrame:frame];
		images.animationDuration = self.animationDuration;
		images.alpha = 0;
		[self addSubview:images];
		
		// Sets the default type
		self.userInteractionEnabled = NO;
		self.type = EUIActivityIndicatorTypePie;

		// Add the percent label
		percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*0.25, frame.size.height*0.375, frame.size.width*0.5, frame.size.width*0.25)];
		percentLabel.font = [UIFont boldSystemFontOfSize:percentLabel.frame.size.height];
		percentLabel.adjustsFontSizeToFitWidth = YES;
		percentLabel.textAlignment = UITextAlignmentCenter;
		percentLabel.backgroundColor = [UIColor clearColor];
		percentLabel.alpha = 0;
		percentLabel.opaque = NO;
		[self addSubview:percentLabel];

		// Add the status label
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, percentLabel.frame.size.height)];
		statusLabel.font = [UIFont boldSystemFontOfSize:statusLabel.frame.size.height];
		statusLabel.adjustsFontSizeToFitWidth = YES;
		statusLabel.textAlignment = UITextAlignmentCenter;
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.alpha = 0;
		statusLabel.opaque = NO;
		statusLabel.text = self.status;
		[self addSubview:statusLabel];
    }
    return self;
}

-(void)setPercent:(float)value{
	percent = value;
	static NSNumberFormatter* percentFormatter;
	if(percentFormatter == nil) {
		percentFormatter = [[NSNumberFormatter alloc] init];
		[percentFormatter setNumberStyle: NSNumberFormatterPercentStyle];
	}
	percentLabel.text = [percentFormatter stringFromNumber: [NSNumber numberWithFloat:value]];
}

-(void)setType:(EUIActivityIndicatorType)value{
	type = value;

	NSString* prefix = @"";
	switch (type) {
		case EUIActivityIndicatorTypePie:
			prefix = @"Pie";
			break;
		case EUIActivityIndicatorTypeBubble:
			prefix = @"Bubble";
			break;
		default:
			break;
	}
	NSMutableArray* a = [[NSMutableArray alloc] init];
	for(int i=1;i<=8;i++){
		[a addObject: [UIImage imageNamed:[NSString stringWithFormat:@"%@Spinner%i.png", prefix, i]]];
	}
	images.animationImages = a;
	[a release];
}

-(void)setAnimationDuration:(NSTimeInterval)value{
	animationDuration = value;
	[images setAnimationDuration:value];
}

-(void)setStatus:(NSString*)value{
	[status autorelease];
	status = [value retain];
	[statusLabel setText:value];
}

-(void)isAnimating:(BOOL)value{
	if(isAnimating && !value) {
		[self stopAnimating];
	}
	if(!isAnimating && value) {
		[self startAnimating];
	}
	isAnimating = value;
}

-(void)setAlpha:(float)value{
	[super setAlpha:value];
	if(value > 0.1) {
		initialAlpha = value;
	}
}

-(void)startAnimating{
	[images startAnimating];
	isAnimating = YES;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations: @"EUIActivityIndicatorStart" context: context];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: self.fadeDuration];
	self.alpha = initialAlpha;
	images.alpha = 1;
	statusLabel.alpha = 1;
	percentLabel.alpha = 1;
	[UIView commitAnimations];
}

-(void)stopAnimating{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations: @"EUIActivityIndicatorStop" context: context];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: self.fadeDuration];
	self.alpha = 0;
	images.alpha = 0;
	statusLabel.alpha = 0;
	percentLabel.alpha = 0;
	[UIView commitAnimations];
	[images performSelector:@selector(stopAnimating) withObject: nil afterDelay: self.fadeDuration];
	isAnimating = NO;
}

- (void)dealloc {
	[images release];
	[status release];
	[statusLabel release];
	[percentLabel release];
    [super dealloc];
}


@end
