//
//  ViewController.m
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "ViewController.h"
#import "YzcLineChart.h"
#import "YzcBarChart.h"
#import "YzcChartView.h"

@interface ViewController ()<YzcChartDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];

    YzcChartView *chartView = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleLine];
    chartView.tag             = 100;
    chartView.intervalValue   = 6;
    chartView.unitString      = @"(步)";
    chartView.isShowLastValue = YES;
    [chartView showInView:self.scrollView];

    YzcChartView *chartView2 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    chartView2.intervalValue   = 1;
    chartView2.tag             = 200;
    chartView2.unitString      = @"(步)";
    chartView2.isShowLastValue = YES;
    [chartView2 showInView:self.scrollView];


    YzcChartView *chartView3 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 500, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    chartView3.intervalValue = 6;
    chartView3.tag           = 300;
    chartView3.isShowLastValue = YES;
    [chartView3 showInView:self.scrollView];

    YzcChartView *chartView4 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 700, self.view.frame.size.width-30, 150) dataSource:self style:YzcChartStyleBar];
    chartView4.tag           = 400;
    chartView4.isShowLastValue = YES;
    [chartView4 showInView:self.scrollView];


    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(chartView4.frame)+40);
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - YzcChartDataSource
- (NSMutableArray *)chartConfigAxisXValue:(YzcChartView *)chart {
    NSMutableArray *x = [NSMutableArray array];

    switch (chart.tag) {
    case 100:
        for (int i = 0; i < 30; i++) {
//            if (i == 0) {
//                [x addObject:@"6月24日"];
//            }else if ( i== 29){
//                [x addObject:@"今日"];
//            }else{
//                
                [x addObject:[NSString stringWithFormat:@"%zd", i]];
//            }
        }
        break;
    case 200:
        for (int i = 0; i <7; i++) {
            if (i%2 == 0) {
                [x addObject:[NSString stringWithFormat:@"%zd", i]];
            }else{
                
                [x addObject:[NSString stringWithFormat:@"%zd", i]];
            }
        }
        break;

    case 300:
        for (int i = 0; i < 30; i++) {
            [x addObject:[NSString stringWithFormat:@"%zd", i]];
        }
        break;

    case 400:
        for (int i = 0; i < 10; i++) {
            [x addObject:[NSString stringWithFormat:@"%zd", i]];
        }
        break;

    default:
        break;
    }

    return x;
}

- (NSMutableArray *)chartConfigAxisYValue:(YzcChartView *)chart {
    NSMutableArray *y = [NSMutableArray array];

    switch (chart.tag) {
    case 100:
        for (int i = 0; i < 30; i++) {
            [y addObject:[NSNumber numberWithInt:[self getRandomNumber:0 to:100]]];
        }
        break;

    case 200:
        for (int i = 0; i < 7; i++) {
                [y addObject:[NSNumber numberWithInt:[self getRandomNumber:0 to:10000]]];
        }
        break;

    case 300:
        for (int i = 0; i < 30; i++) {
            BarChartModel *model = [[BarChartModel alloc] init];
            model.SleepTimeLong = 8;
            model.deepTimeLong  = [self getRandomNumber:1 to:8];
            [y addObject:model];
        }
        break;

    case 400:
        for (int i = 0; i < 10; i++) {
            BarChartModel *model = [[BarChartModel alloc] init];
            model.maxlValue = [self getRandomNumber:100 to:151];
            model.minValue  = [self getRandomNumber:0 to:70];
            [y addObject:model];
        }
        break;

    default:
        break;
    }

    return y;
}

- (CGRange)chartRange:(YzcChartView *)chart {
    CGRange rang = CGRangeMake(0, 0);

    switch (chart.tag) {
    case 100:
        rang = CGRangeMake(100, 0);
        break;
    case 200:
        rang = CGRangeMake(20000, 0);
        break;

    case 300:
        rang = CGRangeMake(12, 0);
        break;

    case 400:
        rang = CGRangeMake(150, 0);
        break;
    }
    return rang;
}

- (YzcConfigModel *)chartEffectConfig:(YzcChartView *)chart {
    YzcConfigModel *model = [[YzcConfigModel alloc] init];

    if (chart.tag == 100) {
        UIColor *color = [UIColor colorWithRed:251/255.0 green:219/255.0 blue:92/255.0 alpha:1];
        model.lineChartIsShadow             = YES;
        model.lineChartIsDrawPoint          = YES;
        model.lineChartValuePointColor      = color;
        model.lineChartHorizontalLinecColor = color;
        model.lineChartLineColor            = color;
//        model.lineChartIsShowMaxMinVlaue = YES;
        
         
    } else {
        model.barChartLessBarColor         = [UIColor blueColor];
//        model.barChartHorizontalLinecColor = [UIColor grayColor];
        model.barChartAchieveTargetColor   = [[UIColor blueColor] colorWithAlphaComponent: 0.5];
        model.barChartEmptyDataBarColor    = [[UIColor blueColor] colorWithAlphaComponent: 0.5];
        model.barColor                     = [UIColor colorWithRed:251/255.0 green:219/255.0 blue:92/255.0 alpha:1];
       
    }

    return model;
}

- (BarChartStyle)barChartStyle:(YzcChartView *)chart {
    if (chart.tag == 300) {
        return BarChartStyleSleep;
    } else if (chart.tag == 400) {
        return BarChartStyleRateRange;
    }
    return BarChartStyleNormal;
}

- (NSInteger)barChartTargetValue:(YzcChartView *)chart {
    if (chart.tag == 200) {
        return 8000;
    }else if (chart.tag == 300) {
        return 8;
    }
    return 0;
}

@end
