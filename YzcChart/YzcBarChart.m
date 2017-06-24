//
//  YzcBarChart.m
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcBarChart.h"
#import "YzcLabel.h"
#import "YzcBar.h"
#import "UIView+Extension.h"
#import "BarChartModel.h"

#define marginLeft 10
#define barWidth   8

@interface YzcBarChart ()

@property (nonatomic) CGFloat              xLabelWidth;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, assign) CGPoint      lastPoint;;
@property (nonatomic, assign) CGPoint      originPoint;
@property (nonatomic, strong) UILabel      *unitLabel;
@property (nonatomic, assign) CGFloat      yValueMax;
@property (nonatomic, assign) CGFloat      yValueMin;
@property (nonatomic, assign) CGFloat      targetPercent;

@end

@implementation YzcBarChart

#pragma mark - lazy
- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YZCLabelwidth, 0, 100, 40)];
        label.text      = self.unitString;
        label.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:label];
        _unitLabel = label;
    }
    return _unitLabel;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myScrollView         = [[UIScrollView alloc]initWithFrame:CGRectMake(YZCLabelwidth, 0, frame.size.width-YZCLabelwidth-10, frame.size.height)];
        self.myScrollView.bounces = NO;
        [self addSubview:self.myScrollView];
        self.isHiddenUnit  = YES;
        self.intervalValue = 1;
    }
    return self;
}

#pragma mark - setter
- (void)setUnitString:(NSString *)unitString {
    _unitString         = unitString;
}

- (void)setIsHiddenUnit:(BOOL)isHiddenUnit {
    _isHiddenUnit = isHiddenUnit;
    if (!self.isHiddenUnit) {
        [self unitLabel];
    }
}

- (void)setIntervalValue:(NSInteger)intervalValue {
    _intervalValue = intervalValue;
}

- (void)setIsShowLastValue:(BOOL)isShowLastValue {
    _isShowLastValue = isShowLastValue;
}

