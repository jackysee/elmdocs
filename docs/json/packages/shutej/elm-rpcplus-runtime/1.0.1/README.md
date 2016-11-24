elm-rpcplus-runtime
===================

This is a runtime to support rpcplus generated clients. Usage:

    import MyProtocol (..)
    import Rpc
    import Signal
    import WebSocket

    -- Request Signal
    rpcRequest : Signal.Channel Request
    rpcRequest = Signal.channel NoRequest

    -- Response Signal
    rpcResponse : Signal.Signal Response
    rpcResponse =
        Rpc.connect protocol
            (WebSocket.connect "wss://myserver.com:443/rpcplus")
            (Signal.subscribe rpcRequest)

    -- Send a request
    Signal.send rpcRequest NoRequest
