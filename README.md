# OBS Teleport Mobile

Turns your mobile phone into an obs audio video transceiver.

# Connecting to Peerdiscovery
Using flutter and multicast UDP to connect to the default address and do the broadcast there.

```go
// MulticastAddress specifies the multicast address.
// You should be able to use any of 224.0.0.0/4 or ff00::/8.
// By default it uses the Simple Service Discovery Protocol
// address (239.255.255.250 for IPv4 or ff02::c for IPv6).
MulticastAddress string
```

the discoverer is a multicast UDP. It is somewhere in the `peerdiscovery` dependency. 
There is a multicast IP address and a port. You have to join that 
endpoint and send data periodically. The data payload is just a JSON 
struct with the `peerdiscovery` payload that is in `types.go`

```go
type AnnouncePayload struct {
	Name          string
	Port          int
	AudioAndVideo bool
	Version       string
}
```