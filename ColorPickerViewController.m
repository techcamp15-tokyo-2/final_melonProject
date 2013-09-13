//
//  ColorPickerViewController.m
//  LightCoasterNew
//
//  Created by Shengxin Hong on 2013/09/12.
//  Copyright (c) 2013年 Shengxin Hong. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "MyDrawView.h"

@interface ColorPickerViewController ()

@end

@implementation ColorPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.userInteractionEnabled = YES;
    _imageView2.userInteractionEnabled = YES;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    totalTmp = [[userDefaults objectForKey:@"passedTime"] floatValue];
    if (totalTmp>=30) {
        [self changeimage2];
    } if (totalTmp>=60) {
        [self changeimage3];
    } if (totalTmp>=90) {
        [self changeimage4];
    } if (totalTmp>=120) {
        [self changeimage5];
    } if (totalTmp>=180) {
        [self changeimage6];
        [self changeimagePicker];
    }
    
    //NSUserDefaultsの初期化
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:[NSNumber numberWithFloat:0.0] forKey:@"passedTime"];
    [userDefaults registerDefaults:defaults];
    
    [self start];
    
    [_mySlider addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventValueChanged];
    
    //drawView = [[MyDrawView alloc] initWithFrame:CGRectMake(70, 190, 180, 180)];
    drawView = [[MyDrawView alloc] initWithFrame:CGRectMake(0, 40, 320, 440)];
    [self.view addSubview:drawView];
    drawView.backgroundColor = [UIColor clearColor];
    [self.view sendSubviewToBack:drawView];
        
    drawView.valueSlider = -75.0;
    
    [self.view setNeedsDisplay];
    
    //ポップアップ関連初期化
    ud1 = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d1 = [NSMutableDictionary dictionary];
    [d1 setObject:[NSNumber numberWithInt:0] forKey:@"count1Key"];
    [ud1 registerDefaults:d1];
    ud2 = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d2 = [NSMutableDictionary dictionary];
    [d2 setObject:[NSNumber numberWithInt:0] forKey:@"count2Key"];
    [ud2 registerDefaults:d2];
    ud3 = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d3 = [NSMutableDictionary dictionary];
    [d3 setObject:[NSNumber numberWithInt:0] forKey:@"count3Key"];
    [ud3 registerDefaults:d3];
    ud4 = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d4 = [NSMutableDictionary dictionary];
    [d4 setObject:[NSNumber numberWithInt:0] forKey:@"count4Key"];
    [ud4 registerDefaults:d4];
    ud5 = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d5 = [NSMutableDictionary dictionary];
    [d5 setObject:[NSNumber numberWithInt:0] forKey:@"count5Key"];
    [ud5 registerDefaults:d5];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Do any additional setup after loading the view from its nib.
}

//タッチ座標取得
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pos = [[touches anyObject] locationInView:_imageView];
    
    touchX = pos.x;
    touchY = pos.y;
    
    if (touchY<56) {
        NSLog(@"pos(%.1f,%.1f)", touchX, touchY);
        
        if (touchX >= 0 && touchX <= 319 && touchY >= 0 && touchY <= 54) {
            [self getColorInfo:touchX :touchY];
            
        }
    } else {
        CGPoint pos2 = [[touches anyObject] locationInView:_imageView2];
        touchX = pos2.x;
        touchY = pos2.y;
        
        NSLog(@"pos(%.1f,%.1f)", touchX, touchY);
        if (touchX >= 0 && touchX <= 319 && touchY >= 0 && touchY <= 54) {
            [self getColorInfo2:touchX :touchY];
        }
    }
    
    NSLog(@"%f, %f, %f, %f", red, green, blue, alpha);
    //UIColor *nowSelect = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    //button.backgroundColor = nowSelect;
    //label.backgroundColor = nowSelect;
}

