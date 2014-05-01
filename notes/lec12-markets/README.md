MIT ES.S20 Lecture 12: Markets and Networks
-------

# Why is this cool? #

 + Many agents -> online, distributed optimization

 + Huge implications for Mechanism Design

 + Build up a large system out of small control systems

 + This actually looks kind of quaint in comparison to some of the systems we've been talking about.

# Communication and Localization #

Based on `asuman`'s ISIT Tutorial.

## Network Optimization vs. Game Theory ##

When we think about networks, we usually try to perform top-down optimization with respect to delay or total throughput -- such as in Internet networks. What if, though, we want to treat the network at a higher level of granularity as lots of agents trying to serve their own interests. Arguably, this would make for a more robust system and will be much more realistic.

We can define a _Wardrop Equilibrium_ as a Nash Equilibrium with lots of infintesimal players, which the system will converge to with selfish play. It has the very simple variational representation as the extremum with respect to all players' paths.

Then, we have an efficiency metric for a network arranged in a given way:

    efficiency = Cost(Optimal Routing) / Cost(Wardrop Eq.)

We can show that for convex affine functions, this efficiency is always at least 3/4:

    C(WE) = Sum_j (x_eq,j C_j(x_eq,j))
         <= Sum_j (x_j C_j(x_eq,j))
          = Sum_j (x_j C_j(x_j)) + Sum_j (x_j (C_j(x_eq,j) - C_j(x_eq,j)))
         <= Sum_j (x_j C_j(x_j)) + (1/4) Sum_j (x_eq,j C_j(x_eq,j))

Note the similarity in effect to the differential evolutionary games. The key assumption here is that we will not work with discrete players, which can somewhat change the game dynamics (while allowing more complex analyses). The reason for this is that we want to think about resource flow.

_Possibly new info: show via Fixed-point theorems that we must have an equilibrium on any manifold_

## Routing Game ##

Take a directed network labeled with _latency functions_ that map the proportion of players using that edge to an edge cost. This looks like a linear composition of payoff functions on a combinatorial structure. _Show embeddings of prisoner's dilemma, etc._

Maybe, though, we could say that our agents will follow a _locally_ optimal routing, along some partitions of the network (via some router commands, etc.). This is an alternative way to formulate the equilibrium concept, which is provably better than a Wardrop equilibrium.

However, without exploration or knowledge, we can still lose completely. This is why feedback mechanisms are important. What if we could attach prices to edges as a control mechanism? This is exactly how the internet works!

## Price Competition Game ##

Additionally label each edge with a price `p_i` to add to the existing cost. Set a reservation cost R above which the price of routing will be prohibitive. Compare the optimal pricing for both a monopoly and an oligopoly. Sometimes one or the other is more efficient.

## Extensions ##

 + What if traffic has inertia? (Elastic Traffic)

 + What if there are multiple possible destinations?

 + What if some players control a large proportion of the network?

 + What if we can upgrade the network?

 + What if we delay decisions?

## Supermodular Games ##

Supermodular games have _strategic complementarities_, in that the optimal strategy of one player goes with the strategy of the other players. This means that our optimal strategy is some monotonically increasing function of the other strategies. _What are the higher derivatives of these functions?_ The optimal strategies look like lattices: they form a poset.

A major example of these are _potential games_: define some potential function

    E(Q) = - Total Payoff for all players

If we have a regular supermodular structure, this will be an ordinary function of all the players' strategies and they will collectively minimize it. If we label the possible paths through a graph, we see that the congestion networks (for certain classes of latency functions) are special cases of potential games!

Metaphor: Water filling up the potential.

### Mesh Network Game ###

Each player can route traffic onto one of any number of channels and seeks to maximize average throughput. Radiation falls off like `r^2` and chance of packet loss will look like the amount of received power on any given channel. Because we have these sorts of piecewise dependencies, this is actually a matrix-form potential game!

Efficiency of these systems can be defined in terms of spectrum usage and energy (bits/joule).

### Applications ###

 + Distributed Smart Power Grids

 + Power Control

 + Radio Jamming Games

## Market Games and Pricing ##

It's pretty simple to see how this relates to pricing: setting prices in a markets is very much a race to the bottom and often has the character of a network. Take the simple Shapley-Shubik game:

There are a certain number of trading posts, which trade goods for money and vice-versa. At each trading post, some set of traders advertize a fixed price but cannot sell more than they own (endowment) or give more money than they have (balance). A Clearing House finds prices via

    Sum_k Sum_i (Trader i's price for good k in exchange for l * price of good k)
        = Price of good l * Sum_k Sum_i (Trader i's price for good k in exchange for l)

This has a clear graphical representation: a trade of good a for good b is an edge in a graph, labeled with a price. That is a market network; it's a bit more complicated because we have to deal with online updating, but still we can define potentials.

## Queueing Networks ##

We can embed queues into our networks by making the structure

    Node_Prequeue -> Node_Postqueue

with the intermediate edge having some form like `max(x, max_T)`. This is suggestive that we could formulate the problem in terms of the max-plus algebra (we can; this is the major application of max-plus algebras :)

## Network Design ##

We can also play a game in designing the network's links. Each player has a set of nodes they would like to connect with minimum cost. All players using an edge split the cost equally.

 + The price of anarchy can be arbitrarily bad

