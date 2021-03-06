DVSimpleAudioPlayer
===================

The basis for a simple player

    @year 2013
    @license CC-BY-3.0
    @copyright Dmitry Ponomarev <demdxx@gmail.com>

![Example](https://raw.github.com/demdxx/DVSimpleAudioPlayer/master/screenshot.png)

Description
===========

Framework: AVFoundation

 * **DVSimpleAudioPlayer** – player object without graphic controls.
 * **DVSimpleAudioPlayerBaseView** – UIView extension include *DVSimpleAudioPlayer*.
 * **DVSimpleAudioPlayerView** – full completed simple audio player. Extension from *DVSimpleAudioPlayerBaseView*.

Example
=======

```objectivec

if (player)
{
    [player play];
}
else
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Jet_KC135_Tanker_PassBy" ofType:@"mp3"];
    player = [[DVSimpleAudioPlayerView alloc] initWithView:self.view];
    player.backgroundColor = [UIColor grayColor];
    [player setFile:[NSURL fileURLWithPath:file]];
    [player show];
    [player play];
}

```

License
=======

<a rel="license" href="http://creativecommons.org/licenses/by/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">NSHelpers</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Dmitry Ponomarev &lt;demdxx@gmail.com&gt;</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/3.0/deed.en_US">Creative Commons Attribution 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/demdxx/DVSimpleAudioPlayer" rel="dct:source">https://github.com/demdxx/DVSimpleAudioPlayer</a>.
