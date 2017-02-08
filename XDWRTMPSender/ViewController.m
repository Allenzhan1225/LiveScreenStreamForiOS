//
//  ViewController.m
//  XDWRTMPSender
//
//  Created by zangyanan on 16/12/18.
//  Copyright © 2016年 xindawn. All rights reserved.
//

#import "ViewController.h"

#import <LFLiveKit/LFLiveKit.h>
#import <XDWScreenRecorder/XDWScreenRecorder.h>

@interface ViewController () <XDWScreenRecorderDelegate>
@property(nonatomic, strong) LFLiveStreamInfo *liveStreamInfo;
@property(nonatomic, strong) LFLiveSession *lfLiveSession;
@property(nonatomic, strong) XDWScreenRecorder *screenRecorder;
@end

@implementation ViewController

- (XDWScreenRecorder *)screenRecorder {
    if (!_screenRecorder) {
        XDWScreenRecorderConfig *screenRecorderConfig = [[XDWScreenRecorderConfig alloc] init];
        screenRecorderConfig.videoSize = CGSizeMake(1280, 1280);
        screenRecorderConfig.framerate = 24;
        screenRecorderConfig.airTunesPort = 57000;
        screenRecorderConfig.airVideoPort = 8101;
        screenRecorderConfig.activeCode = "000000000";
        screenRecorderConfig.airPlayName = "XBMC-GAMEBOX(XinDawn)";
        screenRecorderConfig.autoRotate = 0; //0 or 90 or 270
        
        _screenRecorder = [[XDWScreenRecorder alloc] initWithConfig:screenRecorderConfig];
        _screenRecorder.delegate = self;
    }
    return _screenRecorder;
}

- (LFLiveSession *)lfLiveSession {
    if (!_lfLiveSession) {
        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
        videoConfiguration.videoFrameRate = 30;
        videoConfiguration.videoMaxKeyframeInterval = 60;
        videoConfiguration.autorotate = NO;
        videoConfiguration.videoSize = CGSizeMake(720, 1280);
        videoConfiguration.videoBitRate = 1500 * 1000;
        videoConfiguration.videoMaxBitRate = 1700 * 1000;
        videoConfiguration.videoMinBitRate = 1300 * 1000;
        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
        
        _liveStreamInfo = [[LFLiveStreamInfo alloc] init];
        _liveStreamInfo.url = @"rtmp://send3.douyu.com/live/1492366rjexxZH5k?wsSecret=6cf939520939438ecb250682329f0518&wsTime=585a5385";
        _liveStreamInfo.videoConfiguration = videoConfiguration;
        _liveStreamInfo.audioConfiguration = [LFLiveAudioConfiguration defaultConfiguration];
        
        
        _lfLiveSession = [[LFLiveSession alloc] initWithAudioConfiguration:_liveStreamInfo.audioConfiguration
                                                        videoConfiguration:_liveStreamInfo.videoConfiguration
                                                               captureType:LFLiveCaptureMaskAudioInputVideo];
        _lfLiveSession.reconnectInterval = 1;
        _lfLiveSession.reconnectCount = 20;
        _lfLiveSession.adaptiveBitrate = YES;
    }
    return _lfLiveSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)airplaySwitch:(UISwitch *)sender {
    if (sender.isOn) {
        [self.lfLiveSession startLive:self.liveStreamInfo];
        [self.screenRecorder start];
    } else {
        [self.lfLiveSession stopLive];
        [self.screenRecorder stop];
    }
}

#pragma mark - XDWScreenRecorderDelegate

- (void)screenRecorder:(XDWScreenRecorder *)screenRecorder didStartRecordingWithVideoSize:(CGSize)videoSize {
    self.liveStreamInfo.videoConfiguration.videoSize = videoSize;
    self.lfLiveSession.running = YES;
}

- (void)screenRecorder:(XDWScreenRecorder *)screenRecorder startError:(NSError *)error {
    
}

- (void)screenRecorder:(XDWScreenRecorder *)screenRecorder videoBuffer:(CVPixelBufferRef)buffer timestamp:(NSTimeInterval)timestamp {
    [self.lfLiveSession pushVideo:buffer];
}

- (void)screenRecorderDidStopRecording:(XDWScreenRecorder *)screenRecorder {
    self.lfLiveSession.running = NO;
}
@end
