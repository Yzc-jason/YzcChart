//
//  SleepModel.h
//  YzcChart
//
//  Created by zs-pace on 2017/3/17.
//  Copyright © 2017年 yzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarChartModel : NSObject
///睡眠总时长
@property (nonatomic, assign) CGFloat SleepTimeLong;
///深睡时长
@property (nonatomic, assign) CGFloat deepTimeLong;

//-------------心率范围-------------------------------
///平均心率最低值
@property (nonatomic, assign) CGFloat minValue;
///心率最高值
@property (nonatomic, assign) CGFloat maxlValue;

@end
