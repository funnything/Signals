//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// Extends UIControl with signals for all ui control events.
public extension UIControl {
    /// A signal that fires for each touch down control event.
    var onTouchDown: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDown)
    }

    /// A signal that fires for each touch down repeat control event.
    var onTouchDownRepeat: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDownRepeat)
    }

    /// A signal that fires for each touch drag inside control event.
    var onTouchDragInside: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDragInside)
    }

    /// A signal that fires for each touch drag outside control event.
    var onTouchDragOutside: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDragOutside)
    }

    /// A signal that fires for each touch drag enter control event.
    var onTouchDragEnter: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDragEnter)
    }

    /// A signal that fires for each touch drag exit control event.
    var onTouchDragExit: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchDragExit)
    }

    /// A signal that fires for each touch up inside control event.
    var onTouchUpInside: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchUpInside)
    }

    /// A signal that fires for each touch up outside control event.
    var onTouchUpOutside: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchUpOutside)
    }

    /// A signal that fires for each touch cancel control event.
    var onTouchCancel: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.touchCancel)
    }

    /// A signal that fires for each value changed control event.
    var onValueChanged: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.valueChanged)
    }

    /// A signal that fires for each editing did begin control event.
    var onEditingDidBegin: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.editingDidBegin)
    }

    /// A signal that fires for each editing changed control event.
    var onEditingChanged: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.editingChanged)
    }

    /// A signal that fires for each editing did end control event.
    var onEditingDidEnd: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.editingDidEnd)
    }

    /// A signal that fires for each editing did end on exit control event.
    var onEditingDidEndOnExit: Signal<UIEvent?> {
        return getOrCreateSignalForUIControlEvent(.editingDidEndOnExit)
    }

    // MARK: - Private interface

    private struct AssociatedKeys {
        static var SignalDictionaryKey = "signals_signalKey"
    }

    private static let eventToKey: [UIControl.Event: NSString] = [
        .touchDown: "TouchDownSender:forEvent:",
        .touchDownRepeat: "TouchDownRepeatSender:forEvent:",
        .touchDragInside: "TouchDragInsideSender:forEvent:",
        .touchDragOutside: "TouchDragOutsideSender:forEvent:",
        .touchDragEnter: "TouchDragEnterSender:forEvent:",
        .touchDragExit: "TouchDragExitSender:forEvent:",
        .touchUpInside: "TouchUpInsideSender:forEvent:",
        .touchUpOutside: "TouchUpOutsideSender:forEvent:",
        .touchCancel: "TouchCancelSender:forEvent:",
        .valueChanged: "ValueChangedSender:forEvent:",
        .editingDidBegin: "EditingDidBeginSender:forEvent:",
        .editingChanged: "EditingChangedSender:forEvent:",
        .editingDidEnd: "EditingDidEndSender:forEvent:",
        .editingDidEndOnExit: "EditingDidEndOnExitSender:forEvent:"
    ]

    private func getOrCreateSignalForUIControlEvent(_ event: UIControl.Event) -> Signal<UIEvent?> {
        guard let key = UIControl.eventToKey[event] else {
            assertionFailure("Event type is not handled")
            return Signal()
        }
        let dictionary = getOrCreateAssociatedObject(self, associativeKey: &AssociatedKeys.SignalDictionaryKey, defaultValue: NSMutableDictionary(), policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        if let signal = dictionary[key] as? Signal<UIEvent?> {
            return signal
        } else {
            let signal = Signal<UIEvent?>()
            dictionary[key] = signal
            self.addTarget(self, action: Selector("eventHandler\(key)"), for: event)
            return signal
        }
    }

    private func handleUIControlEvent(_ uiControlEvent: UIControl.Event, event: UIEvent?) {
        getOrCreateSignalForUIControlEvent(uiControlEvent).fire(event)
    }

    @objc private dynamic func eventHandlerTouchDown(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDown, event: event)
    }

    @objc private dynamic func eventHandlerTouchDownRepeat(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDownRepeat, event: event)
    }

    @objc private dynamic func eventHandlerTouchDragInside(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDragInside, event: event)
    }

    @objc private dynamic func eventHandlerTouchDragOutside(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDragOutside, event: event)
    }

    @objc private dynamic func eventHandlerTouchDragEnter(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDragEnter, event: event)
    }

    @objc private dynamic func eventHandlerTouchDragExit(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchDragExit, event: event)
    }

    @objc private dynamic func eventHandlerTouchUpInside(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchUpInside, event: event)
    }

    @objc private dynamic func eventHandlerTouchUpOutside(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchUpOutside, event: event)
    }

    @objc private dynamic func eventHandlerTouchCancel(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.touchCancel, event: event)
    }

    @objc private dynamic func eventHandlerValueChanged(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.valueChanged, event: event)
    }

    @objc private dynamic func eventHandlerEditingDidBegin(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.editingDidBegin, event: event)
    }

    @objc private dynamic func eventHandlerEditingChanged(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.editingChanged, event: event)
    }

    @objc private dynamic func eventHandlerEditingDidEnd(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.editingDidEnd, event: event)
    }

    @objc private dynamic func eventHandlerEditingDidEndOnExit(sender: UIControl, forEvent event: UIEvent?) {
        handleUIControlEvent(.editingDidEndOnExit, event: event)
    }
}

extension UIControl.Event: Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
}

public extension UIView {
    func addGestureRecognizerForSignal(_ gestureRecognizer: UIGestureRecognizer) -> Signal<UIGestureRecognizer> {
        return createSignalForUIGestureReconizer(gestureRecognizer)
    }

    private struct AssociatedKeys {
        static var SignalDictionaryKey = "signals_signalKey"
    }

    private func createSignalForUIGestureReconizer(_ gestureRecognizer: UIGestureRecognizer) -> Signal<UIGestureRecognizer> {
        let signal = Signal<UIGestureRecognizer>()
        gestureRecognizerSignals.add((gestureRecognizer, signal))

        gestureRecognizer.addTarget(self, action: #selector(eventHandlerGestureRecognizer(_:)))
        addGestureRecognizer(gestureRecognizer)

        return signal
    }

    private var gestureRecognizerSignals: NSMutableArray {
        let key = "GestureRecognizerSignals"

        let dictionary = getOrCreateAssociatedObject(self, associativeKey: &AssociatedKeys.SignalDictionaryKey, defaultValue: NSMutableDictionary(), policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        if let gestures = dictionary[key] as? NSMutableArray {
            return gestures
        }

        let gestures = NSMutableArray()
        dictionary[key] = gestures
        return gestures
    }

    @objc private dynamic func eventHandlerGestureRecognizer(_ sender: UIGestureRecognizer) {
        typealias ArrayItem = (gestureRecognizer: UIGestureRecognizer, signal: Signal<UIGestureRecognizer>)

        (gestureRecognizerSignals as! [ArrayItem]).first { $0.gestureRecognizer == sender }!.signal.fire(sender)
    }
}

#endif
