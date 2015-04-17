//
//  GameOver.m
//  ShakingGum
//
//  Created by chenfeiyu on 16/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
#import <Social/Social.h>
#import "AppDelegate.h"

@implementation GameOver
{
    CCLabelTTF *_finalScore;
    NSInteger score;
}

- (void)didLoadFromCCB
{
    score = [[NSUserDefaults standardUserDefaults] integerForKey:@"FinalScore"];
    [_finalScore setString:[NSString stringWithFormat:@"Score: %ld", (long)score]];

}

- (void)playAgain
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void)ShareOnFaceBook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        AppController * app = (((AppController*)[UIApplication sharedApplication].delegate));
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                
                NSLog(@"Cancelled");
            } else
                
            {
                NSLog(@"Done");
            }
            
            [app.navController dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller addImage:[self screenshot]];
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:[NSString stringWithFormat:@"Check out my highscore of ShakingGum!: %ld #ShakingGum",(long)score]];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:@"https://itunes.apple.com/"]];
    
        [app.navController presentViewController:controller animated:NO completion:Nil];
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// get screen shot
- (UIImage *) screenshot
{
    AppController* app = (((AppController*)[UIApplication sharedApplication].delegate));
    UIGraphicsBeginImageContextWithOptions(app.navController.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [app.navController.view drawViewHierarchyInRect:app.navController.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
