
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "DVSimpleAudioPlayerBaseView.h"

typedef enum {
    eAudioPlayerDisplayFade = 0,
    eAudioPlayerDisplaySlide,
} eAudioPlayerDisplay;

typedef enum {
    eAudioPlayerPositionCenter = 0,
    eAudioPlayerPositionTop,
    eAudioPlayerPositionLeft,
    eAudioPlayerPositionBottom,
    eAudioPlayerPositionRight,
} eAudioPlayerPosition;

@interface DVSimpleAudioPlayerView : DVSimpleAudioPlayerBaseView
{
//	CAGradientLayer		*gradientLayer;
}

//@property (nonatomic, retain) CAGradientLayer *gradientLayer;

- (UIView *)show:(NSTimeInterval)time display:(eAudioPlayerDisplay)showAs position:(eAudioPlayerPosition)position;
- (UIView *)show:(eAudioPlayerDisplay)showAs position:(eAudioPlayerPosition)position;
- (UIView *)show;

- (id)initWithView:(UIView *)view;

@end
