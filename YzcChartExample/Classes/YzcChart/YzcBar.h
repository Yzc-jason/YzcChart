//
//  YzcBar.h
//  YzcChart
//
//  Created by 叶志成 on 2016/11/26.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YzcBar : UIView

@property (nonatomic,assign) CGFloat percent;

@property (nonatomic, assign) CGFloat leesPercent;

@property (nonatomic, assign) CGFloat startPercent;

///柱状条空数据时的颜色
@property (nonatomic, strong) UIColor * emptyDataBarColor;
///柱状条颜色
@property (nonatomic, strong) UIColor * barColor;
///矮柱状条颜色
@property (nonatomic, strong) UIColor * lessBarColor;

@property (nonatomic, assign) BOOL isSvgRate;

@end
