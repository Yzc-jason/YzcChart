//
//  YzcBarChart.h
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YzcCommonMacros.h"

typedef NS_ENUM (NSInteger, BarChartStyle) {
    BarChartStyleNormal = 0,
    BarChartStyleSleep,
    BarChartStyleRateRange
};

@interface YzcBarChart : UIView

@property (nonatomic, copy) NSMutableArray *xLabels;
@property (nonatomic, copy) NSMutableArray *yLabels;

@property (nonatomic, strong) UIColor *barColor;/**柱装条的颜色*/
@property (nonatomic, strong) UIColor *achieveTargetColor;/**柱装超过目标值的颜色*/
@property (nonatomic, strong) UIColor *emptyDataBarColor; ///柱状条空数据时的颜色
@property (nonatomic, strong) UIColor *lessBarColor;  ///矮柱状条颜色
@property (nonatomic, strong) UIColor *HorizontalLinecColor; /**横线的颜色*/

@property (copy, nonatomic) NSString    *unitString;
@property (nonatomic, assign) NSInteger intervalValue; /** x值间隔数 */
@property (nonatomic, assign) NSInteger targetValue; /**设置目标值，并且绘制目标虚线*/

@property (nonatomic, assign) BOOL isHiddenUnit; /**是否显示左上角单位，默认隐藏*/
@property (nonatomic, assign) BOOL isShowLastValue; /**最后一个数值是否显示在柱状上面,默认隐藏*/


@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BarChartStyle style;

- (void)strokeChart;

@end
