//
//  NPScrollView.h
//  NPSketchPadView
//
//  Created by leon on 5/14/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPScrollView : UIScrollView

@property (nonatomic) BOOL isViewOnly;  // If scroll is enabled, touches are not delivered to sub views.

@end
