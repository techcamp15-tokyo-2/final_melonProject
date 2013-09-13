//
//  MyDrawView.m
//  light
//
//  Created by Shengxin Hong on 2013/09/06.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import "MyDrawView.h"

@implementation MyDrawView

@synthesize levelMeter;
@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize valueSlider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 色を定義
    CGFloat color[4] = {red, green, blue, alpha};
    // 円を描画
    CGContextSetFillColor(context, color);
    centerX = (rect.size.width  - rect.origin.x) / 2;
    centerY = (rect.size.height - rect.origin.y) / 2;
    //power = 300 + levelMeter.mAveragePower * 4;
    //power = (300 + levelMeter.mAveragePower * 4 * 75 / ((-1) * valueSlider)) / 2;
    power = 600 + levelMeter.mAveragePower * 8 * 75 / ((-1) * valueSlider);
    if (power > 0) {
        CGContextFillEllipseInRect(context, CGRectMake(centerX - power / 2, centerY - power / 2, power, power));
    } else {
        CGContextFillEllipseInRect(context, CGRectMake(centerX - power / 2, centerY - power / 2, 0, 0));
    }
}

/*  
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
