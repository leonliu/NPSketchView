//
//  NPShape.m
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import "NPShape.h"

static inline CGPoint middlePoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - NPPen

@implementation NPPen

@synthesize lineColor = _lineColor;
@synthesize lineWeight = _lineWeight;
@synthesize lineType = _lineType;
@synthesize alpha = _alpha;
@synthesize fillColor = _fillColor;


- (id)init
{
    if ((self = [super init])) {
        self.lineCapStyle = kCGLineCapRound;
        self.lineJoinStyle = kCGLineJoinRound;
    }
    
    return self;
}

- (void)moveToStartPoint:(CGPoint)point
{
    [self moveToPoint:point];
}

- (void)updateFromPoint:(CGPoint)prevPoint toPoint:(CGPoint)currPoint
{
    [self addQuadCurveToPoint:middlePoint(prevPoint, currPoint) controlPoint:prevPoint];
}

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
    // always draw in current context
    [self.lineColor setStroke];
    [self setLineWidth:self.lineWeight];
    
    if (self.lineType == NPDashedLine) {
        CGFloat pattern[2] = { 6.0, 3.0 };
        [self setLineDash:pattern count:2 phase:0.f];
    }
    
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.alpha];
}

@end

#pragma mark - NPLine

@implementation NPLine
{
    CGPoint _startPoint;
    CGPoint _endPoint;
}

@synthesize lineColor = _lineColor;
@synthesize lineWeight = _lineWeight;
@synthesize lineType = _lineType;
@synthesize alpha = _alpha;
@synthesize fillColor = _fillColor;

- (void)moveToStartPoint:(CGPoint)point
{
    _startPoint = point;
}

- (void)updateFromPoint:(CGPoint)prevPoint toPoint:(CGPoint)currPoint
{
    _endPoint = currPoint;
}

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, self.lineWeight);
    CGContextSetAlpha(ctx, self.alpha);
    if (self.lineType == NPDashedLine) {
        CGFloat pattern[2] = { 5.0f, 5.0f };
        CGContextSetLineDash(ctx, 3.f, pattern, 2);
    }
    
    CGContextMoveToPoint(ctx, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(ctx, _endPoint.x, _endPoint.y);
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

@end

#pragma mark - NPRectangle

@implementation NPRectangle
{
    CGPoint _startPoint;
    CGPoint _endPoint;
}

@synthesize lineColor = _lineColor;
@synthesize lineWeight = _lineWeight;
@synthesize lineType = _lineType;
@synthesize alpha = _alpha;
@synthesize fillColor = _fillColor;

- (void)moveToStartPoint:(CGPoint)point
{
    _startPoint = point;
}

- (void)updateFromPoint:(CGPoint)prevPoint toPoint:(CGPoint)currPoint
{
    _endPoint = currPoint;
}

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGRect area = CGRectMake(_startPoint.x, _startPoint.y, _endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWeight);
    CGContextSetAlpha(ctx, self.alpha);
    
    if (self.fillColor) {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillRect(ctx, area);
    }
    
    if (self.lineType == NPDashedLine) {
        CGFloat pattern[2] = { 6.0f, 2.0f };
        CGContextSetLineDash(ctx, 0.f, pattern, 2);
    }
    CGContextStrokeRect(ctx, area);
    
    CGContextRestoreGState(ctx);
}

@end

#pragma mark - NPEllipse

@implementation NPEllipse
{
    CGPoint _startPoint;
    CGPoint _endPoint;
}

@synthesize lineColor = _lineColor;
@synthesize lineWeight = _lineWeight;
@synthesize lineType = _lineType;
@synthesize alpha = _alpha;
@synthesize fillColor = _fillColor;

- (void)moveToStartPoint:(CGPoint)point
{
    _startPoint = point;
}

- (void)updateFromPoint:(CGPoint)prevPoint toPoint:(CGPoint)currPoint
{
    _endPoint = currPoint;
}

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGRect area = CGRectMake(_startPoint.x, _startPoint.y, _endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWeight);
    CGContextSetAlpha(ctx, self.alpha);
    
    if (self.fillColor) {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillEllipseInRect(ctx, area);
    }
    
    if (self.lineType == NPDashedLine) {
        CGFloat pattern[2] = { 6.0f, 2.0f };
        CGContextSetLineDash(ctx, 0.f, pattern, 2);
    }
    
    CGContextStrokeEllipseInRect(ctx, area);
    CGContextRestoreGState(ctx);
}

@end

