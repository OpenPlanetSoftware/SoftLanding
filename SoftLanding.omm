Providing a soft landing with WebKit

So your user has just downloaded your shiny new application. Like all your applications you’ve strived to make it as simple and intuitive as possible yet sitting now in front of your user for the first time it would be nice if it could just give them a little nudge in the right direction. A video tutorial perhaps? Help creating that first project?

What you need is a welcome window, like the one in GarageBand, which pops up the first time a user runs your application. I recently heard this concept described as a Soft Landing (I believe the legendary Matt Gemmell coined the phrase). The expression really appeals to me, it sums up exactly what we want to achieve, giving the user a gentle introduction to our software rather than crashing in head first.

We recently had to implement a soft landing for one of our products. In this post I'll describe the mechanics behind it and as we've open sourced this component, I'll also provide instructions for integrating this component quickly into your own application.

Soft landings tend to be less graphically constrained than the applications they support. A typical Mac application may, for example, have a table or outline view on the left hand side with a more detailed view of the current selection on the right. A welcome screen by contrast may have any arrangement of images and text. It makes sense therefore to use a technology such as HTML to render this content. The question is: how does this HTML interact with the underlying Cocoa application?

The answer is: very easily. WebKit provides a bridge which allows JavaScript to communicate directly with Cocoa objects in your application, sending messages and accessing properties. The first step in setting up this communication is to tell the JavaScript code about your object.

	id scriptObject = [webView windowScriptObject];
	[scriptObject setValue:self forKey:@"cocoaObject"];

The JavaScript code can now access your object as follows:

	var cocoaObject = window.cocoaObject;

Because we do not want script running within a web browser to be able to access any old method or property we now need to provide a couple of class methods to control this access, one for methods and one for properties:

	+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector; 
	+ (BOOL)isKeyExcludedFromWebScript:(const char*)name;

These methods should always return YES unless the passed in selector (or key name) is one for which we want to provide access.

In our example we have also provided one more class method:

	+ (NSString*)webScriptNameForSelector:(SEL)sel

This method lets us provide cleaner method names for JavaScript to use. By default the bridge replaces colons with underscores so the Objective-C call:

	[a setValue:b forKey:c];

Would in JavaScript become:

	a.setValue_forKey_( b, c );

The webScriptNameForSelector: method lets us overwrite the default behaviour to provide our own method names.

Integrating our component.

There are 4 files which you'll need to include in your project:
	OPSSoftLandingWindowController.h
	OPSSoftLandingWindowController.m
	SoftLanding.XIB
	SoftLanding.html

Copy these files to your project and include them in the target. You also need to ensure that your project links with the Webkit framework.

You will need to modify the XIB file to change the text to match your application. There are two places where you need to do this; the title on the Window and the text on the "Show this window" checkbox.

To display the soft landing at startup add the following line at an appropriate location in your code (the applicationDidFinishLaunching: method on your app delegate is probably as good a place as any):

	[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:YES];

This method takes two parameters. The first parameter is a delegate object which will handle any notification messages from the JavaScript. The controller expects the delegate to implement the following method:

	- (void)softLandingWindowController:(OPSSoftLandingWindowController*)softLanding didRecieveNotification:(NSString*)notification;

You may pass nil to the delegate if you only want the soft landing to display some HTML and do not have any messages which may be passed back.

If the user selects not to show the soft landing at application startup there is currently no way for them to see it again. This isn't very nice, so you will probably want to add a menu under Help to allow the user to display the welcome screen again.

	- (IBAction)showWelcome:(id)sender
	{
		[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:NO];
	}

That's it. All that remains is your customisation of the displayed HTML.

The code is distributed under the FreeBSD license (do what you want with it, but don't sue us when it all goes wrong). Enjoy!