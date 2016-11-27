//
//  YzcBarChart.h
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YzcConst.h"

@interface YzcBarChart : UIView

/**X轴显示数组*/
@property (strong, nonatomic) NSArray * xLabels;
/**y轴数组*/
@property (strong, nonatomic) NSArray * yLabels;
/**是否显示渐变*/
@property (nonatomic, assign) BOOL isShadow;

/**点的颜色*/
@property (nonatomic, strong) UIColor *pointColor;

/**点的颜色*/
@property (nonatomic, strong) UIColor *barColor;

-(void)strokeChart;

@end
