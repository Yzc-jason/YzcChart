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
#import "YzcConfigModel.h"

typedef NS_ENUM (NSInteger, YzcChartStyle){
    YzcChartStyleLine = 0,
    YzcChartStyleBar
};

@class YzcChartView;

@protocol YzcChartDataSource <NSObject>

@required
///横坐标标题数组
- (NSMutableArray *)chartConfigAxisXValue:(YzcChartView *)chart;

///数值数组
- (NSMutableArray *)chartConfigAxisYValue:(YzcChartView *)chart;

@optional
///显示数值范围
- (CGRange)chartRange:(YzcChartView *)chart;


/**
 图表效果配置

 @param chart chart
 @return 配置model
 */
- (YzcConfigModel *)chartEffectConfig:(YzcChartView *)chart;

#pragma mark - 柱状图功能

- (NSInteger)barChartTargetValue:(YzcChartView *)chart;

/**
 柱状图样式

 @param chart chart
 @return bool
 */
- (BarChartStyle)barChartStyle:(YzcChartView *)chart;

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

@property (nonatomic, strong) UIFont *textFont;

- (id)initWithFrame:(CGRect)rect dataSource:(id<YzcChartDataSource>)dataSource style:(YzcChartStyle)style;

- (void)showInView:(UIView *)view;

@end
