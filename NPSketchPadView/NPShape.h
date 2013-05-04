//
//  NPShape.h
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NPShapeTypePen,
    NPShapeTypeLine,
    NPShapeTypeRectangle,
    NPShapeTypeEllipse,
    NPShapeTypeMax   // pseudo shape type
} NPShapeType;

typedef enum {
    NPSolidLine,
    NPDashedLine
} NPLineType;

@protocol NPShape <NSObject>

@property UIColor *lineColor;
@property CGFloat lineWeight;
@property NPLineType lineType;
@property UIColor *fillColor;
@property CGFloat alpha;

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx;
- (void)moveToStartPoint:(CGPoint)point;
- (void)updateFromPoint:(CGPoint)prevPoint toPoint:(CGPoint)currPoint;

@end

@interface NPPen : UIBezierPath<NPShape>

@end

@interface NPLine : NSObject<NPShape>

@end

@interface NPRectangle : NSObject<NPShape>

@end

@interface NPEllipse : NSObject<NPShape>

@end
