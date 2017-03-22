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

@interface YzcBarChart ()

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, assign) CGPoint lastPoint;;

@property (nonatomic, assign) CGPoint originPoint;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, assign) CGFloat yValueMax;

@property (nonatomic, assign) CGFloat yValueMin;

@property (nonatomic, assign) CGFloat targetPercent;

@end


@implementation YzcBarChart

#pragma mark - lazy
- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YZCLabelwidth, 0, 100, 40)];
        label.text      = NSLocalizedString(@"(次/分)", nil);
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
        self.myScrollView         = [[UIScrollView alloc]initWithFrame:CGRectMake(YZCLabelwidth, 0, frame.size.width-YZCLabelwidth, frame.size.height)];
        self.myScrollView.bounces = NO;
        [self addSubview:self.myScrollView];
        self.isHiddenUnit      = YES;
        self.intervalValue     = 1;
    }
    return self;
}

#pragma mark - setter
- (void)setUnitString:(NSString *)unitString {
    _unitString         = unitString;
    self.unitLabel.text = unitString;
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

-(void)setIsShowLastValue:(BOOL)isShowLastValue {
    _isShowLastValue = isShowLastValue;
}
- (void)setXLabels:(NSMutableArray *)xLabels {
    _xLabels     = xLabels;
    _xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/xLabels.count;

    for (int i = 0; i < xLabels.count; i++) {
        if (i%self.intervalValue == 0) {
            NSString *labelText = xLabels[i];
            YzcLabel *label     = [[YzcLabel alloc] initWithFrame:CGRectMake(i * self.xLabelWidth+YZCLabelwidth*0.5, self.frame.size.height - YZCLabelHeight, self.xLabelWidth+10, YZCLabelHeight)];
            label.text = labelText;
            [label sizeToFit];
            [self.myScrollView addSubview:label];
        }
    }

    if (self.targetValue) {  //如果设置了目标值就绘制目标虚线
        CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * 3 + 8;
        float   percent          = ((float)self.targetValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        self.targetPercent = percent;
        [self drawDashLine:self.myScrollView
                     point:CGPointMake(25, (1 - percent) * chartCavanHeight+30)
                lineLength:2 lineSpacing:1
                 lineColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    }
}

- (void)setYLabels:(NSMutableArray *)yLabels {
    _yLabels = yLabels;

    if (self.style == BarChartStyleNormal) {
        _yValueMax = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
        _yValueMin = [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue];
    }

    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    if (self.targetValue) {
        CGFloat  chartCavanHeight = self.frame.size.height - YZCLabelHeight * 3 + 8;
        float    percent          = ((float)self.targetValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        YzcLabel *label           = [[YzcLabel alloc] initWithFrame:CGRectMake(0, (1 - percent) * chartCavanHeight+22, YZCLabelwidth+20, YZCLabelHeight)];
        label.text = [NSString stringWithFormat:@"%.1fk", self.targetValue >= 1000 ? (float)self.targetValue/1000 : self.targetValue];
        [label sizeToFit];
        [self addSubview:label];
    }

    if (self.style == BarChartStyleRateRange) {
        float   level            = (_yValueMax-_yValueMin) / LINE_COUNT;
        CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * LINE_COUNT + 8;
        CGFloat levelHeight      = level;//chartCavanHeight / LINE_COUNT ;

        for (int i = 1; i < LINE_COUNT+1; i++) {
            YzcLabel *label = [[YzcLabel alloc] initWithFrame:CGRectMake(0, chartCavanHeight - i * levelHeight + 13, YZCLabelwidth+20, YZCLabelHeight)];
            label.text = [NSString stringWithFormat:@"%d", (int)(level * i+_yValueMin)];
            [label sizeToFit];
            [self addSubview:label];
        }

        //画横线
        for (int i = 0; i < LINE_COUNT+1; i++) {
            UIColor *lineColor = self.HorizontalLinecColor ? self.HorizontalLinecColor : [[UIColor grayColor] colorWithAlphaComponent:0.5];

            if (i < LINE_COUNT) {
                [self drawDashLine:self.myScrollView
                             point:CGPointMake(25, YZCLabelHeight+i*levelHeight)
                        lineLength:2
                       lineSpacing:1 lineColor:lineColor];
            }
        }
    }

    [self drawSolideLineWithMoveToPoint:CGPointMake(25, self.frame.size.height-YZCLabelHeight-10)
                            lineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-YZCLabelHeight-10)
                              lineColor:[UIColor grayColor]];
}

#pragma mark - draw

- (void)strokeChart {
    CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight * LINE_COUNT + 8;

    _xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/self.yLabels.count;

    for (int i = 0; i < self.yLabels.count; i++) {
        YzcBar *bar = [[YzcBar alloc] initWithFrame:CGRectMake(i * _xLabelWidth+YZCLabelwidth*0.5, YZCLabelHeight, 5, chartCavanHeight)];
        bar.emptyDataBarColor = self.emptyDataBarColor ? self.emptyDataBarColor : [[UIColor grayColor] colorWithAlphaComponent:0.5];
        
        if (self.style == BarChartStyleNormal) {
            NSString *valueString = self.yLabels[i];
            float    value        = [valueString floatValue];
            float    percent      = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (percent < 0) {
                percent = 0;
            }
            if (percent >= self.targetPercent && self.targetValue) {
                bar.barColor = self.achieveTargetColor ? self.achieveTargetColor : [UIColor redColor];
            } else {
                bar.barColor = self.barColor ? self.barColor : [UIColor greenColor];
            }
            bar.percent = percent;

            //最后一个点显示数值在上面
            if ((i == self.self.yLabels.count - 1) && self.isShowLastValue) {
                [self setupLastValueLabelWithView:bar value:[valueString integerValue] percent:percent chartCavanHeight:chartCavanHeight];
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

                if (totalPercent >= self.targetPercent && self.targetValue) {
                    bar.barColor = self.achieveTargetColor ? self.achieveTargetColor : [UIColor clearColor];
                } else {
                    bar.barColor = self.barColor ? self.barColor : [UIColor greenColor];
                }

                bar.lessBarColor = self.lessBarColor ? self.lessBarColor : [UIColor blueColor];
                bar.percent      = totalPercent;
                bar.leesPercent  = deepPercent;
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

            //最后一个点显示数值在上面
            if ((i == self.self.yLabels.count - 1) && self.isShowLastValue) {
                [self setupLastValueLabelWithView:bar value:totalValue percent:totalPercent chartCavanHeight:chartCavanHeight];
            }
        }
       
        [self.myScrollView addSubview:bar];
    }
}

- (void)setupLastValueLabelWithView:(YzcBar *)barView value:(NSInteger)value percent:(CGFloat)percent chartCavanHeight:(CGFloat)chartCavanHeight {
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 31)];

    valueLabel.text      = [NSString stringWithFormat:@"%zd", value];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.font      = [UIFont systemFontOfSize:10];
    [valueLabel sizeToFit];
    CGPoint labelPoint = CGPointMake(valueLabel.text.length >3 ? barView.center.x-5 : barView.center.x, (1 - percent) * chartCavanHeight+15);
    valueLabel.center        = labelPoint;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.myScrollView addSubview:valueLabel];
}

@end
