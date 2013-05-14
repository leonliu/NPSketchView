//
//  NPSketchViewController.h
//  NPSketchPadView
//
//  Created by leon on 5/14/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPScrollView.h"
#import "NPSketchView.h"

@interface NPSketchViewController : UIViewController<NPSketchViewDelegate>
{
    NPScrollView *_scrollView;
}

@property (nonatomic, setter = setSketchView:) NPSketchView *sketchView;

@end
