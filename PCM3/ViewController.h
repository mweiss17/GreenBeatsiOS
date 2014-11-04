//
//  ViewController.h
//  PCM3
//
//  Created by Martin Weiss 1 on 2014-09-11.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController
@property (nonatomic, retain) AVPlayer *player;
@property int firstFrameToSkip;
@property (strong, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property double elapsedTimeInCycle;
@property AVPlayer* avPlayer;
@property AVPlayerItem *playerItem;
@property NSTimeInterval timeToWait;
@property (strong, nonatomic) IBOutlet UIButton *close;
- (IBAction)closeAction:(id)sender;
@property AVPlayerLayer *layer;
@property NSDate* stopWatch;
@end
