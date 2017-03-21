//
//  YzcConfigModel.h
//  YzcChart
//
//  Created by zs-pace on 2017/3/21.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YzcConfigModel : NSObject

///折线是否显示数值点
@property (nonatomic, assign) BOOL lineChartIsDrawPoint;
///涉嫌是否显示渐变色
@property (nonatomic, assign) BOOL lineChartIsShadow;
///折线的颜色
@property (nonatomic, strong) UIColor *lineChartLineColor;
///折线 横线的颜色
@property (nonatomic, strong) UIColor *lineChartHorizontalLinecColor;
///折线 数值点的颜色
@property (nonatomic, strong) UIColor *lineChartValuePointColor;

///柱状条的颜色
@property (nonatomic, strong) UIColor *barColor;
///柱状超过目标值的颜色
@property (nonatomic, strong) UIColor *barChartAchieveTargetColor;
///柱状条空数据时的颜色
@property (nonatomic, strong) UIColor *barChartEmptyDataBarColor;
///深睡柱状条颜色
@property (nonatomic, strong) UIColor *barChartLessBarColor;
///横线的颜色
@property (nonatomic, strong) UIColor *barChartHorizontalLinecColor;


@end
