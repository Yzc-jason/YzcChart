//
//  ViewController.m
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "ViewController.h"
#import "YzcChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    YzcChartView *view = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 100,  self.view.frame.size.width, 300)];
    view.isdrawLine = NO;
    view.isDrawPoint = YES;
    view.yLabels = @[@"60",@"120",@"140",@"180",@"60"];
    view.xLabels = @[@"0min",@"30min",@"60min",@"90min",@"120min"];
    [view strokeChart];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
