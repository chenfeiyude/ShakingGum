//
//  ShareManager.h
//  ShakingGum
//
//  Created by Xiang Xu on 09/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface ShareManager : NSObject

- (id)init : (NSInteger)currentScore;

- (void)shareOnTwitter;
- (void)shareOnFacebook;
- (void)shareOnWeChat;
- (void)shareOnWeibo;

@end
