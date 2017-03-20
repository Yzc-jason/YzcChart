//
//  YzcChartView.m
//  YzcChart
//
//  Created by zs-pace on 2017/3/16.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import "YzcChartView.h"

@interface YzcChartView ()

@property (assign, nonatomic) id<YzcChartDataSource> dataSource;

@property (strong, nonatomic) YzcLineChart *lineChart;

@property (strong, nonatomic) YzcBarChart *barChart;

@end

@implementation YzcChartView


- (id)initWithFrame:(CGRect)rect dataSource:(id<YzcChartDataSource>)dataSource style:(YzcChartStyle)style {
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setUpChart {
    if (self.chartStyle == YzcChartStyleLine) {
        if (!self.lineChart) {
            self.lineChart = [[YzcLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:self.lineChart];
        }

        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [self.lineChart setChooseRange:[self.dataSource chartRange:self]];
        }

        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(lineChartRelatedColor:)]) {
            NSArray *colors = [self.dataSource lineChartRelatedColor:self];
            for (int i = 0; i < colors.count; i++) {
                UIColor *color = colors[i];
                switch (i) {
                case 0:
                    self.lineChart.lineColor = color;
                    break;
                case 1:
                    self.lineChart.HorizontalLinecColor = color;
                    break;
                case 2:
                    self.lineChart.pointColor = color;
                    break;

                default:
                    break;
                }
            }
        }

        //相关样式设置
        if ([self.dataSource respondsToSelector:@selector(lineChartRelatedBool:)]) {
            NSArray *settings = [self.dataSource lineChartRelatedBool:self];
            for (int i = 0; i < settings.count; i++) {
                BOOL state = [settings[i] integerValue];
                switch (i) {
                case 0:
                    self.lineChart.isDrawPoint = state;
                    break;
                case 1:
                    self.lineChart.isShadow = state;
                    break;

                default:
                    break;
                }
            }
        }

        self.lineChart.isHiddenLastValue = self.isShowLastValue;
        self.lineChart.isHiddenUnit      = self.isHiddenUnit ? self.isHiddenUnit : YES;
        self.lineChart.unitString        = self.unitString;
        self.lineChart.intervalValue     = self.intervalValue ? self.intervalValue : 1;
        [self.lineChart setYLabels:[self.dataSource chartConfigAxisYValue:self]];
        [self.lineChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];

        [self.lineChart strokeChart];
    } else if (self.chartStyle == YzcChartStyleBar) {
        if (!self.barChart) {
            self.barChart = [[YzcBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:self.barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [self.barChart setChooseRange:[self.dataSource chartRange:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(barChartRelatedColor:)]) {
            NSArray *colors = [self.dataSource barChartRelatedColor:self];
            for (int i = 0; i < colors.count; i++) {
                UIColor *color = colors[i];
                switch (i) {
                case 0:
                    self.barChart.barColor = color;
                    break;
                case 1:
                    self.barChart.achieveTargetColor = color;
                    break;
                case 2:
                    self.barChart.emptyDataBarColor = color;
                    break;
                case 3:
                    self.barChart.lessBarColor = color;
                    break;
                case 4:
                    self.barChart.HorizontalLinecColor = color;
                    break;
                default:
                    break;
                }
            }
        }
        if ([self.dataSource respondsToSelector:@selector(barChartTargetValue:)]) {
            self.barChart.targetValue = [self.dataSource barChartTargetValue:self];
        }
        if ([self.dataSource respondsToSelector:@selector(barChartSleepStyle:)]) {
            self.barChart.style = [self.dataSource barChartSleepStyle:self];
        }

        self.barChart.isShowLastValue = self.isShowLastValue;
        self.barChart.isHiddenUnit      = self.isHiddenUnit ? self.isHiddenUnit : YES;
        self.barChart.unitString        = self.unitString;
        self.barChart.intervalValue     = self.intervalValue;
        [self.barChart setYLabels:[self.dataSource chartConfigAxisYValue:self]];
        [self.barChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];

        [self.barChart strokeChart];
    }
}

- (void)showInView:(UIView *)view {
    [self setUpChart];
    [view addSubview:self];
}

- (void)strokeChart {
    [self setUpChart];
}

@end
