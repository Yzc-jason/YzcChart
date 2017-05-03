//
//  YzcChartView.m
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcLineChart.h"
#import "YzcLabel.h"
#import "UIView+Extension.h"

@interface YzcLineChart ()

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, assign) CGPoint lastPoint;;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGFloat yValueMin;
@property (nonatomic, assign) CGFloat yValueMax;
@property (nonatomic, assign) BOOL isLastIndex;

@end

@implementation YzcLineChart

#pragma mark - lazy
- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YZCLabelwidth-10, -10, 100, 40)];
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
        self.isDrawPoint       = YES;
        self.isShadow          = YES;
        self.isHiddenUnit      = YES;
        self.isShowMaxMinValue = NO;
        self.intervalValue = 1;
    }
    return self;
}

#pragma mark - setter

- (void)setIsHiddenUnit:(BOOL)isHiddenUnit {
    _isHiddenUnit = isHiddenUnit;
    if (!self.isHiddenUnit) {
        [self unitLabel];
    }
}

- (void)setIsHiddenLastValue:(BOOL)isHiddenLastValue {
    _isHiddenLastValue = isHiddenLastValue;
}

- (void)setUnitString:(NSString *)unitString {
    _unitString         = unitString;
    self.unitLabel.text = unitString;
}

- (void)setIntervalValue:(NSInteger)intervalValue {
    _intervalValue = intervalValue;
}

- (void)setXLabels:(NSMutableArray *)xLabels {
    _xLabels = xLabels;
    NSInteger count = xLabels.count;
    self.xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/count;

    for (int i = 0; i < count; i++) {
        if (i%self.intervalValue == 0 || i == count - 1) {
            NSString *labelText = xLabels[i];
            YzcLabel *label     = [[YzcLabel alloc] initWithFrame:CGRectMake(i * self.xLabelWidth+YZCLabelwidth*0.5 - 5, self.frame.size.height - YZCLabelHeight+5, self.xLabelWidth+10, YZCLabelHeight)];
            label.text = labelText;
            [label sizeToFit];
            [self.myScrollView addSubview:label];

            if (self.isHiddenLastValue && i == count - 1) {
                label.textColor = [UIColor blackColor];
            }
        }
    }
}

- (void)setYLabels:(NSMutableArray *)yLabels {
    _yLabels         = yLabels;
    self.xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/self.yLabels.count;

    _yValueMax = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
    _yValueMin = [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue];

    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float   level            = (_yValueMax-_yValueMin) / (LINE_COUNT - 1);
    CGFloat chartCavanHeight = self.frame.size.height - YZCLabelHeight*(LINE_COUNT - 1);
    CGFloat levelHeight      = chartCavanHeight / (LINE_COUNT - 1);

    for (int i = 0; i < LINE_COUNT; i++) {
        CGFloat labelValue = level * i+_yValueMin;
        if (labelValue) {
            YzcLabel *label = [[YzcLabel alloc] initWithFrame:CGRectMake(5, chartCavanHeight - i * levelHeight + 13, YZCLabelwidth+20, YZCLabelHeight)];
            NSString *targetString;
            if (labelValue >= 1000) {
                targetString = [NSString stringWithFormat:@"%.1fk", (float)labelValue/1000];
            }else{
                targetString = [NSString stringWithFormat:@"%.0f", labelValue];
            }
            label.text = targetString;
            [label sizeToFit];
            [self addSubview:label];
        }
    }

    //画横线
    for (int i = 0; i < LINE_COUNT; i++) {
        UIColor *lineColor = self.HorizontalLinecColor ? self.HorizontalLinecColor : [[UIColor grayColor] colorWithAlphaComponent:0.5];

        if (i == LINE_COUNT - 1) {
            [self drawSolideLineWithMoveToPoint:CGPointMake(30, YZCLabelHeight+i*levelHeight)
                                    lineToPoint:CGPointMake(self.frame.size.width, YZCLabelHeight+i*levelHeight)
                                      lineColor:lineColor];
        } else {
            [self drawDashLine:self.myScrollView
                         point:CGPointMake(30, YZCLabelHeight+i*levelHeight)
                    lineLength:2
                   lineSpacing:1 lineColor:lineColor];
        }
    }
}

