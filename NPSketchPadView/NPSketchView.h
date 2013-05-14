//
//  NPSketchView.h
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPShape.h"


@protocol NPSketchViewDelegate;
@interface NPSketchView : UIView
{
    
}

@property (nonatomic, weak) IBOutlet id<NPSketchViewDelegate> delegate;
@property (nonatomic) NPShapeType shapeType;
@property (nonatomic, strong, setter = setImage:) IBOutlet UIImage *image;
@property (nonatomic, strong, readonly) UIImage *canvasImage;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic) NPLineType lineType;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat alpha;

- (BOOL)isUndoEnabled;
- (BOOL)isRedoEnabled;

- (void)undo;
- (void)redo;
- (void)clear;

@end


@protocol NPSketchViewDelegate <NSObject>

@optional
- (void)sketchView:(NPSketchView *)sketch willDrawShape:(id<NPShape>)shape;
- (void)sketchView:(NPSketchView *)sketch didDrawShape:(id<NPShape>)shape;

@end
