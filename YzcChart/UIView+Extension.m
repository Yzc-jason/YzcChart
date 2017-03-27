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
 
 @param view 需要绘制到的view
 @param point 绘制位置
 @param lineLength 虚线的宽度
 @param lineSpacing 虚线的间距
 @param lineColor 虚线的颜色
 */
- (void)drawDashLine:(UIView *)view point:(CGPoint)point lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setPosition:point];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, view.frame.size.width-7, 0);
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

@end
