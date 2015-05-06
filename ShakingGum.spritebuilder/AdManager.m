//
//  AdManager.m
//  ShakingGum
//
//  Implemented by XiangXu
//  Created by chenfeiyu on 06/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AdManager.h"

@implementation AdManager

-(id)init
{
    self = [super init];
    
    if (self)
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"whetherDisplayAd"])
        {
            // iAd initialise
            _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
            _adBannerView.delegate = self;
        }
        
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        CGRect frame = _adBannerView.frame;
        frame.origin.y = screenSize.size.height -_adBannerView.frame.size.height;
        frame.origin.x = 0.0f;
        
        _adBannerView.frame = frame;
        
        [_adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        AppController *app = (((AppController*) [UIApplication sharedApplication].delegate));
        [app.navController.view addSubview:_adBannerView];
    }
    
    return self;
}

-(void) hideAd{
    if (_adBannerView != nil) {
        _adBannerView.alpha = 0.0;
    }
}

#pragma mark iAd Delegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // Hide the ad banner.
    if (_adBannerView != nil) {
        _adBannerView.alpha = 0.0;
    }
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^
     {
         if (_adBannerView != nil) {
             _adBannerView.alpha = 0.0;
         }
         
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"whetherDisplayAd"];
         [[NSUserDefaults standardUserDefaults] synchronize];
     }];
}

@end