//色の取得
-(void)getColorInfo:(int)corX :(int)corY{
    
    // 画像の読み込み
    if (totalTmp<30) {
        sampleImage = [UIImage imageNamed:@"color_1.png"];
    } else if (totalTmp>=30 && totalTmp<60) {
        sampleImage = [UIImage imageNamed:@"color_2.png"];
    } else if (totalTmp>=60 && totalTmp<90) {
        sampleImage = [UIImage imageNamed:@"color_3.png"];
    } else if (totalTmp>=90 && totalTmp<120) {
        sampleImage = [UIImage imageNamed:@"color_4.png"];
    } else if (totalTmp>=120 && totalTmp<180) {
        sampleImage = [UIImage imageNamed:@"color_5.png"];
    } else if (totalTmp>=180) {
        sampleImage = [UIImage imageNamed:@"color_.png"];
    }
    
    // UIImageのCGImageメソッドで画像詳細情報を得る
    CGImageRef imageRef = sampleImage.CGImage;
    // データプロバイダ(提供される画像データ)を得る
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダのデータを入手
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    // CFDataGetBytePtr: returns a read-only pointer to the bytes of a CFData objects.
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    // データプロバイダから情報を抜き出す
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    UInt8 *pixelPtr = buffer + (int)(corY)*bytesPerRow + (int)(corX)*4;
    // 直接メモリアドレスを指定して値を得る
    UInt8 a = *(pixelPtr + 3); // alpha
    UInt8 b = *(pixelPtr + 2); // blue
    UInt8 g = *(pixelPtr + 1); // green
    UInt8 r = *(pixelPtr + 0); // red
    
    red= (float)r/255;
    green= (float)g/255;
    blue= (float)b/255;
    alpha= (float)a/255;
    
    drawView.red = red;
    drawView.green = green;
    drawView.blue = blue;
    drawView.alpha = alpha;
}

-(void)getColorInfo2:(int)corX :(int)corY{
    // 画像の読み込み
    if (totalTmp<180) {
        sampleImage = [UIImage imageNamed:@"GradationLock.png"];
    } else if (totalTmp>=180) {
        sampleImage = [UIImage imageNamed:@"Gradation.png"];
    }
    // UIImageのCGImageメソッドで画像詳細情報を得る
    CGImageRef imageRef = sampleImage.CGImage;
    // データプロバイダ(提供される画像データ)を得る
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダのデータを入手
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    // CFDataGetBytePtr: returns a read-only pointer to the bytes of a CFData objects.
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    // データプロバイダから情報を抜き出す
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    UInt8 *pixelPtr = buffer + (int)(corY)*bytesPerRow + (int)(corX)*4;
    // 直接メモリアドレスを指定して値を得る
    UInt8 a = *(pixelPtr + 3); // alpha
    UInt8 b = *(pixelPtr + 2); // blue
    UInt8 g = *(pixelPtr + 1); // green
    UInt8 r = *(pixelPtr + 0); // red
    
    red= (float)r/255;
    green= (float)g/255;
    blue= (float)b/255;
    alpha= (float)a/255;
    
    drawView.red = red;
    drawView.green = green;
    drawView.blue = blue;
    drawView.alpha = alpha;

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
    
    drawView.levelMeter =  levelMeter;
    [drawView setNeedsDisplay];
    
}

- (void)changeSlider{
    //(つまみの位置)が替わったときに実行されるメソッドを指定
    _mySlider.minimumValue = -75.0;
    _mySlider.maximumValue = -1.0;
    valueSlider = _mySlider.value;
    //NSLog(@"slider: %f", valueSlider);
    drawView.valueSlider = valueSlider;
}

