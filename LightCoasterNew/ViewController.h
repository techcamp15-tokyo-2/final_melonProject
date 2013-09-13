//
//  ViewController.h
//  LightCoasterNew
//
//  Created by Shengxin Hong on 2013/09/12.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class MyDrawView2;
//@class MyDrawView;

@interface ViewController : UIViewController
{
    MyDrawView2 *dv;
    float red;
    float green;
    float blue;
    float alpha;
    float valueSlider;
    NSUserDefaults *userDefaults;
    NSDate *startTime;

    AudioQueueRef queue;
    AudioQueueLevelMeterState levelMeter;
}

- (void)setColor :(float)_red :(float)_green :(float)_blue :(float)_alpha;

@end
