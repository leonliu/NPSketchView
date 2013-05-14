//
//  NPSketchViewController.m
//  NPSketchPadView
//
//  Created by leon on 5/14/13.
//  Copyright (c) 2013 leon. All rights reserved.
//

#import "NPSketchViewController.h"

@interface NPSketchViewController ()

@end

@implementation NPSketchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    _scrollView = [[NPScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSketchView:(NPSketchView *)sketchView
{
    _sketchView = sketchView;
    [_scrollView addSubview:sketchView];
    if (sketchView.image) {
        CGSize size = [sketchView.image size];
        [_scrollView setContentSize:size];
    }
}

@end
