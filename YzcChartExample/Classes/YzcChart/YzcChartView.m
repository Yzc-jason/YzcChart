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

        if ([self.dataSource respondsToSelector:@selector(chartEffectConfig:)]) {
            YzcConfigModel *model = [self.dataSource chartEffectConfig:self];
            self.lineChart.lineColor            = model.lineChartLineColor;
            self.lineChart.HorizontalLinecColor = model.lineChartHorizontalLinecColor;
            self.lineChart.pointColor           = model.lineChartValuePointColor;
            self.lineChart.isDrawPoint          = model.lineChartIsDrawPoint ? model.lineChartIsDrawPoint : YES;
            self.lineChart.isShadow             = model.lineChartIsShadow;
        }

        self.lineChart.isHiddenLastValue = self.isShowLastValue;
        self.lineChart.isHiddenUnit      = self.isHiddenUnit ? self.isHiddenUnit : YES;
        self.lineChart.unitString        = self.unitString;
        self.lineChart.intervalValue     = self.intervalValue ? self.intervalValue : 1;
        [self.lineChart setYLabels:[self.dataSource chartConfigAxisYValue:self]];
        [self.lineChart setXLabels:[self.dataSource chartConfigAxisXValue:self]];

        [self.lineChart strokeChart];
    } else if (self.chartStyle == YzcChartStyleBar) {
        if (!self.barChart) {
            self.barChart = [[YzcBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:self.barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [self.barChart setChooseRange:[self.dataSource chartRange:self]];
        }

        if ([self.dataSource respondsToSelector:@selector(chartEffectConfig:)]) {
            YzcConfigModel *model = [self.dataSource chartEffectConfig:self];
            self.barChart.barColor             = model.barColor;
            self.barChart.achieveTargetColor   = model.barChartAchieveTargetColor;
            self.barChart.emptyDataBarColor    = model.barChartEmptyDataBarColor;
            self.barChart.lessBarColor         = model.barChartLessBarColor;
            self.barChart.HorizontalLinecColor = model.barChartHorizontalLinecColor;
        }

        if ([self.dataSource respondsToSelector:@selector(barChartTargetValue:)]) {
            self.barChart.targetValue = [self.dataSource barChartTargetValue:self];
        }
        if ([self.dataSource respondsToSelector:@selector(barChartStyle:)]) {
            self.barChart.style = [self.dataSource barChartStyle:self];
        }

        self.barChart.isShowLastValue = self.isShowLastValue;
        self.barChart.isHiddenUnit    = self.isHiddenUnit ? self.isHiddenUnit : YES;
        self.barChart.unitString      = self.unitString;
        self.barChart.intervalValue   = self.intervalValue? self.intervalValue : 1;
        [self.barChart setYLabels:[self.dataSource chartConfigAxisYValue:self]];
        [self.barChart setXLabels:[self.dataSource chartConfigAxisXValue:self]];

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
