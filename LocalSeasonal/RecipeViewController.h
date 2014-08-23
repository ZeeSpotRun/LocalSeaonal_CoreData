//
//  RecipeViewController.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 01/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "DataInit.h"

@interface RecipeViewController : UIViewController <UIWebViewDelegate,
                                                    UIAlertViewDelegate,
                                                    MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NSString *fullURL;

@property (nonatomic, assign) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSURLConnection *retryConn;

@property (nonatomic) BOOL internetActive;

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic) NetworkStatus internetStatus;


-(void) checkNetworkStatus:(NSNotification *)notice;

@end
