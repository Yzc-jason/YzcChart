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

#define marginLeft 10

@interface YzcLineChart ()

@property (nonatomic) CGFloat              xLabelWidth;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UILabel      *unitLabel;
@property (nonatomic, assign) CGPoint      lastPoint;;
@property (nonatomic, assign) CGPoint      originPoint;
@property (nonatomic, assign) CGFloat      yValueMin;
@property (nonatomic, assign) CGFloat      yValueMax;
@property (nonatomic, assign) BOOL         isLastIndex;
@property (nonatomic, strong) CAShapeLayer *chartLine;
@property (nonatomic, strong) UIBezierPath *progressline;

@end

@implementation YzcLineChart

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
        self.intervalValue     = 1;
    }
    return self;
}

#pragma mark - Draw points
- (void)strokeChart {
    float maxValue = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];

    if (!maxValue || !_yValueMax) {
        return;
    }

    BOOL    isShowMaxAndMinPoint = YES;
    CGFloat firstValue           = [[self.yLabels objectAtIndex:0] floatValue];
    CGFloat xPosition            = 10;
    CGFloat chartCavanHeight     = self.myScrollView.frame.size.height - YZCLabelHeight*(LINE_COUNT-1);
    [self.myScrollView.layer addSublayer:self.chartLine];

    float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    if (isnan(grade)) {
        grade = 0;
    }
    CGPoint firstPoint = CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight);

    //线路径
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline moveToPoint:firstPoint]; //设置起点
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
                     value:valueString];
        }

        //显示最大值或最小值
        if (self.isShowMaxMinValue && ([valueString floatValue] == [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue] || [valueString floatValue] == [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue])) {
            [self setupLastValueLabelWithView:point
                                        value:[valueString integerValue]
                                        grade:grade
                             chartCavanHeight:chartCavanHeight];

            if (!self.isDrawPoint) { //如果没有画点才画最大最小的点，不然就不重复画点
                [self addPoint:point
                         index:index
                        isShow:isShowMaxAndMinPoint
                         value:valueString];
            }
        }
        index += 1;
    }

    self.chartLine.path        = progressline.CGPath;
    self.chartLine.strokeColor = self.lineColor ? self.lineColor.CGColor : [UIColor greenColor].CGColor;
    self.chartLine.strokeEnd   = 1.0;
    [self addAnimationWithLine:self.chartLine duration:self.yLabels.count * 0.03];

    if (self.isShadow) {
        [bezier1 addLineToPoint:CGPointMake(self.lastPoint.x, self.myScrollView.frame.size.height - YZCLabelHeight)];
        [bezier1 addLineToPoint:CGPointMake(self.originPoint.x, self.myScrollView.frame.size.height - YZCLabelHeight)];
        [bezier1 addLineToPoint:self.originPoint];
        [self addGradientLayer:bezier1];
    }
}

- (void)segmentedStrokeChart {
    float maxValue = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];

    if (!maxValue || !_yValueMax) {
        return;
    }

    BOOL    isShowMaxAndMinPoint = YES;
    CGFloat xPosition            = 10;
    CGFloat chartCavanHeight     = self.myScrollView.frame.size.height - YZCLabelHeight*(LINE_COUNT-1);

    NSInteger kAnimationTimeCount = 0;
    for (int i = 0; i < self.yLabels.count; i++) {
        NSString *valueString = self.yLabels[i];
        float    grade        = ([valueString floatValue] - _yValueMin) / ((float)_yValueMax-_yValueMin);
        if (isnan(grade)) {
            grade = 0;
        }

        if ([valueString floatValue]) {
            kAnimationTimeCount += 1;
            CGPoint point = CGPointMake(xPosition+i*self.xLabelWidth, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight);
            [self.myScrollView.layer addSublayer:self.chartLine];
            if (!self.progressline) {
                self.progressline = [UIBezierPath bezierPath];
                [self.progressline setLineWidth:2.0];
                [self.progressline setLineCapStyle:kCGLineCapRound];
                [self.progressline setLineJoinStyle:kCGLineJoinRound];
                [self.progressline moveToPoint:point];
            } else {
                [self.progressline addLineToPoint:point];
            }

            if (i == _yLabels.count-1) {
                self.lastPoint   = point;    //记录最后一个点
                self.isLastIndex = YES;
            }
            if (self.isDrawPoint) { //画点
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:valueString];
            }

            //显示最大值或最小值
            if (self.isShowMaxMinValue && ([valueString floatValue] == [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue] || [valueString floatValue] == [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue])) {
                [self setupLastValueLabelWithView:point
                                            value:[valueString integerValue]
                                            grade:grade
                                 chartCavanHeight:chartCavanHeight];

                if (!self.isDrawPoint) { //如果没有画点才画最大最小的点，不然就不重复画点
                    [self addPoint:point
                             index:i
                            isShow:isShowMaxAndMinPoint
                             value:valueString];
                }
            }

            self.chartLine.path        = self.progressline.CGPath;
            self.chartLine.strokeColor = self.lineColor ? self.lineColor.CGColor : [UIColor greenColor].CGColor;
            self.chartLine.strokeEnd   = 1.0;
            [self addAnimationWithLine:self.chartLine duration:kAnimationTimeCount * 0.1];
        } else {
            self.progressline   = nil;
            self.chartLine      = nil;
            kAnimationTimeCount = 0;
        }
    }
}

