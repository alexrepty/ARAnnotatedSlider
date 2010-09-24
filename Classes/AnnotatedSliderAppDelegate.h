//
//  AnnotatedSliderAppDelegate.h
//  AnnotatedSlider
//
//  Created by Alexander Repty on 24.09.10.
//  Copyright 2010 Enough Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnotatedSliderViewController;

@interface AnnotatedSliderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AnnotatedSliderViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AnnotatedSliderViewController *viewController;

@end

