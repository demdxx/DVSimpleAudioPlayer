
#import "DVSimpleAudioPlayerBaseView.h"

@implementation DVSimpleAudioPlayerBaseView
{
    BOOL    changeStarted;
}

@synthesize buttonPlayPause;
@synthesize sliderTime;
@synthesize timePassed;
@synthesize timeLeft;

- (id)initWithFrame:(CGRect)frame
{
    if (nil != (self=[super initWithFrame:frame]))
    {
        player = [[DVSimpleAudioPlayer alloc] init];
        player.delegate = self;
        changeStarted = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (nil != (self=[super initWithCoder:aDecoder]))
    {
        player = [[DVSimpleAudioPlayer alloc] init];
        player.delegate = self;
        changeStarted = NO;
    }
    return self;
}

#if !__has_feature(objc_arc)

- (void)dealloc
{
    [super dealloc];
    [player release];
}

#endif

- (void)configureView
{
    if (buttonPlayPause)
    {
        [buttonPlayPause addTarget:self
                            action:@selector(onPlay:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (sliderTime)
    {
        sliderTime.value = 0;
        sliderTime.maximumValue = 100;
        sliderTime.enabled = NO;

        [sliderTime addTarget:self
                       action:@selector(onChangeTimeBegin:)
             forControlEvents:UIControlEventTouchDown];
        [sliderTime addTarget:self
                       action:@selector(onChangeTimeEnd:)
             forControlEvents:UIControlEventTouchUpInside];
        [sliderTime addTarget:self
                       action:@selector(onChangeTimeEnd:)
             forControlEvents:UIControlEventTouchUpOutside];
    }
    
    [self updateTime];
}

- (void)updateTime
{
    AVAudioPlayer *p = player.player;
    if (timePassed)
    {
        if (p)
        {
            timePassed.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
        }
        else
        {
            timePassed.text = @"0:00";
        }
    }
    if (timeLeft)
    {
        if (p)
        {
            timeLeft.text = [NSString stringWithFormat:@"-%d:%02d", (int)((int)(p.duration - p.currentTime)) / 60, (int)((int)(p.duration - p.currentTime)) % 60, nil];
        }
        else
        {
            timeLeft.text = @"-0:00";
        }
    }
    if (!changeStarted && p && sliderTime)
    {
        sliderTime.value = p.currentTime;
    }
}

- (void)setFile:(NSURL *)url
{
    return [player setFile:url];
}

- (BOOL)isPlaying
{
    return [player isPlaying];
}

- (BOOL)isPause
{
    AVAudioPlayer *p = player.player;
    return p && sliderTime
             && ![player isPlaying]
             && p.duration==sliderTime.value;
}

- (BOOL)play
{
    if ([player isPlaying])
    {
        [player pause];
        return YES;
    }
    else
    {
        AVAudioPlayer *p = [player getOrCreatePlayer];
        if (p)
        {
            if (sliderTime)
            {
                // Rounding off with an error
                if ((int)(sliderTime.maximumValue * 100) == (int)(p.duration * 100))
                {
                    p.currentTime = (NSTimeInterval)sliderTime.value;
                }
                else
                {
                    sliderTime.maximumValue = p.duration;
                    sliderTime.value = 0;
                }
            }
            return sliderTime.enabled = [player play];
        }
    }
    return NO;
}

#pragma mark -
#pragma mark Events

- (void)onPlay:(id)sender
{
    [self play];
}

- (void)onChangeTimeBegin:(id)sender
{
    changeStarted = YES;
}

- (void)onChangeTimeEnd:(id)sender
{
    changeStarted = NO;
    [player setPlayPosition:(NSTimeInterval)sliderTime.value];
    [self updateTime];
}

#pragma mark -
#pragma mark DVSimpleAudioPlayer delegate

- (void)simpleAudioPlayerUpdate:(AVAudioPlayer *)pl
{
    [self updateTime];
}

- (void)simpleAudioPlayerPlay:(AVAudioPlayer *)pl
{
    [self updateTime];
}

- (void)simpleAudioPlayerStop:(AVAudioPlayer *)pl
{
    if (sliderTime)
        sliderTime.value = pl.currentTime;
    [self updateTime];
}

@end