- (IBAction)mySetting:(id)sender {
    if (_mySlider.hidden) {
        
        _imageView.hidden= NO;
        _imageView2.hidden = NO;
        _settingLabel.hidden = NO;
        _sensibilityLabel.hidden = NO;
        _mySlider.hidden = NO;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        
        //設定に戻ったときの時間取得
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        finishTime = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
        [formatter2 setDateFormat:@"HH:mm:ss"];
        NSLog(@"%@", finishTime);
        
        //時間の差分
        float tmp= [finishTime timeIntervalSinceDate:startTime];
        NSLog(@"passedTime: %f", tmp);
        
        //NSUserDefaultsからデータを読み込む
        totalTmp = [[userDefaults objectForKey:@"passedTime"] floatValue];
        //データの更新
        totalTmp = totalTmp + tmp;
        [userDefaults setObject:[NSNumber numberWithFloat:totalTmp] forKey:@"passedTime"];
        NSLog(@"totalTmp:%f", totalTmp);
        
        if (totalTmp>=30) {
            [self changeimage2];
        } if (totalTmp>=60) {
            [self changeimage3];
        } if (totalTmp>=90) {
            [self changeimage4];
        } if (totalTmp>=120) {
            [self changeimage5];
        } if (totalTmp>=180) {
            [self changeimage6];
            [self changeimagePicker];
        }
        
        //NSUserDefaultsからデータを読み込む
        int count1 = [[ud1 objectForKey:@"count1Key"] intValue];
        int count2 = [[ud2 objectForKey:@"count2Key"] intValue];
        int count3 = [[ud3 objectForKey:@"count3Key"] intValue];
        int count4 = [[ud4 objectForKey:@"count4Key"] intValue];
        int count5 = [[ud5 objectForKey:@"count5Key"] intValue];
        
        if (totalTmp>=30 && totalTmp<60 && count1==0) {
            [self applicationInfo];
            count1 = count1 + 1;
            [ud1 setObject:[NSNumber numberWithInt:count1] forKey:@"count1Key"];
        } if (totalTmp>=60 && totalTmp<90 && count2==0) {
            [self applicationInfo];
            count2 = count2 + 1;
            [ud2 setObject:[NSNumber numberWithInt:count2] forKey:@"count2Key"];
        } if (totalTmp>=90 && totalTmp<120 && count3==0) {
            [self applicationInfo];
            count3 = count3 + 1;
            [ud3 setObject:[NSNumber numberWithInt:count3] forKey:@"count3Key"];
        } if (totalTmp>=120 && totalTmp<180 && count4==0) {
            [self applicationInfo];
            count4 = count4 + 1;
            [ud4 setObject:[NSNumber numberWithInt:count4] forKey:@"count4Key"];
        } if (totalTmp>=180 && count5==0) {
            [self applicationInfo2];
            count5 = count5 + 1;
            [ud5 setObject:[NSNumber numberWithInt:count5] forKey:@"count5Key"];
        }

    } else {
        
        _imageView.hidden= YES;
        _imageView2.hidden = YES;
        _settingLabel.hidden = YES;
        _sensibilityLabel.hidden = YES;
        _mySlider.hidden = YES;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        
        //hidden直後の時間取得
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        startTime = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSLog(@"%@", startTime);
    }
}

-(void)changeimage2{
    UIImage* image = [UIImage imageNamed:@"color_2.png"];
    _imageView.image = image;
}

-(void)changeimage3{
    UIImage* image = [UIImage imageNamed:@"color_3.png"];
    _imageView.image = image;
}

-(void)changeimage4{
    UIImage* image = [UIImage imageNamed:@"color_4.png"];
    _imageView.image = image;
}

-(void)changeimage5{
    UIImage* image = [UIImage imageNamed:@"color_5.png"];
    _imageView.image = image;
}

-(void)changeimage6{
    UIImage* image = [UIImage imageNamed:@"color_.png"];
    _imageView.image = image;
}

-(void)changeimagePicker{
    UIImage* image = [UIImage imageNamed:@"Gradation.png"];
    _imageView2.image = image;
}

-(void)applicationInfo {
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                     message:@"New color collection is released!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

-(void)applicationInfo2 {
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                     message:@"Every color collection is released!!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
