//
//  AnnotatedSliderViewController.m
//  AnnotatedSlider
//
//  Created by Alexander Repty on 24.09.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import "AnnotatedSliderViewController.h"

@implementation AnnotatedSliderViewController

@synthesize sliderView = _sliderView;
@synthesize folioCaseIconImageView = _folioCaseIconImageView;

#pragma mark -
#pragma mark Construction & Destruction

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark AnnotatedSliderViewController methods

- (void)showSlider {
	[self.sliderView show:YES];
}

- (IBAction)didTapAppIcon:(id)sender {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		NSURL *appStoreURL = [NSURL URLWithString:@"http://bit.ly/getfoliocase"];
		[[UIApplication sharedApplication] openURL:appStoreURL];
	} else {
		NSURL *websiteURL = [NSURL URLWithString:@"http://foliocaseapp.com/"];
		[[UIApplication sharedApplication] openURL:websiteURL];
	}
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect sliderRect = CGRectMake(20.0f, 218.0f, 280.0f, 44.0f);
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		sliderRect.origin.x = (self.view.frame.size.width - sliderRect.size.width) / 2.0f;
	}
	ARAnnotatedSliderView *sliderView = [[ARAnnotatedSliderView alloc] initWithFrame:sliderRect];
	sliderView.delegate = self;
	sliderView.dataSource = self;
	sliderView.backgroundColor = [UIColor clearColor];
	self.sliderView = sliderView;
	[sliderView release], sliderView = nil;
	
	[self.view addSubview:self.sliderView];
	[self.sliderView hide:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[self performSelector:@selector(showSlider) withObject:nil afterDelay:0.1f];
}

- (void)viewDidUnload {
	self.sliderView = nil;
	self.folioCaseIconImageView = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark ARAnnotatedSliderViewDelegate methods

- (void)pageScrubberView:(ARAnnotatedSliderView *)pageScrubberView didSelectPageAtIndex:(NSUInteger)pageIndex {
	NSLog(@"%s: %d", __PRETTY_FUNCTION__, pageIndex);
}

#pragma mark -
#pragma mark ARAnnotatedSliderViewDataSource methods

- (NSUInteger)numberOfPagesInPageScrubberView:(ARAnnotatedSliderView *)pageScrubberView {
	return 100;
}


@end
