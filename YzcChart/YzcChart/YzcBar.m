//
//  YzcBar.m
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcBar.h"

@interface YzcBar()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation YzcBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 2.0;
        
        //遮罩层
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame       = self.bounds;
        _progressLayer.fillColor   = [[UIColor clearColor] CGColor];
        _progressLayer.lineCap     = kCALineCapRound;
        _progressLayer.lineWidth   = self.frame.size.width;
        
        //渐变图层
        //        _gradientLayer =  [CAGradientLayer layer];
        //        _gradientLayer.frame = _progressLayer.frame;
        //        [_gradientLayer setLocations:@[@0.4,@0.6]];
        //        [_gradientLayer setStartPoint:CGPointMake(0, 0)];
        //        [_gradientLayer setEndPoint:CGPointMake(1, 1)];
        //
        //        //用progressLayer来截取渐变层 遮罩
        //        [_gradientLayer setMask:_progressLayer];
        //        [self.layer addSublayer:_gradientLayer];
        
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

-(void)setGradePercent:(float)gradePercent
{
    if (gradePercent==0)
        return;
    
    _gradePercent = gradePercent;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - gradePercent) * self.frame.size.height+15)];
    [path setLineWidth:1.0];
    [path setLineCapStyle:kCGLineCapRound];
    
    _progressLayer.strokeColor = self.barColor.CGColor;
    
    //渐变图层颜色
    //    [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[self.barColor colorWithAlphaComponent:1].CGColor,(id)[self.barColor colorWithAlphaComponent:0.8].CGColor, nil]];
    
    //增加动画
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses=NO;
    _progressLayer.path=path.CGPath;
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

//- (void)drawRect:(CGRect)rect
//{
//    //Draw BG
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, self.barBgColor.CGColor);
//    CGContextFillRect(context, rect);
//}



@end
