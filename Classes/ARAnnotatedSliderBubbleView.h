//
//  ARPageScrubberBubbleView.h
//  Folio Case
//
//  Created by Alexander Repty on 05.06.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARAnnotatedSliderBubbleView : UIView {
	UIColor	*_tintColor;
	UIColor *_strokeColor;
	
	CGFloat _cornerRadius;
	CGFloat _shadowBlur;
	CGFloat _arrowHeight;
	CGFloat _borderWidth;
	CGSize	_shadowOffset;
	
	UILabel		*_pageNumberLabel;
	NSUInteger	_pageNumber;
}

@property(nonatomic,retain)	UIColor	*tintColor;
@property(nonatomic,retain)	UIColor *strokeColor;

@property(nonatomic,assign)	CGFloat	cornerRadius;
@property(nonatomic,assign)	CGFloat shadowBlur;
@property(nonatomic,assign)	CGFloat arrowHeight;
@property(nonatomic,assign)	CGFloat borderWidth;
@property(nonatomic,assign)	CGSize	shadowOffset;

@property(nonatomic,retain)	UILabel		*pageNumberLabel;
@property(nonatomic,assign)	NSUInteger	pageNumber;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide;

@end
