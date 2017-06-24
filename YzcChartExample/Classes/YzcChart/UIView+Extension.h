//
//  UIView+Extension.h
//  YzcChart
//
//  Created by zs-pace on 2017/3/17.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 绘制实线
 
 @param point 开始绘制点
 @param lineToPoint 结束绘制点
 @param lineColor 实线颜色
 */
- (void)drawSolideLineWithMoveToPoint:(CGPoint)point lineToPoint:(CGPoint)lineToPoint lineColor:(UIColor *)lineColor;

/**
 绘制虚线
 
 @param startPoint 绘制位置
 @param lineLength 虚线的宽度
 @param lineSpacing 虚线的间距
 @param lineColor 虚线的颜色
 */
- (void)drawDashLineWithStartPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint
                        lineLength:(int)lineLength
                       lineSpacing:(int)lineSpacing
                         lineColor:(UIColor *)lineColor;

- (void)drawTipsViewWithFrame:(CGRect)frame;

- (void)setWidth:(CGFloat)width;

@end
