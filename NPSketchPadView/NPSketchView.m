//
//  NPSketchView.m
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import "NPSketchView.h"

static inline UIColor *defaultLineColor()
{
    return [UIColor blackColor];
}

static inline UIColor *defaultFillColor()
{
    return [UIColor whiteColor];
}

static CGPoint prevPosition = {0.f, 0.f};

#define kDefaultLineWidth   3.0f
#define kDefaultAlpha       1.0f

@interface NPSketchView()

- (id)shapeWithType:(NPShapeType)type;
- (void)updateCanvas:(BOOL)fullUpdate;
- (void)gestureRecognizerFired:(UIPanGestureRecognizer *)sender;

@end

@implementation NPSketchView
{
    NSMutableArray *_undoQueue;
    NSMutableArray *_redoQueue;
    id<NPShape> _shape;
}

@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize canvasImage = _canvasImage;
@synthesize shapeType = _shapeType;
@synthesize lineColor = _lineColor;
@synthesize fillColor = _fillColor;
@synthesize lineWidth = _lineWidth;
@synthesize lineType = _lineType;
@synthesize alpha = _alpha;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = nil;
        _image = nil;
        _undoQueue = [NSMutableArray array];
        _redoQueue = [NSMutableArray array];
        _lineColor = defaultLineColor();
        _fillColor = nil;
        _lineWidth = kDefaultLineWidth;
        _lineType = NPSolidLine;
        _alpha = kDefaultAlpha;
        
        
        UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerFired:)];
        [self addGestureRecognizer:gr];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        _delegate = nil;
        _image = nil;
        _undoQueue = [NSMutableArray array];
        _redoQueue = [NSMutableArray array];
        _lineColor = defaultLineColor();
        _fillColor = nil;
        _lineWidth = kDefaultLineWidth;
        _lineType = NPSolidLine;
        _alpha = kDefaultAlpha;
        
        UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerFired:)];
        [self addGestureRecognizer:gr];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _canvasImage = image;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [_canvasImage drawInRect:rect];
    [_shape drawInRect:rect context:ctx];
}

#pragma -
#pragma mark - private methods
- (id)shapeWithType:(NPShapeType)type
{
    id<NPShape> ret = nil;
    
    switch (type) {
        case NPShapeTypePen:
            ret = [[NPPen alloc] init];
            break;
        case NPShapeTypeLine:
            ret = [[NPLine alloc] init];
            break;
        case NPShapeTypeRectangle:
            ret = [[NPRectangle alloc] init];
            break;
        case NPShapeTypeEllipse:
            ret = [[NPEllipse alloc] init];
            break;
            
        default:
            NSLog(@"unknown shape type: %d", type);
            break;
    }
    
    if (ret) {
        ret.lineColor = self.lineColor;
        ret.lineWeight = self.lineWidth;
        ret.fillColor = self.fillColor;
        ret.lineType = self.lineType;
        ret.alpha = self.alpha;
    }
    
    return ret;
}

- (void)updateCanvas:(BOOL)fullUpdate
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (fullUpdate) {
        _canvasImage = self.image;
        
        [_canvasImage drawInRect:self.bounds];
        for (id<NPShape> operation in _undoQueue) {
            [operation drawInRect:self.bounds context:ctx];
        }
    } else {
        [_canvasImage drawInRect:self.bounds];
        [_shape drawInRect:self.bounds context:ctx];
    }
    
    _canvasImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


#pragma mark - touches methods
- (void)gestureRecognizerFired:(UIPanGestureRecognizer *)sender
{
    CGPoint pos = [sender locationInView:self];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            // create a new drawing object
            _shape = [self shapeWithType:self.shapeType];
            [_undoQueue addObject:_shape];
            
            [_shape moveToStartPoint:pos];
            
            if (_delegate && [_delegate respondsToSelector:@selector(sketchView:willDrawShape:)]) {
                [_delegate sketchView:self willDrawShape:_shape];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // record the point
            [_shape updateFromPoint:prevPosition toPoint:pos];
            
            // call for drawing
            [self setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_shape updateFromPoint:prevPosition toPoint:pos];
            
            // when a touch ended, we finished one draw operation. We need
            // to upate the canvas with this operation.
            [self updateCanvas:NO];
            
            if (_delegate && [_delegate respondsToSelector:@selector(sketchView:didDrawShape:)]) {
                [_delegate sketchView:self didDrawShape:_shape];
            }
            
            // reset the current draw object since a new object is created
            // in the next round of touches.
            _shape = nil;
            
            // clear the redo queue since we just commit a new operation
            [_redoQueue removeAllObjects];
            
            // call for drawing
            [self setNeedsDisplay];
        }
            break;
            
        default:
            NSLog(@"state=%d", sender.state);
            break;
    }
    
    prevPosition = pos;
}

#pragma -
#pragma mark - public methods

- (BOOL)isUndoEnabled
{
    return (_undoQueue.count > 0);
}

- (BOOL)isRedoEnabled
{
    return (_redoQueue.count > 0);
}

- (void)undo
{
    if (_undoQueue.count > 0) {
        id<NPShape> lastShape = [_undoQueue lastObject];
        [_redoQueue addObject:lastShape];
        [_undoQueue removeObject:lastShape];
        
        // update the canvas to get rid of the last draw object
        [self updateCanvas:YES];
        
        // call for drawing
        [self setNeedsDisplay];
    }
}

- (void)redo
{
    if (_redoQueue.count > 0) {
        id<NPShape> lastShape = [_redoQueue lastObject];
        [_undoQueue addObject:lastShape];
        [_redoQueue removeObject:lastShape];
        
        // update the canvas
        [self updateCanvas:YES];
        
        // call for drawing
        [self setNeedsDisplay];
    }
}

- (void)clear
{
    [_undoQueue removeAllObjects];
    [_redoQueue removeAllObjects];
    [self updateCanvas:YES];
    [self setNeedsDisplay];
}

@end
