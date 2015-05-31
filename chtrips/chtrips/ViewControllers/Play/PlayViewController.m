//
//  PlayViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSegmentedControl {
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"吃",@"住",@"行"]];
    segmented.frame = CGRectMake(20.0, 20.0, 250, 25);
    segmented.selectedSegmentIndex = 1;
    self.navigationItem.titleView = segmented;
}

@end
