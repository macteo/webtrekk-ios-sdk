import Foundation


public final class DefaultTrackingLogger: TrackingLogger {

	public var enabled = true
	public var minimumLevel = TrackingLogLevel.warning


	public func log(@autoclosure message message: () -> String, level: TrackingLogLevel) {
		guard enabled && level.rawValue >= minimumLevel.rawValue else {
			return
		}

		NSLog("%@", "[Webtrekk] [\(level.title)] \(message())")
	}
}


public enum TrackingLogLevel: Int {

	case debug   = 1
	case info    = 2
	case warning = 3
	case error   = 4


	private var title: String {
		switch (self) {
		case .debug:   return "Debug"
		case .info:    return "Info"
		case .warning: return "Warning"
		case .error:   return "ERROR"
		}
	}
}


public protocol TrackingLogger: class {

	func log (@autoclosure message message: () -> String, level: TrackingLogLevel)
}


public extension TrackingLogger {

	public func logDebug(@autoclosure message: () -> String) {
		log(message: message, level: .debug)
	}


	public func logError(@autoclosure message: () -> String) {
		log(message: message, level: .error)
	}


	public func logInfo(@autoclosure message: () -> String) {
		log(message: message, level: .info)
	}


	public func logWarning(@autoclosure message: () -> String) {
		log(message: message, level: .warning)
	}
}
