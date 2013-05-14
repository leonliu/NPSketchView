//
//  ViewController.m
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import "ViewController.h"

#define TAG_LINE_COLOR_ACTION_SHEET         500
#define TAG_LINE_STYLE_ACTION_SHEET         501
#define TAG_SHAPE_TYPE_ACTION_SHEET         502
#define TAG_FILL_COLOR_ACTION_SHEET         503

enum {
    ShowLineWidthSlider,
    ShowAlphaSlider
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slider.hidden = YES;
    [self.view bringSubviewToFront:self.slider];
    
    self.undoButton.enabled = NO;
    self.redoButton.enabled = NO;
    
    UIImage *image = [UIImage imageNamed:@"girl"];
    self.sketchView.delegate = self;
    self.sketchView.image = image;
    self.sketchView.bounds = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    self.scrollView.contentSize = [image size];
    
    NSLog(@"sketch view bounds: w=%f, h=%f", self.sketchView.bounds.size.width, self.sketchView.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateButtonState
{
    self.undoButton.enabled = [self.sketchView isUndoEnabled];
    self.redoButton.enabled = [self.sketchView isRedoEnabled];
}

- (IBAction)undoButtonTapped:(id)sender
{
    [self.sketchView undo];
    [self updateButtonState];
}

- (IBAction)redoButtonTapped:(id)sender
{
    [self.sketchView redo];
    [self updateButtonState];
}

- (IBAction)clearButtonTapped:(id)sender
{
    [self.sketchView clear];
    [self updateButtonState];
}

- (IBAction)sliderValueChanged:(id)sender
{
    if (_sliderType == ShowLineWidthSlider) {
        self.sketchView.lineWidth = self.slider.value;
    } else {
        self.sketchView.alpha = self.slider.value;
    }
}

- (IBAction)segmentValueChanged:(id)sender
{
    switch (self.shapeSegControl.selectedSegmentIndex) {
        case 0:  // line color
        {
            _slider.hidden = YES;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select line color"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
            sheet.tag = TAG_LINE_COLOR_ACTION_SHEET;
            [sheet showInView:self.view];
        }
            break;
        case 1:  // line width
        {
            _sliderType = ShowLineWidthSlider;
            [self.view bringSubviewToFront:self.slider];
            self.slider.hidden = NO;
            self.slider.minimumValue = 1.0f;
            self.slider.maximumValue = 20.f;
            self.slider.value = self.sketchView.lineWidth;
        }
            break;
        case 2:  // line style
        {
            _slider.hidden = YES;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select line style"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Solid", @"Dashed", nil];
            sheet.tag = TAG_LINE_STYLE_ACTION_SHEET;
            [sheet showInView:self.view];
        }
            break;
        case 3:  // shape
        {
            _slider.hidden = YES;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select shape"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Pen", @"Line", @"Rect", @"Ellipse", nil];
            sheet.tag = TAG_SHAPE_TYPE_ACTION_SHEET;
            [sheet showInView:self.view];
        }
            break;
        case 4:  // fill color
        {
            _slider.hidden = YES;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select fill color"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", @"Clear", nil];
            sheet.tag = TAG_FILL_COLOR_ACTION_SHEET;
            [sheet showInView:self.view];
        }
            break;
        case 5:  // alpha
        {
            _sliderType = ShowAlphaSlider;
            
            self.slider.hidden = NO;
            self.slider.minimumValue = 0.1f;
            self.slider.maximumValue = 1.0f;
            self.slider.value = self.sketchView.alpha;
        }
            break;
        default:
            break;
    }
}

- (IBAction)composeButtonTapped:(id)sender
{
    self.scrollView.isViewOnly = !self.scrollView.isViewOnly;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    //@"Black", @"Red", @"Green", @"Blue"
    if (actionSheet.tag == TAG_LINE_COLOR_ACTION_SHEET) {
        
        switch (buttonIndex) {
            case 0:
                self.sketchView.lineColor = [UIColor blackColor];
                break;
            case 1:
                self.sketchView.lineColor = [UIColor redColor];
                break;
            case 2:
                self.sketchView.lineColor = [UIColor greenColor];
                break;
            case 3:
                self.sketchView.lineColor = [UIColor blueColor];
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == TAG_LINE_STYLE_ACTION_SHEET) { //@"Solid", @"Dashed"
        
        switch (buttonIndex) {
            case 0:
                self.sketchView.lineType = NPSolidLine;
                break;
            case 1:
                self.sketchView.lineType = NPDashedLine;
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == TAG_SHAPE_TYPE_ACTION_SHEET) {
        switch (buttonIndex) {
            case 0:
                self.sketchView.shapeType = NPShapeTypePen;
                break;
            case 1:
                self.sketchView.shapeType = NPShapeTypeLine;
                break;
            case 2:
                self.sketchView.shapeType = NPShapeTypeRectangle;
                break;
            case 3:
                self.sketchView.shapeType = NPShapeTypeEllipse;
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == TAG_FILL_COLOR_ACTION_SHEET) {
        //@"Black", @"Red", @"Green", @"Blue", @"Clear"
        switch (buttonIndex) {
            case 0:
                self.sketchView.fillColor = [UIColor blackColor];
                break;
            case 1:
                self.sketchView.fillColor = [UIColor redColor];
                break;
            case 2:
                self.sketchView.fillColor = [UIColor greenColor];
                break;
            case 3:
                self.sketchView.fillColor = [UIColor blueColor];
                break;
            case 4:
                self.sketchView.fillColor = nil;
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - NPSketchViewDelegate methods

- (void)sketchView:(NPSketchView *)sketch willDrawShape:(id<NPShape>)shape
{
    self.slider.hidden = YES;
}

- (void)sketchView:(NPSketchView *)sketch didDrawShape:(id<NPShape>)shape
{
    [self updateButtonState];
}

@end
