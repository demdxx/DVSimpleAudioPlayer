
#import <UIKit/UIKit.h>
#import "DVSimpleAudioPlayer.h"

@interface DVSimpleAudioPlayerBaseView : UIView<DVSimpleAudioPlayerDelegate>
{
	DVSimpleAudioPlayer	*player;
}

@property (nonatomic, retain) UIButton *buttonPlayPause;
@property (nonatomic, retain) UISlider *sliderTime;
@property (nonatomic, retain) UILabel  *timePassed;
@property (nonatomic, retain) UILabel  *timeLeft;

- (void)setFile:(NSURL *)url;
- (BOOL)isPlaying;
- (BOOL)isPause;

- (BOOL)play;

- (void)configureView;
- (void)updateTime;

- (void)onPlay:(id)sender;
- (void)onChangeTimeBegin:(id)sender;
- (void)onChangeTimeEnd:(id)sender;

@end