// Helper class for displaying a soft landing window
//
// To use, call showIfRequired: from an appropriate location in your application
// (e.g. from applicationDidFinishLaunching) passing in a delegate.
// The delegate should implement the following method
// - (void)softLandingWindowController:(SoftLandingWindowController*) didRecieveNotification:(NSString*)notification;
// to handle notification events from JavaScript in the webview.
//
// Call close: (with the colon) to dismiss the window from code
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

// The user may choose not to show the soft landing page again.
// This is the key under which it is stored.
extern NSString * const kOPSSoftLandingNotRequired;

@interface OPSSoftLandingWindowController : NSWindowController
{
	WebView *_webView;
	id _delegate;
	BOOL _showAgain;
}

// Properties
@property (nonatomic,retain) IBOutlet WebView *webView;
@property (nonatomic,retain) id delegate;
@property (nonatomic,assign) BOOL showAgain;

// instance methods
- (IBAction)close:(id)sender;
- (void)notifyWindowController:(NSString*)notificationName;

// class methods
+ (void)showWithDelegate:(id)delegate onlyIfRequired:(BOOL)checkIfRequired;

@end