- (void)addAnimationWithLine:(CAShapeLayer *)chartLine duration:(CGFloat)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    pathAnimation.duration       = duration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue      = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue        = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses   = NO;
    [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(NSString *)value {
    CGFloat viewWH = 5;
    UIView  *view  = [[UIView alloc]initWithFrame:CGRectMake(5, 5, viewWH, viewWH)];

    view.center              = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius  = viewWH*0.5;
    view.layer.borderWidth   = 2;
    if (value) {
        view.layer.borderColor = self.pointColor ? self.pointColor.CGColor : [UIColor greenColor].CGColor;
    } else {
        view.layer.borderColor = [UIColor clearColor].CGColor;
    }
    view.backgroundColor = self.pointColor;
    [self.myScrollView addSubview:view];


    NSString *valueString = [NSString stringWithFormat:@"%@%@", value, self.unitString.length ? self.unitString : @""];
    //最后一个点显示数值在上面
    if (self.isLastIndex && self.isHiddenLastValue && valueString.length) {
        UIFont *font = self.textFont != nil ? self.textFont : [UIFont systemFontOfSize:10];

        NSDictionary *attrs = @{NSFontAttributeName : font};
        CGSize       size   = [valueString sizeWithAttributes:attrs];
        CGFloat      labelW = size.width;
        CGFloat      labelH = size.height;
        CGFloat      labelX = point.x + marginLeft * 0.5;
        if ([value integerValue] < 10) {
            labelX += viewWH * 0.5;
        }
        CGFloat      labelY = point.y - 20;

        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        valueLabel.text          = valueString;
        valueLabel.textColor     = [UIColor whiteColor];
        valueLabel.font          = font;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:valueLabel];
        [self drawTipsViewWithFrame:CGRectMake(labelX - marginLeft * 0.5, labelY, valueLabel.frame.size.width + marginLeft, valueLabel.frame.size.height)];
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
    UIFont  *font       = self.textFont != nil ? self.textFont : [UIFont systemFontOfSize:10];
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 31)];

    valueLabel.text      = [NSString stringWithFormat:@"%zd", value];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.font      = font;
    [valueLabel sizeToFit];
    CGPoint labelPoint = CGPointMake(valueLabel.text.length > 3 ? point.x - 3 : point.x, chartCavanHeight - grade * chartCavanHeight+YZCLabelHeight - 15);
    valueLabel.center        = CGPointMake(labelPoint.x + 20, labelPoint.y);
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
}

#pragma mark - setter && getter
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
    _unitString = unitString;
}

- (void)setIntervalValue:(NSInteger)intervalValue {
    _intervalValue = intervalValue;
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YZCLabelwidth-10, -10, 100, 40)];
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

- (CAShapeLayer *)chartLine {
    if (_chartLine == nil) {
        CAShapeLayer *chartLine = [CAShapeLayer layer];
        chartLine.lineCap   = kCALineCapRound; //设置线条拐角帽的样式
        chartLine.lineJoin  = kCALineJoinRound; //设置两条线连结点的样式
        chartLine.fillColor = [[UIColor clearColor] CGColor];
        chartLine.lineWidth = 2.0;
        chartLine.strokeEnd = 0.0;
        _chartLine          = chartLine;
    }
    return _chartLine;
}

- (void)setXLabels:(NSMutableArray *)xLabels {
    _xLabels = xLabels;
    NSInteger count = xLabels.count;
    self.xLabelWidth = (self.myScrollView.frame.size.width - YZCLabelwidth * 0.5)/self.yLabels.count;

    for (int i = 0; i < count; i++) {
        if (i%self.intervalValue == 0 || i == count - 1) {
            NSString *labelText = xLabels[i];

            UIFont *font = self.textFont != nil ? self.textFont : [UIFont systemFontOfSize:10];

            NSDictionary *attrs = @{NSFontAttributeName : font};
            CGSize       size   = [labelText sizeWithAttributes:attrs];
            CGFloat      labelW = size.width;
            CGFloat      labelH = size.height;
            CGFloat      labelX = marginLeft + i * self.xLabelWidth + YZCLabelwidth - labelW * 0.5;
            YzcLabel     *label = [[YzcLabel alloc] initWithFrame:CGRectMake(labelX, self.frame.size.height - YZCLabelHeight + 5, labelW, labelH)];
            label.text = labelText;
            if (self.textFont) {
                label.font = self.textFont;
            }
            [label sizeToFit];
            [self addSubview:label];

            if (self.isHiddenLastValue && i == count - 1) {
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
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
        if (labelValue >= 0 && i > 0 ) {
            YzcLabel *label = [[YzcLabel alloc] initWithFrame:CGRectMake(5, chartCavanHeight - i * levelHeight + 13, YZCLabelwidth+20, YZCLabelHeight)];
            NSString *targetString;
            if (labelValue >= 1000) {
                targetString = [NSString stringWithFormat:@"%.1fk", (float)labelValue/1000];
            } else {
                targetString = [NSString stringWithFormat:@"%.0f", labelValue];
            }

            if (self.textFont) {
                label.font = self.textFont;
            }
            label.text = targetString;
            [label sizeToFit];
            [self addSubview:label];
        }
    }

    //画横线
    for (int i = 0; i < LINE_COUNT; i++) {
        UIColor *lineColor = self.HorizontalLinecColor ? self.HorizontalLinecColor : [[UIColor grayColor] colorWithAlphaComponent:0.5];

        CGPoint startPoint = CGPointMake(marginLeft, YZCLabelHeight+i*levelHeight);
        CGPoint endPoint   = CGPointMake(self.frame.size.width, YZCLabelHeight+i*levelHeight);
        if (i == LINE_COUNT - 1) {
            [self.myScrollView drawSolideLineWithMoveToPoint:startPoint
                                                 lineToPoint:endPoint
                                                   lineColor:lineColor];
        } else {
            if (!self.isHiddenDashedLine) {
                [self.myScrollView drawDashLineWithStartPoint:startPoint
                                                     endPoint:endPoint
                                                   lineLength:2
                                                  lineSpacing:1
                                                    lineColor:lineColor];
            }
        }
    }
}

@end
