# AVAssetResourceLoaderDelegate Demo

In this repository I am attempting to play/stream a video using AVResourceLoader.

AVPlayer will load and play the video on it own if the URL scheme is "**https**"; basically a known URL scheme. Hence first the URL scheme is modified to "**customhttps**". The AVPlayer will reach out/call `AVAssetResourceLoaderDelegate`'s `resourceLoader(_:shouldWaitForLoadingOfRequestedResource:)` function.
The `loadingRequest` has two types of requests:
1. **contentInformationRequest** 
2. **dataRequest**

To toggle between custom scheme and **http** scheme a variable `isCustomScheme` is defined in the `class ViewController`. It is set to `true`. You can make it false and you would be able to play the video. 
The video URL is: https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8 

At present the function  `resourceLoader(_:shouldWaitForLoadingOfRequestedResource:)` is invoked 7-9 times, cancelled twice and processed successfully remaining times. 

Some questions or my current debugging focus is on:
1. Why all loading request have **contentInformationRequest**?
2. Why the response header do not have `Content-Length` and `Content-Type` fields?
3. What is the right value of contentType?