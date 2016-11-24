//
//  YzcChartView.m
//  YzcChart
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcChartView.h"
#import "YzcLabel.h"

@implementation YzcChartView{
    UIScrollView *myScrollView;
    CGPoint lastPoint;//最后一个坐标点
    CGPoint originPoint;//原点
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        myScrollView.bounces = NO;
        [self addSubview:myScrollView];
        self.isDrawPoint = YES;
        self.isdrawLine  = YES;
    }
    return self;
}


- (void)setXLabels:(NSArray *)xLabels
{

    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
        num=20.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (myScrollView.frame.size.width - UUYLabelwidth * 0.5)/5;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        YzcLabel * label = [[YzcLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth*0.5-10, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        [myScrollView addSubview:label];
        
    }
    
    //画竖线
    for (int i=0; i<xLabels.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,0)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-UULabelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [myScrollView.layer addSublayer:shapeLayer];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    float yMax = (([self.yLabels count]-1)*UULabelHeight + yLabelMargin)+UULabelHeight;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, yMax);
    }

}


- (void)setYLabels:(NSArray *)yLabels
{
    _yLabels = yLabels;

    CGFloat _yValueMax = [[self.yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat _yValueMin = [[self.yLabels valueForKeyPath:@"@min.floatValue"] floatValue];
    float level = (_yValueMax-_yValueMin) /3;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /3;
    
    for (int i=0; i<4; i++) {
        YzcLabel * label = [[YzcLabel alloc] initWithFrame:CGRectMake(0,chartCavanHeight - i * levelHeight, UUYLabelwidth, UULabelHeight)];
        label.text = [NSString stringWithFormat:@"%d%@",(int)(level * i+_yValueMin),self.unit ? self.unit : @""];
        [self addSubview:label];
    }

    
    //画横线
    for (int i=0; i<4; i++) {
        
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(20,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer insertSublayer:shapeLayer atIndex:0];

    }
}


- (void)strokeChart
{
    
    BOOL isShowMaxAndMinPoint = YES;
    NSInteger maxValue = [[_yLabels valueForKeyPath:@"@max.intValue"] integerValue];
    NSInteger minValue = [[_yLabels valueForKeyPath:@"@min.intValue"] integerValue];

    //划线
    CAShapeLayer *_chartLine = [CAShapeLayer layer];
    _chartLine.lineCap = kCALineCapRound;   //设置线条拐角帽的样式
    _chartLine.lineJoin = kCALineJoinRound; //设置两条线连结点的样式
    _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    _chartLine.lineWidth   = 2.0;
    _chartLine.strokeEnd   = 0.0;
    [myScrollView.layer addSublayer:_chartLine];
    
    //线
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    CGFloat firstValue = [[_yLabels objectAtIndex:0] floatValue];
    CGFloat xPosition = UUYLabelwidth;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    
    //第一个点
    float grade = ((float)firstValue-minValue) / ((float)maxValue-minValue);
    CGPoint firstPoint = CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
    [progressline moveToPoint:firstPoint];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    
    //遮罩层形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:firstPoint];
    originPoint = firstPoint;
    
    NSInteger index = 0;
    for (NSString * valueString in _yLabels) {
        
        float grade =([valueString floatValue] - minValue) / ((float)maxValue-minValue);
        
        CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
        [progressline addLineToPoint:point];
        [progressline moveToPoint:point];
        
        if (index == _yLabels.count-1) {
            lastPoint = point;          //记录最后一个点
        }
        
        if (index != 0) {
            [bezier1 addLineToPoint:point];
        }
        
        if (self.isDrawPoint) {
            
            [self addPoint:point
                     index:index
                    isShow:isShowMaxAndMinPoint
                     value:[valueString floatValue]];
        }
        index += 1;
    }
    
    if (self.isdrawLine) {
        
        _chartLine.path = progressline.CGPath;
        _chartLine.strokeColor = self.lineColor ? self.lineColor.CGColor : [UIColor greenColor].CGColor;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = _yLabels.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
        
        [bezier1 addLineToPoint:CGPointMake(lastPoint.x, self.frame.size.height - UULabelHeight*2)];
        [bezier1 addLineToPoint:CGPointMake(originPoint.x, self.frame.size.height - UULabelHeight*2)];
        [bezier1 addLineToPoint:originPoint];
        
        [self addGradientLayer:bezier1];
    }

}


- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    CGFloat viewWH = 13;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, viewWH, viewWH)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = viewWH*0.5;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:self.pointColor ? self.pointColor.CGColor : [UIColor greenColor].CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index] ? [_colors objectAtIndex:index]:[UIColor greenColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:label];
    }
    
    [myScrollView addSubview:view];
}


/**
 添加渐变图层
 */
- (void)addGradientLayer:(UIBezierPath *)bezier1
{
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, myScrollView.bounds.size.height-20);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.0].CGColor];
 
//    gradientLayer.locations = @[@(0.2f),@(0.8)];
    gradientLayer.locations = @[@(0.5f)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [myScrollView.layer insertSublayer:baseLayer atIndex:0];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = _yLabels.count*0.4;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, myScrollView.bounds.size.height-20)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];

}

@end
