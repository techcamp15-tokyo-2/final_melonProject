//
//  ColorPickerViewController.h
//  LightCoasterNew
//
//  Created by Shengxin Hong on 2013/09/12.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class MyDrawView;

@interface ColorPickerViewController : UIViewController
{
    double touchX;
    double touchY;
    float red;
    float green;
    float blue;
    float alpha;
    float valueSlider;
    
    double centerX;
    double centerY;
    double power;
    
    UIImage *sampleImage;
    
    AudioQueueRef queue;
    AudioQueueLevelMeterState levelMeter;
    
    NSUserDefaults *userDefaults;
    NSDate *startTime;
    NSDate *finishTime;
    
    NSUserDefaults *ud1;
    NSUserDefaults *ud2;
    NSUserDefaults *ud3;
    NSUserDefaults *ud4;
    NSUserDefaults *ud5;
    
    float totalTmp;
    
    MyDrawView *drawView;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (retain, nonatomic) IBOutlet UIImageView *settingLabel;
@property (retain, nonatomic) IBOutlet UIImageView *sensibilityLabel;

- (void)changeSlider;
- (IBAction)mySetting:(id)sender;
- (void)applicationInfo;

@end
