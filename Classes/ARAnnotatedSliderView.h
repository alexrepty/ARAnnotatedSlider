//
//  ARPageScrubberView.h
//  Folio Case
//
//  Created by Alexander Repty on 02.06.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARAnnotatedSliderBubbleView;
@protocol ARAnnotatedSliderViewDelegate;
@protocol ARAnnotatedSliderViewDataSource;

@interface ARAnnotatedSliderView : UIView {
  @package
	id<ARAnnotatedSliderViewDelegate>		_delegate;
	id<ARAnnotatedSliderViewDataSource>	_dataSource;
	
	UISlider							*_slider;
	
	ARAnnotatedSliderBubbleView			*_bubbleView;
	NSTimer								*_bubbleTimer;
}

@property(nonatomic,assign)	IBOutlet id<ARAnnotatedSliderViewDelegate>		delegate;
@property(nonatomic,assign)	IBOutlet id<ARAnnotatedSliderViewDataSource>	dataSource;

@property(nonatomic,assign)	NSUInteger										pageIndex;

@property(nonatomic,retain)	ARAnnotatedSliderBubbleView						*bubbleView;

- (void)reloadData;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end

@protocol ARAnnotatedSliderViewDelegate <NSObject>

- (void)pageScrubberView:(ARAnnotatedSliderView *)pageScrubberView didSelectPageAtIndex:(NSUInteger)pageIndex;

@end

@protocol ARAnnotatedSliderViewDataSource <NSObject>

- (NSUInteger)numberOfPagesInPageScrubberView:(ARAnnotatedSliderView *)pageScrubberView;

@end
