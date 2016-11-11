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
    NSHashTable *_chartLabelsForX;
    
    UIScrollView *myScrollView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        myScrollView.bounces = NO;
        [self addSubview:myScrollView];
    }
    return self;
}


- (void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
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
    
//    _xLabelWidth = myScrollView.frame.size.width/num;
//    
//    for (int i=0; i<xLabels.count; i++) {
//        SCChartLabel * label = [[SCChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
//        label.text = xLabels[i];
//        [myScrollView addSubview:label];
//    }
//    
    
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        YzcLabel * label = [[YzcLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth*0.5-10, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
//        [self addSubview:label];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
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
//    NSInteger max = 0;
//    NSInteger min = 1000000000;
    
//    for (NSArray * ary in yLabels) {
//        for (NSString *valueString in yLabels) {
//            NSInteger value = [valueString integerValue];
//            if (value > max) {
//                max = value;
//            }
//            if (value < min) {
//                min = value;
//            }
//        }
//    }
//    max = max<5 ? 5:max;
//    _yValueMin = 0;
//    _yValueMax = (int)max;
    
//    if (_chooseRange.max != _chooseRange.min) {
//        _yValueMax = _chooseRange.max;
//        _yValueMin = _chooseRange.min;
//    }
//
//    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight;
    CGFloat levelHeight = chartCavanHeight /yLabels.count;
    
    for (int i=0; i<yLabels.count; i++) {
        NSString *valueString = yLabels[i];
        YzcLabel * label = [[YzcLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - (i+1) * levelHeight + 5, UUYLabelwidth, UULabelHeight)];
        label.text = valueString;
        [self addSubview:label];
    }
//    if ([super respondsToSelector:@selector(setMarkRange:)]) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
//        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
//        [self addSubview:view];
//    }
    
    //画横线
    for (int i=0; i<yLabels.count; i++) {
        
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];

    }
}


- (void)strokeChart
{
    
    NSInteger maxValue = [[_yValues valueForKeyPath:@"@max.intValue"] integerValue];
    NSInteger minValue = [[_yValues valueForKeyPath:@"@min.intValue"] integerValue];
    
    
    for (int i=0; i<_yValues.count; i++) {
//        NSArray *childAry = _yValues[i];
//        if (childAry.count==0) {
//            return;
//        }
        //获取最大最小位置
        CGFloat max = [_yValues[0] floatValue];
        CGFloat min = [_yValues[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<_yValues.count; j++){
            CGFloat num = [_yValues[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [myScrollView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[_yValues objectAtIndex:0] floatValue];
        CGFloat xPosition = UUYLabelwidth;
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-minValue) / ((float)maxValue-minValue);
        
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
//        if (self.showMaxMinArray) {
//            if ([self.showMaxMinArray[i] intValue]>0) {
//                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
//            }else{
//                isShowMaxAndMinPoint = YES;
//            }
//        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in _yValues) {
            
//            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            float grade =([valueString floatValue] - minValue) / ((float)maxValue-minValue);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
//                BOOL isShowMaxAndMinPoint = YES;
//                if (self.showMaxMinArray) {
//                    if ([self.showMaxMinArray[i] intValue]>0) {
//                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
//                    }else{
//                        isShowMaxAndMinPoint = YES;
//                    }
//                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UIColor greenColor].CGColor;
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = _yValues.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}


- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:[UIColor greenColor].CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:[UIColor greenColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:label];
    }
    
    [myScrollView addSubview:view];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}
@end
