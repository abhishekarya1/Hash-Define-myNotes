+++
title = "Notes"
date =  2023-05-08T19:53:00+05:30
weight = 1
+++

## OSI Model
- standardization of network; 7 layers, each having well-defined roles
- client-server model; server processing is just the reverse of client processing
- each layer is agnostic to other layers; we can swap a protocol on a given layer without worrying about breaking other layers

|  Layer | PDU<sup>\*</sup>  | Address  |
|---|---|---|
| Transport Layer  | Segment  | Port  |
| Network Layer  |  Packet | IP Address  |
| Data-Link Layer  | Frame  | MAC Address  |
<sub>*PDU = Protocol Data Unit</sub>

[Reference Diagrams](https://stackoverflow.com/questions/31446777/difference-between-packets-and-frames)

- **not all devices access all layers**; a router only needs routing information, layers above Network doesn't contain any info for routing so it accesses only till layer-3. Switches just need MAC addresses, they access till layer-2 only.
	- a layer-4 proxy or firewall will read till Transport layer and may block communication to/from certain IP (websites) or Ports (applications)
	- our app's listener/controller will access till layer-7 since it is listening to HTTP requests
	- Load balancers, CDN, API gateways access HTTP headers; they are layer-7

Transport layer is called **"Host-to-Host"** because it facilitates delivery to receiver host right till the application level via Ports (like a Host to Host tunnel).

**Shortcomings of OSI model**: its pedantic. Many people dislike OSI model and argue that Layer-5,6,7 can be combined in a single Application Layer.

## Internet Protocol
**IPv4** (32 bits): 4 bytes

**IPv6** (128 bits): 8 nibbles (16 bytes)

Assigned automatically (DHCP), or statically (Static IP)

Divided in two parts (`Network + Host`): parts defined by `/CIDR` notation. 
Ex - `192.168.1.1/24`. First 24 bits are reserved for identifying network. We can have 2^24 networks (aka Subnets), and each network can have 2^8 hosts (all-zero bits and all-one bits are always reserved)

Subnet Mask (`&`): `255.255.255.0` is the mask for `/24` CIDR, it is applied (ANDed) to our IPv4 address and if result is same as our IPv4 address, we don't need network routing as the host is on the same network, otherwise do it.

**Gateway**: a central device that acts as a mediator between two networks. A home router is a gateway (Default Gateway).

### ICMP
Internet Control Message Protocol: to send/receive **meta info packets** over network, all success failure messages are sent via this. Ex - host unreachable, port unreachable, fragmentation needed, etc...

`ping` and `tracert` use it to get info

### IP Packet
`Header + Data` sections

Max data size is 2^16 (65536 bytes) (\~64 KB). `MTU` (Maximum Transmission Unit) of an intermediate devices limits this to around 1500 bytes (\~1.5 KB)!

**Fragmentation**: packets need to get fragmented if it doesn't fit in a frame, MTU of a device specifies what size is allowed, and if packets can't be fragmented, they are dropped by the router! If DF flag (Don't Fragment) is set on the packet, the sender gets the ICMP message to fragment the packets and sent them.

**TTL**: specifies how many hops can a packet survive

**ECN Flag**: If we're about to reach the max congestion limits of the network, a router can set the ECN flag (Explicit Congestion Notification) in the IP packet and as the packet travels theough the network, eventually everyone including the sender and the receiver will know that there is congestion and the sender will slow down.

### ARP
Address Resolution Protocol (layer-2): IP to MAC mapping in LAN (hop).

{{%expand "How do we know destination MAC of a frame that is about to be sent over to the Internet?" %}}_We don't, the frame goes hop-by-hop changing destination MAC to Gateway of that hop._{{% /expand%}} 

Packets on the same network (LAN) are sent to everyone, but _accepted_ only by the host whose MAC address is in the Frame header.
If we don't know MAC address of the receiver, we can broadcast an ARP request and collect MAC addresses of all devices on our network and store/update the ARP Table in our memory. If the receiver is not in our network (identified by applying subnet mask) we will still do an ARP request but for the Gateway's physical address, the Frame will further go **"hop-by-hop"** changing physical address in each **hop** till the receiver in reached.

**Attacks**: Packet Sniffing and ARP Table Poisoning.

**Virtual Router Redundancy Protocol** (VRRP): one IP address shared between multiple hosts (MACs). Good load balancing technique as the traffic can be handled by multiple machines without changing IPs if one machine goes down.

The inverse is the now deprecated RARP (Reverse ARP) replaced by DHCP.

### NAT
Network Address Translation

A NAT table is maintained in the router. It maps the external public IP to internal private IPs of devices and vice-versa. Using NAT, many devices can have a single public IP, e.g. Home Router.

When sending a packet to the Internet, NAT replaces private IP with Router's public IP and vice-versa.

**Used in**: Home Routers, Port forwarding, Carrier-Grade NAT (to save IPv4 addresses by telecoms), Layer-4 Load Balancing + Gateway (HAProxy).

## UDP
User Datagram Protocol: stateless, there is _no connection_ (often called "blind" and "connection-less") and thus it doesn't guarantee the following:
- successful delivery
- order of arrival
- duplicates
- loss

However it does guarantee that _if_ the datagram arrives, it will be correct (error detection using **Checksum**).

**Philosophy**: we just send the datagram, we don't care if it reaches, we don't care if the receiver can process it (flow control), we don't care if the network is busy (congestion control)

The datagram has source and destination addresses in its header, so it can flip them and relpy back to the sender without a connection. But we don't waste time on `ACK`.

**Used in**: Video Streaming, DNS, HTTP/3 (QUIC), VPN, WebRTC (live video chat), Game Servers. It is used in applications where losing a packet or two doesn't affect us much.

**Attacks**: UDP Flooding

**Pros**: simple, fast, stateless, uses less bandwidth, low latency (no handshake)

**Cons**: not reliable, no flow control, no congestion control

https://xkcd.com/935 https://redd.it/33ctkq

## TCP
Transmission Control Protocol: **Stateful** since the server remembers who is the client and what is the state of its connection with it.

Connection is made via a **3-way handshake** before data is actually sent over. Segments are acknowledged with `ACK` segments.

TCP handshake (aka 3-way handshake), is the quintessential part of how TCP/IP works by guranteeing packet delivery (reliability).

Before we get started with sending our `GET` and other HTTP requests, we need to "establish" a connection with the server. TCP does that for us over Transport layer by sending special packets:
1. **SYN** - client sends to the server for synchronization (of seq numbers)
2. **SYN/ACK** - server sends back a new `SYN` (seq no.) and an acknowledgement (`ACK`) in response
3. **ACK** -  client sends the acknowledgement back and the connection is now established

For a SYN (`n`), ACK is `n+1`. **After** connection establishment, seq number will continue from the one that server sent us back. 

[Diagram](https://i.imgur.com/GVu6TxC.png)

Connection is terminated via a **4-way handshake** using `FIN` segments initiated by the client.
1. **FIN** (_client_) - client sends a packet to the server indicating that it wants to close the connection
2. **ACK** - server sends acknowledgement
3. **FIN** (_server_) - server sends FIN packet after a short while
4. **ACK** - client sends `ACK` and waits for a timed_wait before closing and releasing ports and other resources on the server

[Diagram](https://i.imgur.com/6s53eUC.png)

All features are available:
- flow control
- congestion control
- error control (detection and correction)
- retransmission of lost segments

**Cons**: 
- maintaining states has memory overhead
- creating connection has time overhead
- high latency becuase of constant back and forth of meta segments like `ACK`

### Flow Control
**How much can the receiver handle?**

Receiver controls this using `RWND` (Receiver Window) by tuning Window Size field of the Segment.

We can send multiple segments in one go and one  `ACK` will come for all of them having latest one's sequence number.

**Window Size** (`RWND`), the receiver decides window size and conveys the size to the sender in `ACK` segment. We **slide** window on sender's seq segments and keep only those packets in window whose `ACK` is yet to be received.

Window size can go upto 1GB nowadays by including a custom **Window Scaling Factor** field in the TCP segment, default max is 64KB, becuase of 16-bit window size field of the segment.

### Congestion Control
**How much can the network handle? How much can we send?**

Sender controls this using `CWND` (Congestion Window) by tuning MSS (Maximum Segment Size) field.

Two Algorithms:
- **TCP SlowStart**: Increase CWND + 1 MSS after each ACK
- **Congestion Avoidance**: Starts when SlowStart reaches threshold (`ssthresh`), CWND + 1 MSS after each RTT

`CWND` must not exceed `RWND`. And sender can only send segments upto `CWND` or `RWND` without receiving `ACK` for them.

## DNS
Domain Name System

A server that maps to Domain Name (`google.com`) to URL (IP addresses).

Domain Name = www.example.com = Sub-domain + Domain + Top-level domain

Uses Port 53 over UDP. The closer the DNS server, the better it is because DNS lookup/probe latency will be lesser i.e. DNS resolution will be faster. Many CDNs like Google and Cloudflare have DNS servers all around the globe that **cache** DNS info (cache entries have a TTL too).

```txt
DNS Lookup: where is google.com? 

Check Browser Cache, else

--> DNS Resolver Server (maintains cache too)  --> ROOT (where is TLD server for .com domains?) 
											  |--> TLD (where is ANS of google?) 
								              |--> ANS (returns DNS records (incl. IP address) of google.com)

DNS Resolver is recursive and it contacts ROOT NS, TLD NS, and ANS directly once response is received from the previous one in the sequence.
```
ANS (Authoritative Name Server) is our Domain provider itself.

_Reference#1_: https://aws.amazon.com/route53/what-is-dns/
_Reference#2_: https://news.ycombinator.com/item?id=35870654


**DNS Records**: ANS can hold additional info like alias for a domain, sub-domains, etc apart from the IP address info.

```txt
A     - stores IPv4 address of the domain (one domain can have many A records each pointing to diff IPs) (provide redundancy and fallbacks; random one is picked)

AAAA  - stores IPv6 address of the domain (same as above)

CNAME - stores alias(es) of the domain (canonical name record); to config sub-domains (points to another hostname, not IP unlike A record)

MX    - mail exchange record, stores mail server address for the domain

NS    - point to another ANS to query to get IP of the domain
```

**GeoDNS**: Geographical split horizon (different DNS answers based on client's geographical location), setup different `A` records for different regions in the domain provider DNS serttings (Amazon Route 53 is the DNS service for AWS that allows this).

**Attacks**: DNS poisoning

**Uses**: Site blocking, DNS is unencrypted and sent over UDP. The ISP can see what websites we are visiting but not its contents because of HTTPS/TLS.

## Important Concepts for Backend Engg
### MTU & MSS
Default MTU size is 1500 bytes (1.5KB). Packets are fragmented if they are larger than that.

Jumbo packets ones can go upto 9000 bytes (9KB) used by AWS etc... with custom implementation of protocols and networking hardware

Default MSS is 1460 bytes. `MSS = MTU - IP Headers - TCP Headers` => 1500 - 20 - 20

Some routers might drop fragmented UDP packets. So staying under the minimum MTU is often a good idea with UDP.

How do the sender know what is the MTU of the network? **Path MTU Discovery** (PMTUD)
- send packet with sender's default MTU and set DF flag (don't fragment) of the packet
- if Router needs to do fragmentation, it won't fragment seeing the DF flag and it will send back an ICMP message "Fragmentation Needed"
- sender lowers the MTU

### Nagle's Algorithm & Delayed ACK
**Nagle's Algorithm**: send segment without ACK only when we have data that approx equals to MSS

If we're sending 50 bytes of data in a segment, we are wasting so much space (since max MSS data size is 1460 bytes). It was done to make sure we utilize the segment fully and stop sending excess data since ACK is received for previous segments. We may want to send frequently rather than waiting for data to get accumulated.

If ACK is received for previous segments, we can send immediately though even if data is much less than MSS.

Disable it by setting `TCP_NODELAY` option on socket settings. On most servers these days, it is turned off by default.

**Delayed ACK**: why ACK every segment? send delayed ACKs such that as much segments are acknowledged with a single ACK segment

Disable by setting `TCP_QUICKACK` option.

**Consequences**: If Nagle's algo and Delayed ACK mechanisms are enabled together, then its a disaster since both the sender and the receiver will be waiting on each other. Can lead upto 400ms delays.
### Connection Pooling
3-way handshake is slow, on top of that TCP SlowStart and Congestion Avoidance makes is very slow to start talking.

Eastablish a bunch of connections and keep them running. This way TCP SlowStart will already have kicked in and won't delay us at the time of actual request over connection. Congestion window will become bigger when we use that connection.

### TCP FastOpen (TFO)
Use prior connection to reconnect faster without the need to do a full 3-way handshake again.

Send TFO cookie from server to client and use that cookie later when we need to reconnect. Send the TFO cookie piggybacked on SYN alongwith data!

You can have SlowStart with FastOpen because they are unrelated, SlowStart is a congestion control mechanism and FastOpen is making TCP Handshake process faster when we're reconnecting.

Enable in curl by setting `--tcp-fastopen` flag. 

### Listening & Exposing
Be careful what ports you expose to the internet and what server IP you're listening on.
```txt
localhost      loopback (doesn't go beyond self device)
127.0.0.1      loopback IPv4 ( " )
[::1]          loopback IPv6 ( " )
0.0.0.0        all interfaces IPv4 (dangerous!)
[::]           all interfaces IPv6 (dangerous!)
```

We can have our server listen to the same port but on different interfaces (ex - port 8888 on wlan0 and port 8888 on eth0).

We can have our server listen to the same port (say 8888) on IPv4 and IPv6 on the same interface too!
```txt
Listening to port 8888 on http://127.0.0.1:8888
Listening to port 8888 on http://[::1]:8888
```

### TCP HOL Blocking
Head-Of-Line Blocking, a major drawback of HTTP/2

HTTP/2 enabled multiple parallel requests over a single connection using streams.

If segments with seq 2,3,4 have arrived but seq 1 has not, then server won't send ACK for any of them, and client will eventually have to retransmit those segments. Segments 2,3,4 were received but they are useless now.

Segments can totally arrive out-of-order but none one of them can be skipped, they all have to arrive until seq 4 for server to reply with ACK.

### Proxies
**Forward Proxy**: Client1, Client2 -> Proxy -> Server

**Use Cases**: Anonymity, Block Sites

**Reverse Proxy**: Client -> Proxy -> Server1, Server2

**Use Cases**: Load Balancing (API Gateway), Logging (Envoy Sidecar Proxy in Service Mesh), CDN (Edge and Origin servers)

### Load Balancers
**At Layer-4**:
- _faster_, since we're not reading contents with higher protocols
- _secure_, since we can't read the contents
- _stateful_, since only one server per connection handles a request; the LB just routes every segment of one incoming request to one server (_sticky_ per connection)
	- since it doesn't understand any unit above segment, it has to forward each segment of a connection to a fixed server, because it doesn't know if (say HTTP GET) request is using how many segments.

**At Layer-7**:
- _stateless_, routes requests to a backend servers; since it understands where the request starts and where it ends, it can smartly send them over to different servers for stateless processing
- API Gateway logic: authentication, apply filters, cache responses, limit usage
- since it requires to understand protocols, we need LB provider service that supports our protocol, someone that supports our encryption algo, since LB will decrypt (_expensive_)

### Video Streaming Protocols
HTTP-DASH and HLS use TCP.

Dynamic Adaptive Bitrate Streaming (DASH) over HTTP - variable bitrate and resolution.

### Conferencing with WebRTC
WebRTC uses UDP for direct communication between clients (P2P). 

To facilitate address finding and authentication we use non-peer servers like:

**STUN Server**: used to establish a direct UDP connection between two clients, let peers know each other's external address to start the P2P streams transmission behind the NAT

**TURN Server**: used to establish a relayed UDP or TCP connection between two clients. Here, the traffic must be relayed through the TURN server to bypass restrictive firewall rules