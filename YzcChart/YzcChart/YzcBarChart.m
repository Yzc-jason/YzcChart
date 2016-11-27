//
//  YzcBarChart.m
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcBarChart.h"
#import "YzcLabel.h"
#import "YzcBar.h"

@interface YzcBarChart()

@property (nonatomic) CGFloat xLabelWidth;

@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, assign) CGPoint lastPoint;;

@property (nonatomic, assign) CGPoint originPoint;

@property (nonatomic, assign) CGPoint prePoint;

@end


@implementation YzcBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        self.myScrollView.bounces = NO;
        [self addSubview:self.myScrollView];
       
        self.isShadow    = YES;
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
    _xLabelWidth = (self.myScrollView.frame.size.width - UUYLabelwidth * 0.5)/23;
    
    NSInteger count = xLabels.count > 24 ? xLabels.count : 24;
    for (int i=0; i<24; i++) {
        if (i%6 == 0) {
            YzcLabel * label = [[YzcLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth*0.5, self.frame.size.height - UULabelHeight, _xLabelWidth*2, UULabelHeight)];
            label.text = [NSString stringWithFormat:@"%02d:00",i];
            [self.myScrollView addSubview:label];
        }
        
    }
    
    //画底部的点
    for (int i=0; i<count; i++) {
        
        [self addPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-UULabelHeight-10) ];

    }
    
    float max = (count*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (self.myScrollView.frame.size.width < max-10) {
        self.myScrollView.contentSize = CGSizeMake(max+10, 0);
    }
    
}


- (void)setYLabels:(NSArray *)yLabels
{
    _yLabels = yLabels;
}

-(void)strokeChart
{
    NSInteger maxValue = [[_yLabels valueForKeyPath:@"@max.intValue"] integerValue];
    NSInteger minValue = 0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    for(int i = 0; i <self.yLabels.count; i++)
    {
        NSString *valueString = self.yLabels[i];
        float value = [valueString floatValue];
        float grade = ((float)value-minValue) / ((float)maxValue-minValue);
        
        YzcBar * bar = [[YzcBar alloc] initWithFrame:CGRectMake(UUYLabelwidth+i*_xLabelWidth - 1, UULabelHeight, 3, chartCavanHeight)];
        bar.barColor = self.barColor ? self.barColor :  [UIColor yellowColor];
        bar.gradePercent = grade;
        [self.myScrollView addSubview:bar];
        
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        
        gradientLayer.frame = CGRectMake(20, 100, 200, 200);
        
       
    }
}


- (void)addPoint:(CGPoint)point
{
    CGFloat viewWH = 5;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWH, viewWH)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = viewWH*0.5;
    view.backgroundColor = self.pointColor ? self.pointColor : [UIColor grayColor];
    [self.myScrollView addSubview:view];
}


@end
