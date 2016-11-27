//
//  ViewController.m
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "ViewController.h"
#import "YzcChartView.h"
#import "YzcBarChart.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:41/255.0 green:44/255.0 blue:49/255.0 alpha:1];
    
    YzcChartView *view = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 100,  self.view.frame.size.width, 200)];
    view.style      = YzcLineGrid;
    view.isdrawLine = YES;
    view.isDrawPoint = YES;
    view.isShadow   = YES;
    view.unit = @"bpm";
    view.lineColor = [UIColor redColor];
    view.pointColor = [UIColor orangeColor];
    view.yLabels = @[@"60",@"70",@"140",@"80",@"120",@"140",@"80",@"120",@"140",@"80",@"120",@"80",@"120",@"80",@"120"];
    view.xLabels = @[@"0min",@"30min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"120min",@"60min",@"90min",@"120min"];
    [view strokeChart];
    [self.view addSubview:view];
    
    
    YzcBarChart *barView = [[YzcBarChart alloc] initWithFrame:CGRectMake(10, 300,  self.view.frame.size.width-30, 200)];
    barView.isShadow   = YES;
    barView.barColor = [UIColor colorWithRed:251/255.0 green:219/255.0 blue:92/255.0 alpha:1];
    barView.yLabels = @[@"120",@"60",@"140",@"80",@"120",@"140",@"80",@"120",@"140",@"80",@"120",@"80",@"120",@"80",@"120",@"20",@"50",@"130"];
    barView.xLabels = @[@"0min",@"30min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"120min",@"60min",@"90min",@"120min"];
    [barView strokeChart];
    [self.view addSubview:barView];
    
    
    YzcChartView *view3 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 500,  self.view.frame.size.width, 200)];
    view3.style      = YzcLineNone;
    view3.isdrawLine = YES;
    view3.isDrawPoint = NO;
    view3.isShadow   = NO;
    view3.unit = @"bpm";
    view3.lineColor = [UIColor redColor];
    //    view.pointColor = [UIColor orangeColor];
    view3.yLabels = @[@"60",@"70",@"140",@"80",@"120",@"140",@"80",@"120",@"140",@"80",@"120",@"80",@"120",@"80",@"120"];
    view3.xLabels = @[@"0min",@"30min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"60min",@"90min",@"120min",@"120min",@"60min",@"90min",@"120min"];
    [view3 strokeChart];
    [self.view addSubview:view3];
    
    
}

@end
