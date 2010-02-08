#import "OPSSoftLandingWindowController.h"

// stromg constants
NSString * const kOPSSoftLandingNIB = @"SoftLanding";
NSString * const kOPSSoftLandingHTML = @"SoftLanding";
NSString * const kOPSWebViewController = @"webViewController";
NSString * const kOPSSoftLandingNotRequired = @"softLandingNotRequired";

@implementation OPSSoftLandingWindowController
@synthesize webView = _webView;
@synthesize delegate = _delegate;
@synthesize showAgain = _showAgain;

// Displays the soft landing window, unless the preference has been
// turned off
+ (void)showWithDelegate:(id)delegate onlyIfRequired:(BOOL)checkIfRequired
{
	// If the value is not registered then boolForKey: returns NO
	BOOL notRequired = NO;
	
	if( checkIfRequired )
	{
		notRequired = [[NSUserDefaults standardUserDefaults] boolForKey:kOPSSoftLandingNotRequired];
	}

	if( !notRequired )	// During testing, comment out this line to force the landing to be displayed
	{
		OPSSoftLandingWindowController* controller = [[OPSSoftLandingWindowController alloc] initWithWindowNibName:kOPSSoftLandingNIB];
		controller.delegate = delegate;
		[NSApp runModalForWindow:controller.window];
		[controller release];
	}
}

- (void)awakeFromNib
{
	self.showAgain = ![[NSUserDefaults standardUserDefaults] boolForKey:kOPSSoftLandingNotRequired];
	NSString *urlText = [[NSBundle mainBundle] pathForResource:kOPSSoftLandingHTML ofType:@"html"];
	[[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlText]]];
	
	// Tell the script object that we will handle its events
	id scriptObject = [self.webView windowScriptObject];
	[scriptObject setValue:self forKey:kOPSWebViewController];
}

- (void)dealloc
{
	// Probably not necessary, but just in case...
	id scriptObject = [self.webView windowScriptObject];
	[scriptObject removeWebScriptKey:kOPSWebViewController];

	self.webView = nil;
	[super dealloc];
}

- (void)close:(id)sender
{
	// Store the preference for showing the softlanding
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:!self.showAgain] forKey:kOPSSoftLandingNotRequired];
	// Stop the modal loop
	[NSApp stopModal];
	[self close];
}

// Handles the user click event
- (void)notifyWindowController:(NSString*)notificationName
{
	SEL notificationMethod = @selector(softLandingWindowController:didRecieveNotification:);
	if( self.delegate && [self.delegate respondsToSelector:notificationMethod] )
	{
		[self.delegate performSelector:notificationMethod withObject:self withObject:notificationName];
	}
	else
	{
		if( !notificationName )
		{
			notificationName = @"Undefined";
		}
		NSRunAlertPanel( notificationName, @"Please implement softLandingWindowController:didRecieveNotification:"
						" on your delegate.", @"OK", nil, nil);
	}
}

// Only allow notifyWindowController: events to be called on self
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	if( @selector(notifyWindowController:) == aSelector )
	{
		return NO;
	}
	return YES;
}

// Provide this optional method so that the JavaScript can call
// notifyWindowController rather than notifyWindowController_
+ (NSString *)webScriptNameForSelector:(SEL)sel
{
    if( sel == @selector(notifyWindowController:) )
	{
        return @"notifyWindowController";
	}
    return nil;
}

// This method isn't strictly required as we are not accessing any properties
// I have left it for illustration purposes only.
+ (BOOL)isKeyExcludedFromWebScript:(const char*)name
{
	return NO;
}

@end
