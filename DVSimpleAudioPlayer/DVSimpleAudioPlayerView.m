
#import "DVSimpleAudioPlayerView.h"

@implementation DVSimpleAudioPlayerView

//@synthesize gradientLayer;

- (UIView *)show:(NSTimeInterval)time display:(eAudioPlayerDisplay)showAs position:(eAudioPlayerPosition)position
{
    if (!self.superview)
        return nil;

    CGRect frame = self.bounds;
    if (eAudioPlayerDisplayFade == showAs)
    {
        self.alpha = 0;
    }

    switch (position) {
        case eAudioPlayerPositionTop:
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            if (eAudioPlayerDisplaySlide == showAs)
            {
                frame.origin.y = -frame.size.height;
                self.frame = frame;
                frame.origin.y = 0;
            }
            else
            {
                frame.origin.y = 0;
                self.frame = frame;
            }
            break;
        case eAudioPlayerPositionLeft:
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            if (eAudioPlayerDisplaySlide == showAs)
            {
                frame.origin.x = -frame.size.width;
                self.frame = frame;
                frame.origin.x = 0;
            }
            else
            {
                frame.origin.x = 0;
                self.frame = frame;
            }
            break;
        case eAudioPlayerPositionRight:
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            if (eAudioPlayerDisplaySlide == showAs)
            {
                frame.origin.x = self.superview.bounds.size.width;
                self.frame = frame;
                frame.origin.x = self.superview.bounds.size.width - frame.size.height;
            }
            else
            {
                frame.origin.x = self.superview.bounds.size.width - frame.size.height;
                self.frame = frame;
            }
            break;
        case eAudioPlayerPositionBottom:
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            if (eAudioPlayerDisplaySlide == showAs)
            {
                frame.origin.y = self.bounds.origin.y + self.superview.bounds.size.height;
                self.frame = frame;
                frame.origin.y = self.bounds.origin.y + self.superview.bounds.size.height - frame.size.height;
            }
            else
            {
                frame.origin.y = self.bounds.origin.y + self.superview.bounds.size.height - frame.size.height;
                self.frame = frame;
            }
            break;
        default:
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (eAudioPlayerDisplaySlide == showAs)
            {
                frame.origin.y = -frame.size.height;
                self.frame = frame;
            }
            else
            {
                self.center = self.superview.center;
            }
            break;
    }
    
    [UIView animateWithDuration:time animations:^{
        if (eAudioPlayerPositionCenter == position)
        {
            self.center = self.superview.center;
        }
        else
        {
            self.frame = frame;
        }
        self.alpha = 1;
    }];
    
    return self;
}

- (UIView *)show:(eAudioPlayerDisplay)showAs position:(eAudioPlayerPosition)position
{
    return [self show:0.8f display:showAs position:position];
}

- (UIView *)show
{
    return [self show:eAudioPlayerDisplayFade position:eAudioPlayerPositionBottom];
}

- (id)initWithView:(UIView *)view
{
    CGRect frame = view.bounds;
    frame.size.height = 60;
    frame.origin.y = -60;
    if (nil != (self=[super initWithFrame:frame]))
    {
        [self initPlayerControl];
        [view addSubview:self];
        [view bringSubviewToFront:self];
    }
    return self;
}

- (void)initPlayerControl
{
//	gradientLayer = [[CAGradientLayer alloc] init];
//	gradientLayer.frame = self.bounds;
//	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, nil];
//	gradientLayer.zPosition = INT_MAX;
    //[self.layer addSublayer:gradientLayer];
    
    // Add play/stop button
    self.buttonPlayPause = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.buttonPlayPause.frame = CGRectMake(10, self.bounds.size.height/2-15, 30, 30);
    self.buttonPlayPause.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.buttonPlayPause setImage:[UIImage imageNamed:@"Images/dvspPlay.png"] forState:UIControlStateNormal];
    [self addSubview:self.buttonPlayPause];
    
    // Add progress block
    self.sliderTime = [[UISlider alloc] initWithFrame:CGRectMake(90, self.bounds.size.height/2-10, self.bounds.size.width-150, 20)];
    self.sliderTime.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.sliderTime.minimumValue = 0.0f;
    self.sliderTime.maximumValue = 100.0f;
    self.sliderTime.value = 0;
    self.sliderTime.alpha = 1;
    [self addSubview:self.sliderTime];
    
    // Set time passed
    self.timePassed = [[UILabel alloc] initWithFrame:CGRectMake(46, self.bounds.size.height/2-10, 40, 20)];
    self.timePassed.backgroundColor = [UIColor clearColor];
    self.timePassed.textColor = [UIColor whiteColor];
    self.timePassed.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.timePassed];
    
    // Set time left
    self.timeLeft = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, self.bounds.size.height/2-10, 40, 20)];
    self.timeLeft.backgroundColor = [UIColor clearColor];
    self.timeLeft.textColor = [UIColor whiteColor];
    self.timeLeft.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.timeLeft];
    
    [self configureView];
}

//- (void)layoutSubviews
//{
//    gradientLayer.frame = self.bounds;
//}

#pragma mark -
#pragma mark Simple audio player delegate

- (void)simpleAudioPlayerPlay:(AVAudioPlayer *)pl
{
    [self.buttonPlayPause setImage:[UIImage imageNamed:@"Images/dvspPause.png"] forState:UIControlStateNormal];
}

- (void)simpleAudioPlayerStop:(AVAudioPlayer *)pl
{
    [super simpleAudioPlayerStop:pl];
    [self.buttonPlayPause setImage:[UIImage imageNamed:@"Images/dvspPlay.png"] forState:UIControlStateNormal];
}

- (void)simpleAudioPlayerPause:(AVAudioPlayer *)pl
{
    [self.buttonPlayPause setImage:[UIImage imageNamed:@"Images/dvspPlay.png"] forState:UIControlStateNormal];
}

@end
