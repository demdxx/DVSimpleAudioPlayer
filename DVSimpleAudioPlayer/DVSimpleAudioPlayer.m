#import "DVSimpleAudioPlayer.h"

@implementation DVSimpleAudioPlayer

@synthesize player;

- (id)init
{
    if (nil != (self=[super init]))
    {
    }
    return self;
}

#if !__has_feature(objc_arc)

- (void)dealloc
{
    [player release];
    [self stopTimer];
    [super dealloc];
}

#endif

- (BOOL)isPlaying
{
    return player ? [player isPlaying] : NO;
}

- (void)setFile:(NSURL *)url
{
    if (player)
    {
        [self stop];
        PO_OBJECT_RELEASE(player);
    }
    file = url;
}

#pragma mark -
#pragma mark Control timer

- (void)startTimer
{
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
    else if (![player isPlaying])
    {
        [self stopTimer];
    }
}

- (void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        PO_OBJECT_RELEASE(timer);
    }
}

- (void)timerUpdate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerUpdate:)])
    {
        [self.delegate simpleAudioPlayerUpdate:player];
    }
}

#pragma mark -
#pragma mark Player control

- (AVAudioPlayer *)getOrCreatePlayer
{
    if (!player)
    {
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&error];
        player.delegate = self;
        if (error)
        {
            NSLog(@"%@", error);
            return nil;
        }
    }
    return player;
}

- (BOOL)play
{
    if (!file || nil==[self getOrCreatePlayer])
        return NO;

    if ([player play])
    {
        [self startTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerPlay:)])
        {
            [self.delegate simpleAudioPlayerPlay:player];
        }
        return YES;
    }
    return NO;
}

- (void)pause
{
    if (player && [player isPlaying])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerPause:)])
        {
            [self.delegate simpleAudioPlayerPause:player];
        }
        [player pause];
        [self stopTimer];
    }
}

- (void)stop
{
    if (player)
    {
        [player stop];
        [self stopTimer];
    }
}

- (BOOL)setPlayPosition:(NSTimeInterval)time
{
    if (!file || nil==[self getOrCreatePlayer])
        return NO;
    if (player)
    {
        player.currentTime = MIN(time, player.duration);
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerChangeTime:)])
        {
            [self.delegate simpleAudioPlayerChangeTime:player];
        }
        return YES;
    }
    return NO;
}

- (BOOL)playAtTime:(NSTimeInterval)time
{
    if (!file || nil==[self getOrCreatePlayer])
        return NO;
    if (time>0 && player)
        return [player playAtTime:time];
    return NO;
}

- (BOOL)setVolume:(float)volume
{
    if (!file || nil==[self getOrCreatePlayer])
        return NO;
    if (volume>=0 && player)
    {
        player.volume = MIN(volume, 1.0f);
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerChangeVolume:)])
        {
            [self.delegate simpleAudioPlayerChangeVolume:player];
        }
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark AVAudioPlayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(simpleAudioPlayerStop:)])
    {
        [self.delegate simpleAudioPlayerStop:p];
    }

	if (repeat)
    {
        p.currentTime = 0.0f;
        [p play];
        [self startTimer];
    }
    else
    {
        [self stopTimer];
    }
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error);

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Decode Error" 
														message:[NSString stringWithFormat:@"Unable to decode audio file with error: %@", [error localizedDescription]] 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	PO_OBJECT_RELEASE(alertView);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
	// perform any interruption handling here
	NSLog(@"(apbi) Interruption Detected");
	[[NSUserDefaults standardUserDefaults] setFloat:[p currentTime] forKey:@"Interruption"];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	// resume playback at the end of the interruption
	NSLog(@"(apei) Interruption ended");
	[self play];

	// remove the interruption key. it won't be needed
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Interruption"];
}

@end
