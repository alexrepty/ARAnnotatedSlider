//
//  AnnotatedSliderViewController.h
//  AnnotatedSlider
//
//  Created by Alexander Repty on 24.09.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARAnnotatedSliderView.h"

@interface AnnotatedSliderViewController : UIViewController <ARAnnotatedSliderViewDelegate, ARAnnotatedSliderViewDataSource> {
	ARAnnotatedSliderView	*_sliderView;
	UIImageView				*_folioCaseIconImageView;
}

@property(nonatomic,retain)	IBOutlet	ARAnnotatedSliderView	*sliderView;
@property(nonatomic,retain)	IBOutlet	UIImageView				*folioCaseIconImageView;

- (IBAction)didTapAppIcon:(id)sender;

@end

