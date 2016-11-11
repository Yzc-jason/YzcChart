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
    view.yLabels = @[@"60bpm",@"120bpm",@"140bpm",@"180bpm"];
    view.xLabels = @[@"0min",@"30min",@"60min",@"90min",@"120min",@"140min",@"160min",@"180min",@"200min",@"220min",@"240min",@"260min",@"280min",@"300min",@"320min",@"340min",@"360min",@"380min",@"400min",@"420min"];
    view.yValues = @[@180,@100,@60,@50,@68,@163,@36,@60,@50,@68,@163,@60,@60,@50,@68,@163,@140,@60,@50,@69];
    [view strokeChart];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
