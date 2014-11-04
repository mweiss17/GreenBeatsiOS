//
//  AppDelegate.m
//  PCM3
//
//  Created by Martin Weiss 1 on 2014-09-11.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Set AudioSession
	NSError *sessionError = nil;
	[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
	UInt32 doChangeDefaultRoute = 1;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

	self.durations = [[NSMutableArray alloc] initWithCapacity:15];
	for(int i = 0; i < 10; i++){
		[self calculateNetworkLatency2];
	}
	[self calcMath];
	[NSThread sleepForTimeInterval:self.timeToWait];
	return YES;

}

- (void)calculateNetworkLatency2
{
	self.requestStart = [NSDate date];
	NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURL * url = [NSURL URLWithString:@"http://54.69.71.254:8080/timeStamp/"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL: url];
	[request setHTTPMethod:@"GET"];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(str);
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	self.serverTime = [f numberFromString:str];
	self.requestDuration = [[NSDate date] timeIntervalSinceDate:_requestStart];
	[self.durations addObject: [[NSNumber alloc] initWithDouble:self.requestDuration]];

	self.j = self.j + 1;
	_progress.progress = _progress.progress + .1;
	NSLog(@"str=%@",str);
}


- (void) calcMath{
	float average = 0;
	for(int i = 2; i < self.j; i++)
	{
		NSLog(@"Trial = %i", i);
		NSLog(@"Duration = %f", [[self.durations objectAtIndex:i]doubleValue]);
		average = average + [[self.durations objectAtIndex:i]doubleValue];
	}
	average = average/(self.j-2);
	self.requestDuration = average;
	self.timeToWait = 10.0 - fmod(([self.serverTime doubleValue]/1000000000) + self.requestDuration/2.0, 10.0);

}
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	ViewController *playerView= (ViewController*)self.window.rootViewController;
	AVPlayerItem *playerItem = playerView.avPlayer.currentItem;
	NSArray *tracks = [playerItem tracks];
	for (AVPlayerItemTrack *playerItemTrack in tracks)
	{
		// find video tracks
		if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
		{
		NSLog(@"yep");
			self.stopWatch = [NSDate date];
			CMTime currentTime = playerItem.currentTime; //playing time
			NSLog(@"CurrentTimeWhenClosing: %f", CMTimeGetSeconds(currentTime));
			playerItemTrack.enabled = NO; // disable the track
		}
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	ViewController *playerView= (ViewController*)self.window.rootViewController;
	AVPlayerItem *playerItem = playerView.avPlayer.currentItem;
	NSArray *tracks = [playerItem tracks];
	for (AVPlayerItemTrack *playerItemTrack in tracks)
	{
		// find video tracks
		if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
		{
			playerItemTrack.enabled = YES; // disable the track
		}
	}

}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
