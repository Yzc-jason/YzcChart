//
//  YzcBar.m
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcBar.h"
#import "YzcCommonMacros.h"

@interface YzcBar ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation YzcBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;

        //填充色层
        self.progressLayer           = [CAShapeLayer layer];
        self.progressLayer.frame     = self.bounds;
        self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
        self.progressLayer.lineCap   = kCALineCapSquare;
        self.progressLayer.lineWidth = self.frame.size.width;

        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (void)setPercent:(CGFloat)percent {
    if (percent == 0) {
        percent                   = 0.08;
        self.progressLayer.strokeColor = self.emptyDataBarColor.CGColor;
    } else {
        percent                   = percent < 0.1 ? 0.1 : percent;
        self.progressLayer.strokeColor = self.barColor.CGColor;
    }

    _percent = percent;

    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.isSvgRate) {
        [path moveToPoint:CGPointMake(self.frame.size.width/2.0, (1-self.startPercent) * self.frame.size.height-5)];
        [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - percent) * self.frame.size.height+5 )];
    }else{
        [path moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
        [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - percent) * self.frame.size.height+15)];
    }
    
    [path setLineWidth:1];
    [path setLineCapStyle:kCGLineCapSquare];

    //增加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration       = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue      = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue        = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses   = NO;
    self.progressLayer.path      = path.CGPath;
    
    [self.progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

- (void)setLeesPercent:(CGFloat)leesPercent {
    //深睡
    UIBezierPath *deepSleepPath = [UIBezierPath bezierPath];
    [deepSleepPath moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
    [deepSleepPath addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - leesPercent) * self.frame.size.height+15)];
    [deepSleepPath setLineWidth:1];
    [deepSleepPath setLineCapStyle:kCGLineCapSquare];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = self.frame.size.width;
    shapeLayer.strokeColor = self.lessBarColor.CGColor;
    shapeLayer.path = deepSleepPath.CGPath;
    [self.layer addSublayer:shapeLayer];

}

@end
