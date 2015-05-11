//
//  AdMobManager.m
//  ShakingGum
//
//  Created by Xiang Xu on 11/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AdMobManager.h"

@implementation AdMobManager

- (id)init
{
    self = [super init];
    
    if(self)
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"whetherDisplayAd"])
        {
            _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            [_adBannerView setDelegate:self];
            [_adBannerView setRootViewController:self];
            _adBannerView.adUnitID = @"ca-app-pub-6213504588448379/4259759243";
            [_adBannerView loadRequest:[GADRequest request]];
        }
        
    }
    
    return self;
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGRect frame = _adBannerView.frame;
    frame.origin.y = screenSize.size.height -_adBannerView.frame.size.height;
    frame.origin.x = 0.0f;
    
    _adBannerView.frame = frame;
    
    [_adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    AppController *app = (((AppController*) [UIApplication sharedApplication].delegate));
    [app.navController.view addSubview:_adBannerView];

}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

-(void) hideAd
{
    if (_adBannerView != nil)
    {
        _adBannerView.alpha = 0.0;
    }
}

@end
