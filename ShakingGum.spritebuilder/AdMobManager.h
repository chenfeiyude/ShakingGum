//
//  AdMobManager.h
//  ShakingGum
//
//  Created by Xiang Xu on 11/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@import GoogleMobileAds;

@interface AdMobManager : NSObject <GADBannerViewDelegate>
{
    GADBannerView *_adBannerView;
}

-(void) hideAd;

@end
