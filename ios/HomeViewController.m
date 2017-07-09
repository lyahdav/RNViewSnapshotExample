//
//  HomeViewController.m
//  RNViewSnapshotExample
//
//  Created by Liron Yahdav on 7/7/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HomeViewController.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "RCTViewSnapshotter.h"
#import <React/RCTUIManager.h>
#import <React/RCTDevLoadingView.h>

@interface RootRNViewController : UIViewController

@end

@implementation RootRNViewController

- (void)dealloc
{
    [[RCTViewSnapshotter sharedInstance].viewSnapshots removeAllObjects];
}

@end


@interface RCTUIManager (Private)
- (void)createView:(nonnull NSNumber *)reactTag
          viewName:(NSString *)viewName
           rootTag:(__unused NSNumber *)rootTag
             props:(NSDictionary *)props;
- (void)setChildren:(nonnull NSNumber *)containerTag
          reactTags:(NSArray<NSNumber *> *)reactTags;

@end

@interface HomeViewController () <RCTBridgeDelegate>

@property (nonatomic) id flushObserver;
@end

@implementation HomeViewController

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
    return nil;
}

- (void)loadSourceForBridge:(RCTBridge *)bridge
                  withBlock:(RCTSourceLoadBlock)loadCallback
{
    loadCallback(nil, nil, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapStandardInit:(id)sender {
    NSDate *startLoadDate = [NSDate date];

    // For loading in dev from packager
    NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    
//    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"RNViewSnapshotExample"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    UIViewController *rootViewController = [RootRNViewController new];
    rootViewController.view = rootView;
    rootViewController.title = @"Loading...";
    
    self.flushObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RCTUIManagerFinishedFlushNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDate *endLoadDate = [NSDate date];
        NSTimeInterval loadDuration = [endLoadDate timeIntervalSinceDate:startLoadDate];
        NSString *title = [NSString stringWithFormat:@"%.02fs", loadDuration];
        rootViewController.title = title;
        [[NSNotificationCenter defaultCenter] removeObserver:self.flushObserver];
    }];

    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (IBAction)didTapSnapshotInit:(id)sender {
    NSDate *startLoadDate = [NSDate date];
    
    [RCTDevLoadingView setEnabled:NO];
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString* filePath = [documentsPath stringByAppendingPathComponent:@"view-snapshot.json"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!fileExists) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No snapshot exists"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *viewSnapshots = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    
    NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"RNViewSnapshotExample"
                                                 initialProperties:nil
                                                     launchOptions:nil];

    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view = rootView;
    rootViewController.title = @"Loading...";
    
    [self.navigationController pushViewController:rootViewController animated:YES];

    self.flushObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"RCTUIManagerFinishedFlushNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDate *endLoadDate = [NSDate date];
        NSTimeInterval loadDuration = [endLoadDate timeIntervalSinceDate:startLoadDate];
        NSString *title = [NSString stringWithFormat:@"%.02fs", loadDuration];
        rootViewController.title = title;
        [[NSNotificationCenter defaultCenter] removeObserver:self.flushObserver];
    }];

    // TODO: remove this delay, but causes deadlock or weird rendering w/o it
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        dispatch_async(RCTGetUIManagerQueue(), ^{
            for (NSDictionary *viewSnapshot in viewSnapshots) {
                if ([viewSnapshot[@"type"] isEqualToString:@"create"]) {
                    [rootView.bridge.uiManager createView:viewSnapshot[@"reactTag"] viewName:viewSnapshot[@"viewName"] rootTag:viewSnapshot[@"rootTag"] props:viewSnapshot[@"props"] == [NSNull null] ? @{} : viewSnapshot[@"props"]];
                } else if ([viewSnapshot[@"type"] isEqualToString:@"setChildren"]) {
                    [rootView.bridge.uiManager setChildren:viewSnapshot[@"containerTag"] reactTags:viewSnapshot[@"reactTags"]];
                }
            }
            
            [rootView.bridge.uiManager batchDidComplete];
        });
    });
}

@end
