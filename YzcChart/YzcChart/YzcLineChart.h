//
//  YzcChartView.h
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YzcCommonMacros.h"



@interface YzcLineChart : UIView

@property (copy, nonatomic) NSArray *xLabels;
@property (copy, nonatomic) NSArray *yLabels;

@property (nonatomic, assign) BOOL isDrawPoint; /**是否数值点*/
@property (nonatomic, assign) BOOL isShadow; /**是否显示渐变*/
@property (nonatomic, assign) BOOL isHiddenLastValue; /**最后一个数值是否显示在柱状上面,默认隐藏*/
@property (nonatomic, assign) BOOL isHiddenUnit; /**是否显示左上角单位，默认隐藏*/

@property (nonatomic, assign) NSInteger intervalValue;/** x值显示间隔数 */
@property (nonatomic, copy) NSString    *unitString;

@property (nonatomic, strong) UIColor *lineColor; /**折线的颜色*/
@property (nonatomic, strong) UIColor *HorizontalLinecColor; /**横线的颜色*/
@property (nonatomic, strong) UIColor *pointColor; /**点的颜色*/

@property (nonatomic, assign) CGRange chooseRange;


- (void)strokeChart;

@end
