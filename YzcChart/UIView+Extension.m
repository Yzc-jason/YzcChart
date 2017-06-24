//
//  UIView+Extension.m
//  YzcChart
//
//  Created by zs-pace on 2017/3/17.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

/**
 绘制虚线
 
 @param startPoint 绘制位置
 @param lineLength 虚线的宽度
 @param lineSpacing 虚线的间距
 @param lineColor 虚线的颜色
 */
- (void)drawDashLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineLength:(int)lineLength
                       lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPosition:startPoint];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, endPoint.x, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.layer insertSublayer:shapeLayer atIndex:0];
}

/**
 绘制实线
 
 @param point 开始绘制点
 @param lineToPoint 结束绘制点
 @param lineColor 实线颜色
 */
- (void)drawSolideLineWithMoveToPoint:(CGPoint)point lineToPoint:(CGPoint)lineToPoint lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path       = [UIBezierPath bezierPath];
    
    [path moveToPoint:point];
    [path addLineToPoint:lineToPoint];
    [path closePath];
    shapeLayer.path        = path.CGPath;
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.fillColor   = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth   = 0.5;
    [self.layer insertSublayer:shapeLayer atIndex:0];
}

- (void)drawTipsViewWithFrame:(CGRect)frame {
    NSInteger    triangleH = 3;
    UIBezierPath *path     = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:1];
    
    [path moveToPoint:CGPointMake(frame.origin.x + frame.size.width * 0.5 - triangleH, frame.origin.y + frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x + frame.size.width * 0.5 + triangleH, frame.origin.y + frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.origin.x + frame.size.width * 0.5, frame.origin.y + frame.size.height + triangleH)];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    shapeLayer.path      = path.CGPath;
    [self.layer insertSublayer:shapeLayer atIndex:(int)(self.subviews.count - 2)];
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame        = frame;
}
@end
