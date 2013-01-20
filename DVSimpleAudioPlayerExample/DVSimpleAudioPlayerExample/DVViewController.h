//
//  DVViewController.h
//  DVSimpleAudioPlayerExample
//
//  Created by Dmitry Ponomarev on 1/16/13.
//  Copyright (c) 2013 demdxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVSimpleAudioPlayerBaseView.h"
#import "DVSimpleAudioPlayerView.h"

@interface DVViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *player1Btn;
@property (weak, nonatomic) IBOutlet UISlider *player1Slider;
@property (weak, nonatomic) IBOutlet UILabel *player1Passed;
@property (weak, nonatomic) IBOutlet UILabel *player1Left;
@property (weak, nonatomic) IBOutlet DVSimpleAudioPlayerBaseView *player1;

@property (nonatomic, retain) DVSimpleAudioPlayerView *player2;

- (IBAction)play2:(id)sender;

@end
