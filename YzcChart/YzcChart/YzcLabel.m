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
        
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor: [UIColor darkGrayColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}



@end
