//
//  AppDelegate.h
//  PCM3
//
//  Created by Martin Weiss 1 on 2014-09-11.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property int j;
@property (nonatomic, retain) NSDate *requestStart;
@property (nonatomic, retain) NSArray *serverTimestamp;
@property (nonatomic, retain) NSString* serverTimestampString;
@property (nonatomic, retain) NSDate* serverTimestampDate;
@property NSMutableArray *serverTimestampsArray;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property NSTimeInterval serverTimeSinceEpoch;
@property NSTimeInterval requestDuration;
@property NSTimeInterval timeToWait;
@property NSMutableArray *durations;
@property Boolean returned;
@property NSDate* stopWatch;
@end
