//
//  DVViewController.m
//  DVSimpleAudioPlayerExample
//
//  Created by Dmitry Ponomarev on 1/16/13.
//  Copyright (c) 2013 demdxx. All rights reserved.
//

#import "DVViewController.h"
#import "DVSimpleAudioPlayerView.h"

@interface DVViewController ()

@end

@implementation DVViewController

@synthesize player1;
@synthesize player2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Jet_KC135_Tanker_PassBy" ofType:@"mp3"];
    
    player1.buttonPlayPause = self.player1Btn;
    player1.sliderTime = self.player1Slider;
    player1.timePassed = self.player1Passed;
    player1.timeLeft = self.player1Left;
    [player1 setFile:[NSURL fileURLWithPath:file]];
    [player1 configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)play2:(id)sender
{
    if (player2)
    {
        [player2 play];
    }
    else
    {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Jet_KC135_Tanker_PassBy" ofType:@"mp3"];
        player2 = [[DVSimpleAudioPlayerView alloc] initWithView:self.view];
        player2.backgroundColor = [UIColor grayColor];
        [player2 show];
        [player2 setFile:[NSURL fileURLWithPath:file]];
        [player2 play];
    }
}

@end
