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

    YzcChartView *chartView = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 100, 350, 200) dataSource:self style:YzcChartStyleLine];
    chartView.tag             = 100;
    chartView.intervalValue   = 4;
    chartView.isShowLastValue = NO;
    [chartView showInView:self.scrollView];

    YzcChartView *chartView2 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    chartView2.intervalValue   = 4;
    chartView2.tag             = 200;
    chartView2.isShowLastValue = NO;
    [chartView2 showInView:self.scrollView];


    YzcChartView *chartView3 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 500, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    chartView3.intervalValue = 4;
    chartView3.tag           = 300;    [chartView3 showInView:self.scrollView];

    YzcChartView *chartView4 = [[YzcChartView alloc] initWithFrame:CGRectMake(10, 700, self.view.frame.size.width-30, 200) dataSource:self style:YzcChartStyleBar];
    chartView4.intervalValue = 1;
    chartView4.tag           = 400;
    [chartView4 showInView:self.scrollView];


    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(chartView4.frame)+40);
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - YzcChartDataSource
- (NSArray *)chartConfigAxisXLabel:(YzcChartView *)chart {
    NSMutableArray *x = [NSMutableArray array];

    switch (chart.tag) {
    case 100:
        for (int i = 0; i < 25; i++) {
            [x addObject:[NSString stringWithFormat:@"%zd", i]];
        }
        break;
    case 200:
        for (int i = 0; i < 31; i++) {
            [x addObject:[NSString stringWithFormat:@"%zd", i]];
        }
        break;

    case 300:
        for (int i = 0; i < 31; i++) {
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

    return (NSArray *)x;
}

- (NSArray *)chartConfigAxisYValue:(YzcChartView *)chart {
    NSMutableArray *y = [NSMutableArray array];

    switch (chart.tag) {
    case 100:
        for (int i = 0; i < 25; i++) {
            [y addObject:[NSNumber numberWithInt:arc4random()%100]];
        }
        break;

    case 200:
        for (int i = 0; i < 31; i++) {
            [y addObject:[NSNumber numberWithInt:[self getRandomNumber:1000 to:10000]]];
        }
        break;

    case 300:
        for (int i = 0; i < 31; i++) {
            BarChartModel *model = [[BarChartModel alloc] init];
            model.SleepTimeLong = [self getRandomNumber:4 to:8];
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

    return (NSArray *)y;
}

- (CGRange)chartRange:(YzcChartView *)chart {
    CGRange rang;

    switch (chart.tag) {
    case 100:
        rang = CGRangeMake(100, 0);
        break;
    case 200:
        rang = CGRangeMake(10000, 1000);
        break;

    case 300:
        rang = CGRangeMake(12, 0);
        break;

    case 400:
        rang = CGRangeMake(150, 0);
        break;


    default:
        break;
    }
    return rang;
}

///设置图表相关bool 1.是否数值点 2.是否显示渐变
- (NSArray *)lineChartRelatedBool:(YzcChartView *)chart {
    return @[@"1", @"1"];
}

//折线图表相关颜色 1.折线的颜色 2.横线的颜色 3.点的颜色
- (NSArray *)lineChartRelatedColor:(YzcChartView *)chart {
    UIColor *color = [UIColor colorWithRed:251/255.0 green:219/255.0 blue:92/255.0 alpha:1];

    return @[color, color, color];
}

///柱状图表相关颜色 1.柱装条的颜色 2.达标值颜色  3.柱状条空数据时的颜色 4.深睡柱状图颜色 5.心率图表横线颜色
- (NSArray *)barChartRelatedColor:(YzcChartView *)chart {
    return @[[UIColor colorWithRed:251/255.0 green:219/255.0 blue:92/255.0 alpha:1], [UIColor redColor], [UIColor clearColor], [UIColor blueColor], [UIColor grayColor]];
}

- (BarChartStyle)barChartSleepStyle:(YzcChartView *)chart {
    if (chart.tag == 300) {
        return BarChartStyleSleep;
    } else if (chart.tag == 400) {
        return BarChartStyleRateRange;
    }
    return BarChartStyleNormal;
}

- (NSInteger)barChartTargetValue:(YzcChartView *)chart {
    if (chart.tag == 200) {
        return 8500;
    }
    return 0;
}

@end
