//
//  ARPageScrubberBubbleView.m
//  Folio Case
//
//  Created by Alexander Repty on 05.06.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import "ARAnnotatedSliderBubbleView.h"

CGFloat const kPageScrubberBubbleViewDefaultCornerRadius		= 4.0f;
CGFloat const kPageScrubberBubbleViewDefaultShadowBlur			= 2.0f;
CGFloat const kPageScrubberBubbleViewDefaultArrowHeight			= 10.0f;
CGFloat const kPageScrubberBubbleViewDefaultBorderWidth			= 1.0f;
CGFloat const kPageScrubberBubbleViewDefaultShadowOffsetWidth	= 0.0f;
CGFloat const kPageScrubberBubbleViewDefaultShadowOffsetHeight	= 0.0f;

@interface ARAnnotatedSliderBubbleView (Private)

- (void)_pageScrubberBubbleViewCommonInit;

@end

@implementation ARAnnotatedSliderBubbleView

@synthesize tintColor = _tintColor;
@synthesize strokeColor = _strokeColor;

@synthesize cornerRadius = _cornerRadius;
@synthesize shadowBlur = _shadowBlur;
@synthesize arrowHeight = _arrowHeight;
@synthesize borderWidth = _borderWidth;
@synthesize shadowOffset = _shadowOffset;

@synthesize pageNumberLabel = _pageNumberLabel;
@synthesize pageNumber = _pageNumber;

#pragma mark -
#pragma mark Construction & Destruction

- (id)init {
	if (self = [super init]) {
		[self _pageScrubberBubbleViewCommonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self _pageScrubberBubbleViewCommonInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self _pageScrubberBubbleViewCommonInit];
	}
	return self;
}

- (void)dealloc {
	self.tintColor = nil;
	self.strokeColor = nil;
	self.pageNumberLabel = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark ARPageScrubberBubbleView private methods

- (void)_pageScrubberBubbleViewCommonInit {
	self.backgroundColor = [UIColor clearColor];
	self.tintColor = [UIColor blackColor];
	self.strokeColor = [UIColor darkGrayColor];
	self.cornerRadius = kPageScrubberBubbleViewDefaultCornerRadius;
	self.shadowBlur = kPageScrubberBubbleViewDefaultShadowBlur;
	self.arrowHeight = kPageScrubberBubbleViewDefaultArrowHeight;
	self.borderWidth = kPageScrubberBubbleViewDefaultBorderWidth;
	self.shadowOffset = CGSizeMake(kPageScrubberBubbleViewDefaultShadowOffsetWidth, kPageScrubberBubbleViewDefaultShadowOffsetHeight);
	self.pageNumber = NSNotFound;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowOffset = CGSizeMake(0.0f, -1.0f);
	label.contentMode = UIViewContentModeCenter;
	self.pageNumberLabel = label;
	[self addSubview:label];
	[label release]; label = nil;
}

#pragma mark -
#pragma mark Dynamic properties

- (void)setTintColor:(UIColor *)newTintColor {
	if (newTintColor == _tintColor) {
		return;
	}
	
	[_tintColor release];
	_tintColor = [newTintColor retain];
	
	[self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)newStrokeColor {
	if (newStrokeColor == _strokeColor) {
		return;
	}
	
	[_strokeColor release];
	_strokeColor = [newStrokeColor retain];
	
	[self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)newCornerRadius {
	_cornerRadius = newCornerRadius;
	
	[self setNeedsDisplay];
}

- (void)setShadowBlur:(CGFloat)newShadowBlur {
	_shadowBlur = newShadowBlur;
	
	[self setNeedsDisplay];
}

- (void)setArrowHeight:(CGFloat)newArrowHeight {
	_arrowHeight = newArrowHeight;
	
	[self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)newBorderWidth {
	_borderWidth = newBorderWidth;
	
	[self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)newShadowOffset {
	_shadowOffset = newShadowOffset;
	
	[self setNeedsDisplay];
}

- (void)setPageNumber:(NSUInteger)newPageNumber {
	_pageNumber = newPageNumber;
	self.pageNumberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Page %d", @"Page %d"), self.pageNumber];
}

#pragma mark -
#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToRect(context, rect);
	CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
	CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
	CGContextSetLineWidth(context, self.borderWidth);
	CGContextSetShadow(context, self.shadowOffset, self.shadowBlur);

	CGFloat margin = self.shadowBlur + 1.0f;
	CGRect bubbleRect = CGRectZero;
	bubbleRect.origin.x = margin;
	bubbleRect.origin.y = margin;
	bubbleRect.size.width = self.bounds.size.width - 2 * margin;
	bubbleRect.size.height = self.bounds.size.height - 2 * margin;
	
	CGFloat minX = CGRectGetMinX(bubbleRect);
	CGFloat midX = CGRectGetMidX(bubbleRect);
	CGFloat maxX = CGRectGetMaxX(bubbleRect);
	CGFloat minY = CGRectGetMinY(bubbleRect);
	CGFloat midY = CGRectGetMidY(bubbleRect);
	CGFloat maxY = CGRectGetMaxY(bubbleRect);
	
	CGFloat arrowWidth = round(self.arrowHeight * 1.5f);
	CGPoint arrowLeftPoint = CGPointMake(floor(midX - (arrowWidth / 2)), maxY - self.arrowHeight);
	CGPoint arrowRightPoint = CGPointMake(ceil(midX + (arrowWidth / 2)), maxY - self.arrowHeight);
	CGPoint arrowHeadPoint = CGPointMake(midX, maxY);
	
	CGContextMoveToPoint(context, minX, midY);
	CGContextAddArcToPoint(context, minX, minY, midX, minY, self.cornerRadius);
	CGContextAddArcToPoint(context, maxX, minY, maxX, midY, self.cornerRadius);
	CGContextAddArcToPoint(context, maxX, maxY - self.arrowHeight, arrowRightPoint.x, arrowRightPoint.y, self.cornerRadius);
	CGContextAddLineToPoint(context, arrowRightPoint.x, arrowRightPoint.y);
	CGContextAddLineToPoint(context, arrowHeadPoint.x, arrowHeadPoint.y);
	CGContextAddLineToPoint(context, arrowLeftPoint.x, arrowLeftPoint.y);
	CGContextAddArcToPoint(context, minX, maxY - self.arrowHeight, minX, midY, self.cornerRadius);
	
	CGContextFillPath(context);
	CGContextStrokePath(context);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat margin = self.shadowBlur + self.borderWidth + 1.0f;

	CGRect pageNumberLabelRect = CGRectZero;
	pageNumberLabelRect.origin.x = margin;
	pageNumberLabelRect.origin.y = margin;
	pageNumberLabelRect.size.width = self.bounds.size.width - 2 * margin;
	pageNumberLabelRect.size.height = self.bounds.size.height - 2 * margin - self.arrowHeight;
	self.pageNumberLabel.frame = pageNumberLabelRect;
}

#pragma mark -
#pragma mark ARPageScrubberBubbleView methods

- (void)show:(BOOL)animated {
	self.alpha = 0.0f;
	self.hidden = NO;
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	self.alpha = 1.0f;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)hide:(BOOL)animated {
	self.alpha = 1.0f;
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop)];
		[UIView setAnimationDuration:0.4f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	self.alpha = 0.0f;
	
	if (animated) {
		[UIView commitAnimations];
	} else {
		self.hidden = YES;
	}
}

- (void)hide {
	[self hide:YES];
}

- (void)hideAnimationDidStop {
	self.hidden = YES;
}

@end
