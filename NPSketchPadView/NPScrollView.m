//
//  NPScrollView.m
//  NPSketchPadView
//
//  Created by leon on 5/14/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import "NPScrollView.h"

@implementation NPScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isViewOnly = YES;
    }
    return self;
}

// override points for subclasses to control delivery of touch events to subviews of the scroll view
// called before touches are delivered to a subview of the scroll view. if it returns NO the touches
// will not be delivered to the subview. default returns YES
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    BOOL ret = YES;
    if (self.isViewOnly) {
        ret = NO;
    }
    
    return ret;
}

// called before scrolling begins if touches have already been delivered to a subview of the scroll view.
// if it returns NO the touches will continue to be delivered to the subview and scrolling will not occur
// not called if canCancelContentTouches is NO. default returns YES if view isn't a UIControl
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    BOOL ret = YES;
    if (self.isViewOnly) {
        ret = NO;
    }
    
    return ret;
}


@end
