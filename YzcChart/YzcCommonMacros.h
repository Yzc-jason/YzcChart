//
//  YzcCommonMacros.h
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2017年 yzc. All rights reserved.
//

#ifndef YzcCommonMacros_h
#define YzcCommonMacros_h

#define chartMargin      10
#define xLabelMargin     15
#define yLabelMargin     15
#define YZCLabelHeight   20
#define YZCLabelwidth    20
#define YZCTagLabelwidth 80
#define LINE_COUNT       3

#define IS_IPHONE4S      ([UIScreen mainScreen].bounds.size.height <= 480)
#define IS_IPHONE5S      ([UIScreen mainScreen].bounds.size.height == 568)

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min){
    CGRange p;

    p.max = max;
    p.min = min;
    return p;
}

static const CGRange CGRangeZero = {0, 0};

#endif /* YzcCommonMacros_h */
