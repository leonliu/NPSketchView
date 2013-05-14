//
//  ViewController.h
//  NPSketchPadView
//
//  Created by leon on 4/23/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPSketchView.h"
#import "NPScrollView.h"

@interface ViewController : UIViewController<UIActionSheetDelegate, NPSketchViewDelegate>
{
    int _sliderType;
}
 
@property (strong, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet NPScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NPSketchView *sketchView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *shapeSegControl;

- (IBAction)undoButtonTapped:(id)sender;
- (IBAction)redoButtonTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)segmentValueChanged:(id)sender;
- (IBAction)composeButtonTapped:(id)sender;

@end