#pragma mark - Draw points
- (void)strokeChart {
    BOOL isShowMaxAndMinPoint = YES;
    self.xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/self.yLabels.count;
    float maxValue   = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
    if (maxValue == 0) {
        return;
    }
    //划线
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.lineCap   = kCALineCapRound; //设置线条拐角帽的样式
    chartLine.lineJoin  = kCALineJoinRound; //设置两条线连结点的样式
    chartLine.fillColor = [[UIColor clearColor] CGColor];
    chartLine.lineWidth = 2.0;
    chartLine.strokeEnd = 0.0;
    [self.myScrollView.layer addSublayer:chartLine];

    //线
    UIBezierPath *progressline    = [UIBezierPath bezierPath];
    CGFloat      firstValue       = [[self.yLabels objectAtIndex:0] floatValue];
    CGFloat      xPosition        = 10;
    CGFloat      chartCavanHeight = self.myScrollView.frame.size.height - YZCLabelHeight*(LINE_COUNT-1);

    //第一个点
    float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    if (isnan(grade)) {
        grade = 0;
    }

    if (!_yValueMax) {
        return;
    }

    CGPoint firstPoint = CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight);
    [progressline moveToPoint:firstPoint];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];

    //遮罩层形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle  = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:firstPoint];
    self.originPoint = firstPoint;       //记录原点

    NSInteger index = 0;
    for (NSString *valueString in self.yLabels) {
        float grade = ([valueString floatValue] - _yValueMin) / ((float)_yValueMax-_yValueMin);
        if (isnan(grade)) {
            grade = 0;
        }
        CGPoint point = CGPointMake(xPosition+index*self.xLabelWidth, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight);

        if (index != 0) {
            [progressline addLineToPoint:point];
            [bezier1 addLineToPoint:point];
        }

        if (index == _yLabels.count-1) {
            self.lastPoint   = point;        //记录最后一个点
            self.isLastIndex = YES;
        }

        if (self.isDrawPoint) { //画点
            [self addPoint:point
                     index:index
                    isShow:isShowMaxAndMinPoint
                     value:[valueString integerValue]];
        }
        
        //显示最大值或最小值
        if (self.isShowMaxMinValue && ([valueString floatValue] == [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue] || [valueString floatValue] == [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue])) {
            [self setupLastValueLabelWithView:point value:[valueString integerValue] grade:grade chartCavanHeight:chartCavanHeight];
            if (!self.isDrawPoint) { //如果没有画点才画最大最小的点，不然就不重复画点
                [self addPoint:point
                         index:index
                        isShow:isShowMaxAndMinPoint
                         value:[valueString integerValue]];
            }
        }
        index += 1;
    }


    chartLine.path        = progressline.CGPath;
    chartLine.strokeColor = self.lineColor ? self.lineColor.CGColor : [UIColor greenColor].CGColor;

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration       = self.yLabels.count*0.1;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue      = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue        = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses   = NO;
    [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    chartLine.strokeEnd = 1.0;

    if (self.isShadow) {
        [bezier1 addLineToPoint:CGPointMake(self.lastPoint.x, self.myScrollView.frame.size.height - YZCLabelHeight)];
        [bezier1 addLineToPoint:CGPointMake(self.originPoint.x, self.myScrollView.frame.size.height - YZCLabelHeight)];
        [bezier1 addLineToPoint:self.originPoint];

        [self addGradientLayer:bezier1];
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(NSInteger)value {
    CGFloat viewWH = 5;
    UIView  *view  = [[UIView alloc]initWithFrame:CGRectMake(5, 5, viewWH, viewWH)];

    view.center              = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius  = viewWH*0.5;
    view.layer.borderWidth   = 2;
    view.layer.borderColor   = self.pointColor ? self.pointColor.CGColor : [UIColor greenColor].CGColor;
    view.backgroundColor     = self.pointColor;
    [self.myScrollView addSubview:view];

    //最后一个点显示数值在上面
    if (self.isLastIndex && self.isHiddenLastValue && value) {
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 31)];
        valueLabel.text      = [NSString stringWithFormat:@"%zd", value];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.font      = [UIFont systemFontOfSize:12];
        [valueLabel sizeToFit];
        CGPoint labelPoint = CGPointMake(point.x, point.y - 10);
        valueLabel.center        = labelPoint;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [self.myScrollView addSubview:valueLabel];
    }
}

/**
   添加渐变图层
 */
- (void)addGradientLayer:(UIBezierPath *)bezier1 {
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];

    shadeLayer.path      = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;

    UIColor         *color         = self.lineColor ? self.lineColor : [UIColor greenColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame         = CGRectMake(5, 0, 0, self.myScrollView.bounds.size.height-20);
    gradientLayer.cornerRadius  = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors        = @[(__bridge id)[color colorWithAlphaComponent:0.4].CGColor, (__bridge id)[color colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.locations     = @[@(0.1f), @(1.0f)];
    gradientLayer.startPoint    = CGPointMake(0, 0);
    gradientLayer.endPoint      = CGPointMake(1, 1);

    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    //截取渐变层
    [baseLayer setMask:shadeLayer];
    [self.myScrollView.layer insertSublayer:baseLayer atIndex:0];

    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath             = @"bounds";
    anmi1.duration            = self.yLabels.count*0.1;
    anmi1.toValue             = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*self.lastPoint.x, self.myScrollView.bounds.size.height-20)];
    anmi1.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode            = kCAFillModeForwards;
    anmi1.autoreverses        = NO;
    anmi1.removedOnCompletion = NO;

    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}

- (void)setupLastValueLabelWithView:(CGPoint)point value:(NSInteger)value grade:(CGFloat)grade chartCavanHeight:(CGFloat)chartCavanHeight {
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 31)];
    
    valueLabel.text      = [NSString stringWithFormat:@"%zd", value];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.font      = [UIFont systemFontOfSize:10];
    [valueLabel sizeToFit];
    CGPoint labelPoint = CGPointMake(valueLabel.text.length > 3 ? point.x - 3 : point.x, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight - 15);
    valueLabel.center        = CGPointMake(labelPoint.x + 20, labelPoint.y );
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
}

@end
