//
//  AppDelegate.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "AppDelegate.h"

#import "GAI.h"
#import "BSDefaultViewObject.h"





@implementation AppDelegate

static NSString *deviceToken = nil;
static NSString *tokenId = nil;


@synthesize delegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    

    
    application.applicationIconBadgeNumber = 0;
    
    [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-23653112-28"];

    
    //NSString *failLog = [[NSUserDefaults standardUserDefaults] stringForKey:@"cart"];
    
    //NSSetUncaughtExceptionHandler(&exceptionHandler);

    //ナビゲーションバーのデザイン変更
    [BSDefaultViewObject customNavigationBar:1];
    
    /*
    UIImage *image = [UIImage imageNamed:@"nav_bar.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
     */
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:249.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1]];
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1 green:247 blue:248 alpha:1.0]];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
     
    /*
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor  grayColor],UITextAttributeTextColor,
                                               [UIColor clearColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
     */
    //NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //[attributes setValue:[UIColor darkGrayColor] forKey:UITextAttributeTextColor];
    //[attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    //[[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[BSDefaultViewObject setApiUrl]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }


    
    NSDictionary *userInfo
    = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        // ここに処理
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"AppDelegate"
                                                         withAction:@"pushLaunch"
                                                          withLabel:nil
                                                          withValue:@100];
    }
    
    
    NSSetUncaughtExceptionHandler(&exceptionHandler);

     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;

    NSString *session_id = [BSLoginViewController sessions];
    NSString *url1 = [NSString stringWithFormat:@"http://api.base0.info/users/sign_out?session_id=%@&=",session_id];
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"ゆーあーるえる%@",url1);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ログイン情報！: %@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) devToken
{
    NSLog(@"deviceToken: %@", devToken);
    [self sendProviderDeviceToken:devToken]; // 自分のサーバーに送信する
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *) err
{
    NSLog(@"Errorinregistration.Error:%@", err);
}


- (void)sendProviderDeviceToken:(NSData *)token
{
    
    //NSString *deviceToken= [[NSString alloc] initWithData:token encoding:NSUTF8StringEncoding];
    //NSLog(@"deviceToken: %@", deviceToken);
    /*
    NSMutableData *data = [NSMutableData data];
    [data appendData:[@"device=" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:token];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://morning-relay.com/push"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
    */
    
    //NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //if (token)[parameters setObject:[NSString stringWithFormat:@"%@",token] forKey:@"token"];
    deviceToken = [NSString stringWithFormat:@"%@",token];
    
    NSLog(@"おせてsssssます%@",deviceToken);
    NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?token=%@",[BSDefaultViewObject setApiUrl],[NSString stringWithFormat:@"%@",token]];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"sendProviderDeviceToken%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"トークンの取得: %@", JSON);
        tokenId = [JSON valueForKeyPath:@"result.PushNotification.apn_token_id"];
        NSLog(@"ぷっしゅのいｄ%@",tokenId);
        
        NSString *errorMessage = [JSON valueForKeyPath:@"error.message"];
        NSLog(@"%@",errorMessage);
        
        //BSBuyTopViewController *apnDelegate = [[BSBuyTopViewController alloc]init];
        //[apnDelegate connectFollowShops];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    
}


- (void)getApnToken
{
    
    NSLog(@"getApnTokenす%@",deviceToken);
    NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?token=%@",[BSDefaultViewObject setApiUrl],deviceToken];
    NSLog(@"おgetApnTokenます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"UgetApnTokenあああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"トークンの取得: %@", JSON);
        tokenId = [JSON valueForKeyPath:@"result.PushNotification.apn_token_id"];
        NSLog(@"ぷっしゅのいｄ%@",tokenId);
        //[self.delegate connectFollowShops];
        NSString *errorMessage = [JSON valueForKeyPath:@"error.message"];
        NSLog(@"%@",errorMessage);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateInactive)
    {
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"AppDelegate"
                                                         withAction:@"pushLaunch"
                                                          withLabel:nil
                                                          withValue:@100];
    }
    
    NSString *badge = userInfo[@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    int currentBadgeNumber = application.applicationIconBadgeNumber;
    currentBadgeNumber += [userInfo[@"badge"] integerValue];
    application.applicationIconBadgeNumber = currentBadgeNumber;
}

+(NSString*)getDeviceToken{
    return deviceToken;
}


+(NSString*)getTokenId{
    return tokenId;
}

@end
