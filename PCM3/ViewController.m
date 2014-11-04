//
//  ViewController.m
//  PCM3
//
//  Created by Martin Weiss 1 on 2014-09-11.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
NSLog(@"viewCont");
	self.view.backgroundColor = [UIColor blackColor];
	self.close.transform=CGAffineTransformMakeRotation(1.570);
	[UIView commitAnimations];
	self.elapsedTimeInCycle = 0.000;
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	self.timeToWait = appDelegate.timeToWait;  //..to read
	NSLog(@"timeToWait= %f", self.timeToWait);
	[self initializePlayer];

}
-(IBAction) closeAction:(id)sender{
	exit(0);
}

- (void)initializePlayer
{
	// Load the audio data
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"PCM" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.avPlayer = [AVPlayer playerWithURL:fileURL];
	self.layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
	[self.avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playerItemDidReachEnd:)
												 name:AVPlayerItemDidPlayToEndTimeNotification
											   object:[self.avPlayer currentItem]];
	self.layer.frame = CGRectMake(-29, -68, self.view.bounds.size.width+58, self.view.bounds.size.height+92);
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    [self.view.layer addSublayer: self.layer];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.avPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {

			[self.avPlayer play];
			[self.close setTitle:@"Close" forState:UIControlStateNormal];
			
			[[self.close superview] bringSubviewToFront: self.close];
			[NSTimer scheduledTimerWithTimeInterval:.01
											 target:self
										   selector:@selector(timeLog)
										   userInfo:nil
											repeats:YES];
		}
	}
}

- (void)timeLog
{
	self.elapsedTimeInCycle+=.01;
	if(self.elapsedTimeInCycle > 10.000){
		self.elapsedTimeInCycle = fmod(self.elapsedTimeInCycle, 10.000);
	}
	self.elapsedTimeLabel.text = [[NSString alloc] initWithFormat:@"%f", self.elapsedTimeInCycle];
	[[self.elapsedTimeLabel superview] bringSubviewToFront: self.elapsedTimeLabel];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
