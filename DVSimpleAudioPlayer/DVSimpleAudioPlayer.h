
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#ifndef __has_feature
#   define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#   define PO_OBJECT_RELEASE(obj) obj = nil
#   define PO_OBJECT_RETAIN(obj) obj
#else
#   define PO_OBJECT_RELEASE(obj) if (obj!=nil) { [obj release]; obj=nil; }
#   define PO_OBJECT_RETAIN(obj) [obj retain]
#endif

@protocol DVSimpleAudioPlayerDelegate <NSObject>

@optional
- (void)simpleAudioPlayerUpdate:(AVAudioPlayer *)player;
- (void)simpleAudioPlayerPlay:(AVAudioPlayer *)player;
- (void)simpleAudioPlayerStop:(AVAudioPlayer *)player;
- (void)simpleAudioPlayerPause:(AVAudioPlayer *)player;
- (void)simpleAudioPlayerChangeTime:(AVAudioPlayer *)player;
- (void)simpleAudioPlayerChangeVolume:(AVAudioPlayer *)player;

@end

@interface DVSimpleAudioPlayer : NSObject<AVAudioPlayerDelegate>
{
	AVAudioPlayer		*player;

    NSURL               *file;
    NSTimer             *timer;
    BOOL                repeat;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) id<DVSimpleAudioPlayerDelegate> delegate;

- (BOOL)isPlaying;
- (void)setFile:(NSURL *)url;

- (void)startTimer;
- (void)stopTimer;
- (void)timerUpdate;

- (AVAudioPlayer *)getOrCreatePlayer;

- (BOOL)play;
- (void)pause;
- (void)stop;
- (BOOL)setPlayPosition:(NSTimeInterval)time;
- (BOOL)playAtTime:(NSTimeInterval)time;
- (BOOL)setVolume:(float)volume;

@end