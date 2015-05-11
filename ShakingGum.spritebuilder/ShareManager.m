//
//  ShareManager.m
//  ShakingGum
//
//  Created by Xiang Xu on 09/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ShareManager.h"
#import "AppDelegate.h"

@implementation ShareManager
{
    NSInteger score;
    AppController *app;
    NSString *app_link;
}

- (id)init : (NSInteger)currentScore
{
    self = [super init];
    
    if(self)
    {
        app = (((AppController*)[UIApplication sharedApplication].delegate));
        score = currentScore;
        app_link = @"https://itunes.apple.com/";
    }
    
    return self;
}

- (void)shareOnTwitter
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if(result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                NSLog(@"Done");
            }
            
            [app.navController dismissViewControllerAnimated:YES completion:Nil];
        };
        
        controller.completionHandler =myBlock;
        
        [controller addImage:[self screenshot]];
        //Adding the Text to the twitter post value from iOS
        [controller setInitialText:[NSString stringWithFormat:@"Check out my highscore of ShakingGum!: %ld #ShakingGum",(long)score]];
        
        //Adding the URL to the twitter post value from iOS
        [controller addURL:[NSURL URLWithString:app_link]];
        
        [app.navController presentViewController:controller animated:NO completion:Nil];
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a post right now, make sure your device has an Internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

- (void)shareOnFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                
                NSLog(@"Cancelled");
            }
            else
            {
                NSLog(@"Done");
            }
            
            [app.navController dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller addImage:[self screenshot]];
        
        //Adding the URL to the facebook post value from iOS
        [controller addURL:[NSURL URLWithString:app_link]];
        
        [app.navController presentViewController:controller animated:NO completion:Nil];
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a post right now, make sure your device has an Internet connection and you have at least one Facebook account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)shareOnWeChat
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Share your score to WeChat will coming soon" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void)shareOnWeibo
{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if(result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                NSLog(@"Done");
            }
            
            [app.navController dismissViewControllerAnimated:YES completion:Nil];
        };
        
        controller.completionHandler =myBlock;
        
        [controller addImage:[self screenshot]];
        //Adding the Text to the weibo post value from iOS
        [controller setInitialText:[NSString stringWithFormat:@"Check out my highscore of ShakingGum!: %ld #ShakingGum",(long)score]];
        
        //Adding the URL to the weibo post value from iOS
        [controller addURL:[NSURL URLWithString:app_link]];
        
        [app.navController presentViewController:controller animated:NO completion:Nil];
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a post right now, make sure your device has an Internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

// get screen shot
- (UIImage *) screenshot
{
    UIGraphicsBeginImageContextWithOptions(app.navController.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [app.navController.view drawViewHierarchyInRect:app.navController.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
