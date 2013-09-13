//
//  MyDrawView.h
//  light
//
//  Created by Shengxin Hong on 2013/09/06.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ColorPickerViewController.h"

@interface MyDrawView : UIView {
    double centerX;
    double centerY;
    double power;
    float red, green, blue, alpha;
    //UISlider *mySlider;
}

//- (void)setColor :(float)_red :(float)_green :(float)_blue :(float)_alpha;

@property (nonatomic) AudioQueueLevelMeterState levelMeter;
@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic) float alpha;
@property (nonatomic) float valueSlider;

- (void)changeSlider;

@end
