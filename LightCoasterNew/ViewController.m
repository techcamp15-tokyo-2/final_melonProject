//
//  ViewController.m
//  LightCoasterNew
//
//  Created by Shengxin Hong on 2013/09/12.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*drawView.red = red;
    drawView.green = green;
    drawView.blue = blue;
    drawView.alpha = alpha;*/
    
    //NSUserDefaultsの初期化
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithFloat:0.0] forKey:@"passedTime"];
    //[defaults setFloat:0.0 forKey:@"passedTime"];
    [userDefaults registerDefaults:defaults];
    
    //遷移直後の時間取得
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    startTime = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSLog(@"%@", startTime);
    
    [self start];
    
	// Do any additional setup after loading the view, typically from a nib.
}

static void AudioInputCallback(
                               void* inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inBuffer,
                               const AudioTimeStamp *inStartTime,
                               UInt32 inNumberPacketDescriptions,
                               const AudioStreamPacketDescription *inPacketDescs) {
}

- (void)start {
    AudioStreamBasicDescription dataFormat;
    dataFormat.mSampleRate = 44100.0f;
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mBytesPerPacket = 2;
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mBytesPerFrame = 2;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mReserved = 0;
    
    AudioQueueNewInput(&dataFormat,AudioInputCallback,(__bridge void*)self,CFRunLoopGetCurrent(),kCFRunLoopCommonModes,0,&queue);
    AudioQueueStart(queue, NULL);
    
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(queue,kAudioQueueProperty_EnableLevelMetering,&enabledLevelMeter,sizeof(UInt32));
    
    [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(updateVolume:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateVolume:(NSTimer *)timer {
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue,kAudioQueueProperty_CurrentLevelMeterDB,&levelMeter,&levelMeterSize);
    
    //NSLog(@"mPeakPower=%0.9f", levelMeter.mPeakPower);
    //NSLog(@"mAveragePower=%0.9f", levelMeter.mAveragePower);
    
    //dv.levelMeter =  levelMeter;
    
}
/*
- (void)setColor :(float)_red :(float)_green :(float)_blue :(float)_alpha {
    red = _red;
    green = _green;
    blue = _blue;
    alpha = _alpha;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.view setNeedsDisplay];
    // Dispose of any resources that can be recreated.
}

@end
