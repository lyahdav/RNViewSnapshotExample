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
    // Do any additional setup after loading the view.
}

- (IBAction)didTapStandardInit:(id)sender {
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"RNViewSnapshotExample"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    UIViewController *rootViewController = [RootRNViewController new];
    rootViewController.view = rootView;
    
    [self.navigationController pushViewController:rootViewController animated:YES];
}

- (IBAction)didTapSnapshotInit:(id)sender {
    [RCTDevLoadingView setEnabled:NO];
    
    RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];

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
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:@"RNViewSnapshotExample" initialProperties:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view = rootView;
    
    [self.navigationController pushViewController:rootViewController animated:YES];

    // TODO: remove this delay, but causes deadlock or weird rendering w/o it
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        dispatch_async(RCTGetUIManagerQueue(), ^{
            for (NSDictionary *viewSnapshot in viewSnapshots) {
                if ([viewSnapshot[@"type"] isEqualToString:@"create"]) {
                    [bridge.uiManager createView:viewSnapshot[@"reactTag"] viewName:viewSnapshot[@"viewName"] rootTag:viewSnapshot[@"rootTag"] props:viewSnapshot[@"props"] == [NSNull null] ? @{} : viewSnapshot[@"props"]];
                } else if ([viewSnapshot[@"type"] isEqualToString:@"setChildren"]) {
                    [bridge.uiManager setChildren:viewSnapshot[@"containerTag"] reactTags:viewSnapshot[@"reactTags"]];
                }
            }
            
            [bridge.uiManager batchDidComplete];
        });
    });
    

}

@end
