//
//  AdManager.h
//  ShakingGum
//
//  Implemented by XiangXu
//  Created by chenfeiyu on 06/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface AdManager : NSObject <ADBannerViewDelegate>{
    ADBannerView *_adBannerView;
}

-(void) hideAd;
@end
