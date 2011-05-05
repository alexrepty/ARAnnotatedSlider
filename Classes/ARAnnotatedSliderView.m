//
//  ARPageScrubberView.m
//  Folio Case
//
//  Created by Alexander Repty on 02.06.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import "ARAnnotatedSliderView.h"
#import "ARAnnotatedSliderBubbleView.h"

NSString *const kARPageScrubberViewKeypathFrame		= @"frame";
NSString *const kARPageScrubberViewKeypathTracking	= @"tracking";

@interface ARAnnotatedSliderView (Private)

- (void)_pageScrubberViewCommonInit;

@end

@implementation ARAnnotatedSliderView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

@dynamic pageIndex;

@synthesize bubbleView = _bubbleView;

#pragma mark -
#pragma mark Construction & Destruction

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self _pageScrubberViewCommonInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self _pageScrubberViewCommonInit];
	}
	return self;
}

- (void)dealloc {
	[_slider release]; _slider = nil;
	self.bubbleView = nil;
	[_bubbleTimer invalidate];
	[_bubbleTimer release]; _bubbleTimer = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark ARPageScrubberView private methods

- (void)_pageScrubberViewCommonInit {
	self.alpha = 0.0f;
	self.hidden = YES;
	
	CGFloat sliderMargin = 10.0f;
	CGRect sliderRect = self.bounds;
	sliderRect.origin.x = sliderMargin;
	sliderRect.size.width -= 2 * sliderMargin;
	_slider = [[UISlider alloc] initWithFrame:sliderRect];
	_slider.minimumValue = 0.0f;
	_slider.maximumValue = 0.0f;
	_slider.continuous = NO;
	[_slider addTarget:self action:@selector(_sliderDidChangeValue:) forControlEvents:UIControlEventValueChanged];
	_slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_slider.contentMode = UIViewContentModeScaleAspectFit;
	_slider.clipsToBounds = YES;

	[self addSubview:_slider];

	sliderMargin += 15.0f;
	sliderRect.origin.x = sliderMargin;
	sliderRect.size.width = self.bounds.size.width - 2 * sliderMargin;

	CGRect bubbleFrame = CGRectZero;
	bubbleFrame.size.width = 100.0f;
	bubbleFrame.size.height = 44.0f;

	ARAnnotatedSliderBubbleView *bubbleView = [[ARAnnotatedSliderBubbleView alloc] initWithFrame:bubbleFrame];
	[self addSubview:bubbleView];
	[self bringSubviewToFront:bubbleView];
        bubbleView.hidden = YES;
	self.bubbleView = bubbleView;
	[bubbleView release]; bubbleView = nil;
	
	self.bubbleView.alpha = 0.0f;
}

- (void)_sliderDidChangeValue:(id)sender {
	[self.delegate pageScrubberView:self didSelectPageAtIndex:self.pageIndex];
}

#pragma mark -
#pragma mark Dynamic properties

- (void)setDataSource:(id<ARAnnotatedSliderViewDataSource>)aDataSource {
	_dataSource = aDataSource;
	[self reloadData];
}

- (NSUInteger)pageIndex {
	return round(_slider.value);
}

- (void)setPageIndex:(NSUInteger)value {
	[_slider setValue:value animated:YES];
}

#pragma mark -
#pragma mark ARPageScrubberView methods

- (void)reloadData {
	_slider.maximumValue = [self.dataSource numberOfPagesInPageScrubberView:self] - 1;
}

- (void)show:(BOOL)animated {
	self.alpha = 0.0f;
	self.hidden = NO;
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	
	self.alpha = 1.0f;
	
	if (animated) {
		[UIView commitAnimations];
	}
	
	if ([_slider.subviews count] < 3) {
		return;
	}
	
	UIImageView *thumbImageView = (UIImageView *)[_slider.subviews objectAtIndex:2];
	if (![thumbImageView isKindOfClass:[UIImageView class]]) {
		return;
	}
	
	[thumbImageView addObserver:self forKeyPath:kARPageScrubberViewKeypathFrame options:NSKeyValueChangeReplacement context:(void *)thumbImageView];
	[_slider addObserver:self forKeyPath:kARPageScrubberViewKeypathTracking options:NSKeyValueChangeReplacement context:(void *)thumbImageView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	UIImageView *thumbImageView = (UIImageView *)context;
	
	if ([keyPath isEqualToString:kARPageScrubberViewKeypathFrame]) {
		self.bubbleView.pageNumber = self.pageIndex + 1;
		CGRect bubbleViewFrame = self.bubbleView.frame;
		bubbleViewFrame.origin.x = thumbImageView.frame.origin.x - round(bubbleViewFrame.size.width / 2) + _slider.frame.origin.x + round(thumbImageView.frame.size.width / 2);
		bubbleViewFrame.origin.y = thumbImageView.frame.origin.y - bubbleViewFrame.size.height;
		self.bubbleView.frame = bubbleViewFrame;
		if (self.bubbleView.hidden && _slider.tracking) {
			[self.bubbleView show:YES];
		}
	} else if ([keyPath isEqualToString:kARPageScrubberViewKeypathTracking]) {
		if (_slider.tracking) {
			if (self.bubbleView.hidden) {
				[self.bubbleView show:YES];
			}
			return;
		} else {
			[_slider setValue:self.pageIndex animated:YES];
		}
		
		if (nil != _bubbleTimer) {
			[_bubbleTimer invalidate];
			[_bubbleTimer release]; _bubbleTimer = nil;
		}
		
		_bubbleTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.25f] interval:0.0f target:self.bubbleView selector:@selector(hide) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:_bubbleTimer forMode:NSDefaultRunLoopMode];
	}
}

- (void)hide:(BOOL)animated {
	self.alpha = 1.0f;
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop)];
	}
	
	self.alpha = 0.0f;
	
	if (animated) {
		[UIView commitAnimations];
	} else {
		self.hidden = YES;
	}
}

- (void)hideAnimationDidStop {
	self.hidden = YES;

	if ([_slider.subviews count] < 3) {
		return;
	}
	
	UIImageView *thumbImageView = (UIImageView *)[_slider.subviews objectAtIndex:2];
	if (![thumbImageView isKindOfClass:[UIImageView class]]) {
		return;
	}
	
	@try {
		[thumbImageView removeObserver:self forKeyPath:kARPageScrubberViewKeypathFrame];
		[_slider removeObserver:self forKeyPath:kARPageScrubberViewKeypathTracking];
	}
	@catch (NSException * e) {
		// ignore "cannot remove observer" exceptions
	}
}

@end
