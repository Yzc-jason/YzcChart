//
//  YzcChartView.h
//  YzcChart
//
//  Created by zs-pace on 2017/3/16.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YzcBarChart.h"
#import "YzcLineChart.h"
#import "BarChartModel.h"

typedef NS_ENUM (NSInteger, YzcChartStyle){
    YzcChartStyleLine = 0,
    YzcChartStyleBar
};

@class YzcChartView;

@protocol YzcChartDataSource <NSObject>

@required
///横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(YzcChartView *)chart;

///数值数组
- (NSArray *)chartConfigAxisYValue:(YzcChartView *)chart;

@optional
///显示数值范围
- (CGRange)chartRange:(YzcChartView *)chart;

#pragma mark - 折线图功能
/**
 折线图表相关颜色

 @param chart chart
 @return 1.折线的颜色 2.横线的颜色 3.点的颜色
 */
- (NSArray *)lineChartRelatedColor:(YzcChartView *)chart;

/**
 设置图表相关bool

 @param chart chart
 @return 1.是否数值点 2.是否显示渐变
 */
- (NSArray *)lineChartRelatedBool:(YzcChartView *)chart;

#pragma mark - 柱状图功能
/**
 /柱状图表相关颜色

 @param chart chart
 @return  1.柱装条的颜色 2.达标值颜色 3.柱状条空数据时的颜色 4.深睡柱状图颜色 5.心率图表横线颜色
 */
- (NSArray *)barChartRelatedColor:(YzcChartView *)chart;

- (NSInteger)barChartTargetValue:(YzcChartView *)chart;

/**
 是否是睡眠样式

 @param chart chart
 @return bool
 */
- (BarChartStyle)barChartSleepStyle:(YzcChartView *)chart;

@end


@interface YzcChartView : UIView

@property (nonatomic, assign) YzcChartStyle chartStyle;
///左上角显示单位(未国际化)
@property (copy, nonatomic) NSString *unitString;
///是否显示左上角单位，默认隐藏
@property (nonatomic, assign) BOOL isHiddenUnit;
///最后一个数值是否显示在柱状上面,默认隐藏
@property (nonatomic, assign) BOOL isShowLastValue;
///横坐标显示间隔数
@property (nonatomic, assign) NSInteger intervalValue;

- (id)initWithFrame:(CGRect)rect dataSource:(id<YzcChartDataSource>)dataSource style:(YzcChartStyle)style;

- (void)showInView:(UIView *)view;
    
- (void)strokeChart;

@end
