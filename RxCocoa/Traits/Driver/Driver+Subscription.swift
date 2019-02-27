//
//  Driver+Subscription.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 9/19/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift

private let errorMessage = "`drive*` family of methods can be only called from `MainThread`.\n" +
"This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n"

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    /**
    Creates new subscription and sends elements to observer.
    This method can be only called from `MainThread`.

    In this form it's equivalent to `subscribe` method, but it communicates intent better.

    - parameter observer: Observer that receives events.
    - returns: Disposable object that can be used to unsubscribe the observer from the subject.
    */
    public func drive(_ observer: @escaping ObservableSource<Element, Never, Never>.Observer) -> Disposable {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return self.asSharedSequence().source.subscribe(observer)
    }

    /**
     Creates new subscription and sends elements to observer.
     This method can be only called from `MainThread`.

     In this form it's equivalent to `subscribe` method, but it communicates intent better.

     - parameter observer: Observer that receives events.
     - returns: Disposable object that can be used to unsubscribe the observer from the subject.
     */
    public func drive(_ observer: @escaping ObservableSource<Element?, Never, Never>.Observer) -> Disposable {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return self.asSharedSequence().source.map { $0 as Element? }.subscribe(observer)
    }

    /**
    Creates new subscription and sends elements to `BehaviorRelay`.
    This method can be only called from `MainThread`.

    - parameter relay: Target relay for sequence elements.
    - returns: Disposable object that can be used to unsubscribe the observer from the relay.
    */
//    public func drive(_ relay: BehaviorRelay<E>) -> Disposable {
//        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
//        return self.drive(onNext: { e in
//            relay.accept(e)
//        })
//    }

    /**
     Creates new subscription and sends elements to `BehaviorRelay`.
     This method can be only called from `MainThread`.

     - parameter relay: Target relay for sequence elements.
     - returns: Disposable object that can be used to unsubscribe the observer from the relay.
     */
//    public func drive(_ relay: BehaviorRelay<E?>) -> Disposable {
//        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
//        return self.drive(onNext: { e in
//            relay.accept(e)
//        })
//    }

    /**
    Subscribes to observable sequence using custom binder function.
    This method can be only called from `MainThread`.

    - parameter with: Function used to bind elements from `self`.
    - returns: Object representing subscription.
    */
    public func drive<R>(_ transformation: (ObservableSource<Element, Never, Never>) -> R) -> R {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return transformation(self.source)
    }

    /**
    Subscribes to observable sequence using custom binder function and final parameter passed to binder function
    after `self` is passed.

        public func drive<R1, R2>(with: Self -> R1 -> R2, curriedArgument: R1) -> R2 {
            return with(self)(curriedArgument)
        }

    This method can be only called from `MainThread`.

    - parameter with: Function used to bind elements from `self`.
    - parameter curriedArgument: Final argument passed to `binder` to finish binding process.
    - returns: Object representing subscription.
    */
    public func drive<R1, R2>(_ with: (ObservableSource<Element, Never, Never>) -> (R1) -> R2, curriedArgument: R1) -> R2 {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return with(self.source)(curriedArgument)
    }
    
    /**
    Subscribes an element handler, a completion handler and disposed handler to an observable sequence.
    This method can be only called from `MainThread`.
    
    Error callback is not exposed because `Driver` can't error out.
    
    - parameter onNext: Action to invoke for each element in the observable sequence.
    - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
    gracefully completed, errored, or if the generation is canceled by disposing subscription)
    - parameter onDisposed: Action to invoke upon any type of termination of sequence (if the sequence has
    gracefully completed, errored, or if the generation is canceled by disposing subscription)
    - returns: Subscription object used to unsubscribe from the observable sequence.
    */
    public func drive(onNext: ((Element) -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return self.source.subscribe(onNext: onNext, onDisposed: onDisposed)
    }
}


