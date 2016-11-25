//
//  YzcChartView.h
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define chartMargin         10
#define xLabelMargin        15
#define yLabelMargin        15
#define UULabelHeight       20
#define UUYLabelwidth       30
#define UUTagLabelwidth     80

@interface YzcChartView : UIView

/**X轴显示数组*/
@property (strong, nonatomic) NSArray * xLabels;
/**y轴数组*/
@property (strong, nonatomic) NSArray * yLabels;

@property (nonatomic, assign) BOOL isdrawLine;
@property (nonatomic, assign) BOOL isDrawPoint;
/**是否显示渐变*/
@property (nonatomic, assign) BOOL isShadow;

/**y轴显示的单位*/
@property (copy, nonatomic) NSString *unit;
/**折线的颜色*/
@property (nonatomic, strong) UIColor *lineColor;
/**点的颜色*/
@property (nonatomic, strong) UIColor *pointColor;
/**横线的颜色*/
@property (nonatomic, strong) UIColor *xlineColor;
/**竖线的颜色*/
@property (nonatomic, strong) UIColor *yLineColor;


- (void)strokeChart;

@end
