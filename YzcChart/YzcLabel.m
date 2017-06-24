//
//  YzcLabel.m
//  YzcChart
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 yzc. All rights reserved.
//

#import "YzcLabel.h"

@implementation YzcLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont systemFontOfSize:10.0f]];
        [self setTextColor: [[UIColor blackColor] colorWithAlphaComponent:0.2]];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.userInteractionEnabled = YES;
    }
    return self;
}



@end
