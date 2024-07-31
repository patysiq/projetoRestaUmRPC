//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: oneLeft.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate `Chat_ChatClient`, then call methods of this protocol to make API calls.
internal protocol Chat_ChatClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Chat_ChatClientInterceptorFactoryProtocol? { get }

  func add(
    _ request: Chat_AddRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Chat_AddRequest, Chat_AddResponse>

  func fibo(
    _ request: Chat_FiboRequest,
    callOptions: CallOptions?,
    handler: @escaping (Chat_FiboResponse) -> Void
  ) -> ServerStreamingCall<Chat_FiboRequest, Chat_FiboResponse>

  func computeAverage(
    callOptions: CallOptions?
  ) -> ClientStreamingCall<Chat_ComputeAverageRequest, Chat_ComputeAverageResponse>

  func findMaximum(
    callOptions: CallOptions?,
    handler: @escaping (Chat_FindMaximumResponse) -> Void
  ) -> BidirectionalStreamingCall<Chat_FindMaximumRequest, Chat_FindMaximumResponse>
}

extension Chat_ChatClientProtocol {
  internal var serviceName: String {
    return "Chat.Chat"
  }

  /// Unary RPC method
  ///
  /// - Parameters:
  ///   - request: Request to send to Add.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func add(
    _ request: Chat_AddRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Chat_AddRequest, Chat_AddResponse> {
    return self.makeUnaryCall(
      path: "/Chat.Chat/Add",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAddInterceptors() ?? []
    )
  }

  /// Server Streaming RPC method
  ///
  /// - Parameters:
  ///   - request: Request to send to Fibo.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func fibo(
    _ request: Chat_FiboRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Chat_FiboResponse) -> Void
  ) -> ServerStreamingCall<Chat_FiboRequest, Chat_FiboResponse> {
    return self.makeServerStreamingCall(
      path: "/Chat.Chat/Fibo",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeFiboInterceptors() ?? [],
      handler: handler
    )
  }

  /// Client Streaming RPC method
  ///
  /// Callers should use the `send` method on the returned object to send messages
  /// to the server. The caller should send an `.end` after the final message has been sent.
  ///
  /// - Parameters:
  ///   - callOptions: Call options.
  /// - Returns: A `ClientStreamingCall` with futures for the metadata, status and response.
  internal func computeAverage(
    callOptions: CallOptions? = nil
  ) -> ClientStreamingCall<Chat_ComputeAverageRequest, Chat_ComputeAverageResponse> {
    return self.makeClientStreamingCall(
      path: "/Chat.Chat/ComputeAverage",
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeComputeAverageInterceptors() ?? []
    )
  }

  /// Bidirectional Streaming RPC method
  ///
  /// Callers should use the `send` method on the returned object to send messages
  /// to the server. The caller should send an `.end` after the final message has been sent.
  ///
  /// - Parameters:
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ClientStreamingCall` with futures for the metadata and status.
  internal func findMaximum(
    callOptions: CallOptions? = nil,
    handler: @escaping (Chat_FindMaximumResponse) -> Void
  ) -> BidirectionalStreamingCall<Chat_FindMaximumRequest, Chat_FindMaximumResponse> {
    return self.makeBidirectionalStreamingCall(
      path: "/Chat.Chat/FindMaximum",
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeFindMaximumInterceptors() ?? [],
      handler: handler
    )
  }
}

internal protocol Chat_ChatClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'add'.
  func makeAddInterceptors() -> [ClientInterceptor<Chat_AddRequest, Chat_AddResponse>]

  /// - Returns: Interceptors to use when invoking 'fibo'.
  func makeFiboInterceptors() -> [ClientInterceptor<Chat_FiboRequest, Chat_FiboResponse>]

  /// - Returns: Interceptors to use when invoking 'computeAverage'.
  func makeComputeAverageInterceptors() -> [ClientInterceptor<Chat_ComputeAverageRequest, Chat_ComputeAverageResponse>]

  /// - Returns: Interceptors to use when invoking 'findMaximum'.
  func makeFindMaximumInterceptors() -> [ClientInterceptor<Chat_FindMaximumRequest, Chat_FindMaximumResponse>]
}

internal final class Chat_ChatClient: Chat_ChatClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Chat_ChatClientInterceptorFactoryProtocol?

  /// Creates a client for the Chat.Chat service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Chat_ChatClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Chat_ChatProvider: CallHandlerProvider {
  var interceptors: Chat_ChatServerInterceptorFactoryProtocol? { get }

  /// Unary RPC method
  func add(request: Chat_AddRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Chat_AddResponse>

  /// Server Streaming RPC method
  func fibo(request: Chat_FiboRequest, context: StreamingResponseCallContext<Chat_FiboResponse>) -> EventLoopFuture<GRPCStatus>

  /// Client Streaming RPC method
  func computeAverage(context: UnaryResponseCallContext<Chat_ComputeAverageResponse>) -> EventLoopFuture<(StreamEvent<Chat_ComputeAverageRequest>) -> Void>

  /// Bidirectional Streaming RPC method
  func findMaximum(context: StreamingResponseCallContext<Chat_FindMaximumResponse>) -> EventLoopFuture<(StreamEvent<Chat_FindMaximumRequest>) -> Void>
}

extension Chat_ChatProvider {
  internal var serviceName: Substring { return "Chat.Chat" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Add":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Chat_AddRequest>(),
        responseSerializer: ProtobufSerializer<Chat_AddResponse>(),
        interceptors: self.interceptors?.makeAddInterceptors() ?? [],
        userFunction: self.add(request:context:)
      )

    case "Fibo":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Chat_FiboRequest>(),
        responseSerializer: ProtobufSerializer<Chat_FiboResponse>(),
        interceptors: self.interceptors?.makeFiboInterceptors() ?? [],
        userFunction: self.fibo(request:context:)
      )

    case "ComputeAverage":
      return ClientStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Chat_ComputeAverageRequest>(),
        responseSerializer: ProtobufSerializer<Chat_ComputeAverageResponse>(),
        interceptors: self.interceptors?.makeComputeAverageInterceptors() ?? [],
        observerFactory: self.computeAverage(context:)
      )

    case "FindMaximum":
      return BidirectionalStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Chat_FindMaximumRequest>(),
        responseSerializer: ProtobufSerializer<Chat_FindMaximumResponse>(),
        interceptors: self.interceptors?.makeFindMaximumInterceptors() ?? [],
        observerFactory: self.findMaximum(context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Chat_ChatServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'add'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAddInterceptors() -> [ServerInterceptor<Chat_AddRequest, Chat_AddResponse>]

  /// - Returns: Interceptors to use when handling 'fibo'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeFiboInterceptors() -> [ServerInterceptor<Chat_FiboRequest, Chat_FiboResponse>]

  /// - Returns: Interceptors to use when handling 'computeAverage'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeComputeAverageInterceptors() -> [ServerInterceptor<Chat_ComputeAverageRequest, Chat_ComputeAverageResponse>]

  /// - Returns: Interceptors to use when handling 'findMaximum'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeFindMaximumInterceptors() -> [ServerInterceptor<Chat_FindMaximumRequest, Chat_FindMaximumResponse>]
}
