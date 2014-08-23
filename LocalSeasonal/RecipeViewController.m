//
//  RecipeViewController.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 01/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import "RecipeViewController.h"

@interface RecipeViewController ()

@end

@implementation RecipeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    [self configureWebView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    
    self.internetStatus = [self.internetReachable currentReachabilityStatus];
    
    if(self.internetStatus != NotReachable) {
        [self loadAddressURL];
    } else {
        
        NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@</div></body></html>";
        
        NSString *errorHTML = [NSString stringWithFormat:errorFormatString, @"Internet is currently unavailable"];
        [self.webView loadHTMLString:errorHTML baseURL:nil];
        UIAlertView *internetFailureAlert = [[UIAlertView alloc]initWithTitle:@"Internet Connection Status" message:@"Internet is currently unavailable" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Retry",nil];
        
        [internetFailureAlert show];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Email"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(loadEmail)];
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)loadAddressURL {
    
    
    self.request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.fullURL]];
    [self.webView loadRequest:self.request];
}

#pragma mark - Configuration

- (void)configureWebView {
    
    self.webView.backgroundColor = FAV_COLOR;
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self internetError:error];
    
}

-(void) checkNetworkStatus:(NSNotification *)notice {
    
    self.internetStatus = [self.internetReachable currentReachabilityStatus];
    switch (self.internetStatus) {
        case NotReachable:
        {
            NSLog(@"The Internet is Down");
            self.internetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The Internet is Active via WiFi");
            self.internetActive = YES;
            [self loadAddressURL];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The Internet is Active via WWAN");
            self.internetActive = YES;
            [self loadAddressURL];
            break;
        }
    }
}

#pragma mark - Internet Error Methods

-(void)internetError:(NSError*)error {
    
    NSLog(@"Internet Error = %@", error);
    NSString *errString = [[NSString alloc]initWithFormat:@"This screen cannot be loaded due to internet connection failure."];
    
    UIAlertView *internetFailureAlert = [[UIAlertView alloc]initWithTitle:@"Internet Connection Status" message:errString delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Retry",nil];
    
    [internetFailureAlert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self printSearchingNotice];
    }
}

-(void)printSearchingNotice{
    
    NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@</div></body></html>";
    NSString *searchingForInternet = [NSString stringWithFormat:errorFormatString, @"Searching For Internet Availability..."];
    [self.webView loadHTMLString:searchingForInternet baseURL:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

#pragma mark Email Composer Methods

-(void)loadEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *recipeEmail = [[MFMailComposeViewController alloc]init];
        recipeEmail.mailComposeDelegate = self;
        [recipeEmail setSubject:@"Recipes for you"];
        [recipeEmail setMessageBody:[NSString stringWithFormat:@"%@", self.fullURL] isHTML:YES];
        [self presentViewController:recipeEmail animated:YES completion:nil];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];

}


@end
