#if !os(watchOS)
	import AVFoundation
#endif


internal final class DefaultPageTracker: PageTracker {

	internal typealias Handler = protocol<ActionEventHandler, MediaEventHandler, PageViewEventHandler>

	private let handler: Handler
	
	internal var advertisementProperties = AdvertisementProperties(id: nil)
	internal var ecommerceProperties = EcommerceProperties()
	internal var pageProperties: PageProperties
	internal var variables = [String : String]()


	internal init(handler: Handler, pageName: String) {
		checkIsOnMainThread()

		self.handler = handler

		self.pageProperties = PageProperties(name: pageName)
	}


	internal init(handler: Handler, viewControllerTypeName: String) {
		checkIsOnMainThread()

		self.handler = handler

		self.pageProperties = PageProperties(viewControllerTypeName: viewControllerTypeName)
	}


	internal func trackAction(event: ActionEvent) {
		checkIsOnMainThread()

		handleEvent(event)
	}


	internal func trackMedia(event: MediaEvent) {
		checkIsOnMainThread()

		handleEvent(event)
	}


	internal func trackPageView() {
		checkIsOnMainThread()

		handler.handleEvent(PageViewEvent(
			pageProperties:          pageProperties,
			advertisementProperties: advertisementProperties,
			ecommerceProperties:     ecommerceProperties,
			variables:               variables
		))
	}


	@warn_unused_result
	internal func trackerForMedia(mediaName: String) -> MediaTracker {
		checkIsOnMainThread()

		return DefaultMediaTracker(handler: self, mediaName: mediaName, pageName: nil)
	}


	#if !os(watchOS)
	internal func trackerForMedia(mediaName: String, automaticallyTrackingPlayer player: AVPlayer) -> MediaTracker {
		checkIsOnMainThread()

		let tracker = trackerForMedia(mediaName)
		AVPlayerTracker.track(player: player, with: tracker)

		return tracker
	}
	#endif
}


extension DefaultPageTracker: ActionEventHandler {

	internal func handleEvent(event: ActionEvent) {
		checkIsOnMainThread()

		var event = event
		event.advertisementProperties = event.advertisementProperties.merged(over: advertisementProperties)
		event.ecommerceProperties = event.ecommerceProperties.merged(over: ecommerceProperties)
		event.pageProperties = event.pageProperties.merged(over: pageProperties)
		event.variables = event.variables.merged(over: variables)

		handler.handleEvent(event)
	}
}


extension DefaultPageTracker: MediaEventHandler {

	internal func handleEvent(event: MediaEvent) {
		checkIsOnMainThread()

		var event = event
		event.pageName = event.pageName ?? pageProperties.name
		event.viewControllerTypeName = event.viewControllerTypeName ?? pageProperties.viewControllerTypeName

		handler.handleEvent(event)
	}
}