- (void)setXLabels:(NSMutableArray *)xLabels {
    _xLabels = xLabels;

    for (int i = 0; i < xLabels.count; i++) {
        if (i%self.intervalValue == 0 || i == xLabels.count - 1) {
            NSString *labelText = xLabels[i];
            UIFont       *font        = self.textFont != nil ? self.textFont : [UIFont systemFontOfSize:10];
            NSDictionary *attrs       = @{NSFontAttributeName : font};
            CGSize       size         = [labelText sizeWithAttributes:attrs];
            CGFloat      labelW       = size.width;
            CGFloat      labelH       = size.height;
            CGFloat      labelX       = marginLeft + i * self.xLabelWidth + YZCLabelwidth + barWidth * 0.5 - labelW * 0.5;
            
            YzcLabel *label     = [[YzcLabel alloc] initWithFrame:CGRectMake(labelX, self.frame.size.height - YZCLabelHeight - 5, self.xLabelWidth+10, labelH)];
            label.text = labelText;
            if (self.textFont) {
                label.font = self.textFont;
            }
            [label sizeToFit];
            [self addSubview:label];
            if (self.isShowLastValue && i == xLabels.count - 1) {
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            }
        }
    }

    if (self.targetValue) {  //如果设置了目标值就绘制目标虚线
        CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * 3 + 8;
        float   percent          = ((float)self.targetValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        self.targetPercent = percent >= 1 ? 1 : percent;
        [self.myScrollView drawDashLineWithStartPoint:CGPointMake(marginLeft, (1 - percent) * chartCavanHeight+30)
                                             endPoint:CGPointMake(self.xLabelWidth * (self.yLabels.count - 1) + marginLeft, (1 - percent) * chartCavanHeight+30)
                                           lineLength:2
                                          lineSpacing:1
                                            lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    }
}

- (void)setYLabels:(NSMutableArray *)yLabels {
    _yLabels         = yLabels;
    self.xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/self.yLabels.count;
    if (self.style == BarChartStyleNormal) {
        _yValueMax = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
        _yValueMin = 0;//[[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue];
        if (_yValueMax == _yValueMin) {
            _yValueMin = 0;
        }
    }

    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    if (_yValueMax < self.targetValue) {
        _yValueMax = self.targetValue;
    }

    if (self.targetValue) {  //目标值
        CGFloat  chartCavanHeight = self.frame.size.height - YZCLabelHeight * 3 + 8;
        float    percent          = ((float)self.targetValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        CGFloat  labelH           = percent >= 1 ? 22 : (1 - percent) * chartCavanHeight+22;
        YzcLabel *label           = [[YzcLabel alloc] initWithFrame:CGRectMake(0, labelH, YZCLabelwidth+20, YZCLabelHeight)];
        NSString *targetString;
        if (self.targetValue >= 1000) {
            targetString = [NSString stringWithFormat:@"%.1fk", (float)self.targetValue/1000];
            NSString *lastNum = [targetString componentsSeparatedByString:@"."][1];
            if (![lastNum integerValue]) { //没有小数
                NSString *firstNum = [targetString componentsSeparatedByString:@"."][0];
                targetString = [NSString stringWithFormat:@"%@k", firstNum];
            }
        } else {
            targetString = [NSString stringWithFormat:@"%zd", self.targetValue];
        }
        label.text = targetString;

        if (self.textFont) {
            label.font = self.textFont;
        }
        [label sizeToFit];
        [self addSubview:label];
    }

    UIColor *lineColor = self.HorizontalLinecColor ? self.HorizontalLinecColor : [[UIColor blackColor] colorWithAlphaComponent:0.1];
    CGFloat endPointX     = self.xLabelWidth * (self.yLabels.count - 1) + marginLeft;
    
    if (self.style == BarChartStyleRateRange) {
        float   level            = (_yValueMax-_yValueMin) / LINE_COUNT;
        CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * LINE_COUNT + 8;
        CGFloat levelHeight      = chartCavanHeight / LINE_COUNT;

        for (int i = 1; i < LINE_COUNT+1; i++) {
            YzcLabel *label = [[YzcLabel alloc] initWithFrame:CGRectMake(0, chartCavanHeight - i * levelHeight + 13, YZCLabelwidth+20, YZCLabelHeight)];
            label.text = [NSString stringWithFormat:@"%d", (int)(level * i+_yValueMin)];
            if (self.textFont) {
                label.font = self.textFont;
            }
            [label sizeToFit];
            [self addSubview:label];
        }

        //画中间虚线横线
        for (int i = 0; i < LINE_COUNT+1; i++) {
            if (i < LINE_COUNT) {
                [self.myScrollView drawDashLineWithStartPoint:CGPointMake(marginLeft, YZCLabelHeight + i * levelHeight)
                                                     endPoint:CGPointMake(endPointX, YZCLabelHeight + i * levelHeight)
                                                   lineLength:2
                                                  lineSpacing:1
                                                    lineColor:lineColor];
            }
        }
    }

    //最底下一条线
    [self.myScrollView drawSolideLineWithMoveToPoint:CGPointMake(marginLeft, self.myScrollView.frame.size.height-YZCLabelHeight-10)
                                         lineToPoint:CGPointMake(endPointX + barWidth, self.myScrollView.frame.size.height-YZCLabelHeight-10)
                                           lineColor:lineColor];
}

#pragma mark - draw

- (void)strokeChart {
    CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * LINE_COUNT + 8;

    for (int i = 0; i < self.yLabels.count; i++) {
        YzcBar *bar = [[YzcBar alloc] initWithFrame:CGRectMake(i * _xLabelWidth + marginLeft, YZCLabelHeight + 2, barWidth, chartCavanHeight)];
        bar.emptyDataBarColor = self.emptyDataBarColor ? self.emptyDataBarColor : [[UIColor grayColor] colorWithAlphaComponent:0.5];

        if (self.style == BarChartStyleNormal) {
            NSString *valueString = self.yLabels[i];
            float    value        = [valueString floatValue];
            float    percent      = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (percent < 0 || isnan(percent)) {
                percent = 0;
            }
            if (percent >= self.targetPercent && self.targetValue) {
                bar.barColor = self.achieveTargetColor ? self.achieveTargetColor : [UIColor redColor];
            } else {
                bar.barColor = self.barColor ? self.barColor : [UIColor greenColor];
            }
            bar.percent = percent;

            //最后一个点显示数值在上面
            if ((i == self.self.yLabels.count - 1) && self.isShowLastValue && percent) {
                [self setupLastValueLabelWithView:bar value:[NSString stringWithFormat:@"%@", valueString] percent:percent chartCavanHeight:chartCavanHeight];
            }
        } else {
            BarChartModel *barModel = self.yLabels[i];

            float totalValue   = 0.0;
            float totalPercent = 0.0;

            if (self.style == BarChartStyleSleep) {
                totalValue = barModel.SleepTimeLong;
                float deepValue   = barModel.deepTimeLong;
                float deepPercent = ((float)deepValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
                totalPercent = ((float)totalValue-_yValueMin) / ((float)_yValueMax-_yValueMin);

                if (isnan(totalPercent) || totalPercent < 0) {
                    totalPercent = 0;
                }
                if (totalPercent >= self.targetPercent && self.targetValue) {
                    bar.barColor = self.achieveTargetColor ? self.achieveTargetColor : [UIColor clearColor];
                } else {
                    bar.barColor = self.barColor ? self.barColor : [UIColor greenColor];
                }

                bar.lessBarColor = self.lessBarColor ? self.lessBarColor : [UIColor blueColor];
                bar.percent      = totalPercent;
                bar.leesPercent  = deepPercent;

                //最后一个点显示数值在上面
                if ((i == self.self.yLabels.count - 1) && self.isShowLastValue && (NSInteger)totalValue) {
                    [self setupLastValueLabelWithView:bar value:[NSString stringWithFormat:@"%.0f", totalValue] percent:totalPercent chartCavanHeight:bar.frame.size.height + 10];
                }
            } else if (self.style == BarChartStyleRateRange) {
                totalValue   = barModel.maxlValue;
                totalPercent = ((float)totalValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
                float startValue   = barModel.minValue;
                float startPercent = ((float)startValue-_yValueMin) / ((float)_yValueMax-_yValueMin);

                bar.barColor     = self.barColor ? self.barColor : [UIColor greenColor];
                bar.isSvgRate    = YES;
                bar.startPercent = startPercent;
                bar.percent      = totalPercent;
            }
        }

        [self.myScrollView addSubview:bar];
    }
}

- (void)setupLastValueLabelWithView:(YzcBar *)barView value:(NSString *)value percent:(CGFloat)percent chartCavanHeight:(CGFloat)chartCavanHeight {
    NSString     *valueString = [NSString stringWithFormat:@"%@%@", value, self.unitString.length ? self.unitString : @""];
    UIFont       *font        = self.textFont != nil ? self.textFont : [UIFont systemFontOfSize:10];
    NSDictionary *attrs       = @{NSFontAttributeName : font};
    CGSize       size         = [valueString sizeWithAttributes:attrs];
    CGFloat      labelW       = size.width;
    CGFloat      labelH       = size.height;
    CGFloat      labelX       = marginLeft + (self.yLabels.count - 1) * self.xLabelWidth + YZCLabelwidth + barWidth * 0.5 - labelW * 0.5;

    if (percent > 0 && percent < 0.1) {
        percent = 0.1;
    }
    CGFloat labelY = (1 - percent) * barView.frame.size.height + 15;

    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    valueLabel.text          = valueString;
    valueLabel.textColor     = [UIColor whiteColor];
    valueLabel.font          = font;
    valueLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:valueLabel];
    [self drawTipsViewWithFrame:CGRectMake(labelX - marginLeft * 0.5, labelY, valueLabel.frame.size.width + marginLeft, valueLabel.frame.size.height)];
}

@end
