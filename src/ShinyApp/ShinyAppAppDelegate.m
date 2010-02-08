//
//  ShinyAppAppDelegate.m
//  ShinyApp
//
//  Created by Gavin on 07/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShinyAppAppDelegate.h"
#import "OPSSoftLandingWindowController.h"

@implementation ShinyAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:YES];
}

- (void)softLandingWindowController:(OPSSoftLandingWindowController*)softLanding didRecieveNotification:(NSString*)notification
{
	NSRunAlertPanel( notification, @"OH HAI", @"OK", nil, nil);
}

- (IBAction)showWelcome:(id)sender
{
	[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:NO];
}

@end
