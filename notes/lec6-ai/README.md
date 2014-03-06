MIT ES.S20 Lecture 6: Modern AI Techniques
-------

# Lecture Outline

1. System Design

2. Chess and Go Programming

3. Pattern Matching in Robocode

4. Dealing with Hidden State

5. Demonstration: Robocode

# System Design

+ Why do we care about AI

> Most of what introduces speed (and complexity) in these problems
> is the _structure_ of the game we're thinking about.
>> If we say that Nim can be solved by labeling positions with
>> Nimbers, what does that mean about the game?

> If we can solve a game efficiently using a computer, that means
> that we've gained some sort of understanding about what models
> make sense
>> What would it mean if we could algorithmically generate music?

+ Tree Shapes and their applications

> Decision Trees are a very useful and general metaphor for describing
> games: we generally can say that there is some kind of time dependence,
> some kind of moves, and some kind of game states. If that's the case,
> even if we don't completely know the state, we can draw an isomorphism
> to a tree.

> However, we should notice that it's isomorphic to a lot of other things:
> for example, any graph can be represented as an adjacency matrix (as is
> often more useful for economic games). Likewise, we don't actually have
> to store the tree at all: any function that looks like `state -> state`
> can be a tree in much the same way.

+ What does the shape of the tree mean?

> A shallow and thin tree

> A shallow and wide tree

> A deep and thin tree

> A deep and wide tree

> Sometimes, the moves are very complex

+ The Canonical Problems of AI in Games

> Choosing the order of the decisions (`moves :: state -> [state -> state]`)
>> This is the problem of *planning*: for problems in, for example,
>> robotics, this is often most of the issue; but here where the plan is
>> well-defined, we won't deal with it much.


> Distinguishing the nodes (`move :: state -> state`)
>> This is largely the domain of *classification* and *feature recognition*.
>> Once we know the distinguishing features or regions of a problem, we can
>> construct heuristics and functions to optimize them. In games with
>> incomplete information, we can also use similar techniques to find out
>> things about the unknown game state.


> Choosing the nodes to expand
>> Usually a min-queue over a heuristic solves this (what kinds of 
>> heuristics make sense?) This includes various *pruning* methods.


> Figuring out how to compare our options
>> This is the *evaluation* of our position, which looks like
>> `state -> float` generally. What matters in a position and how much
>> is very much a problem of *reinforcement learning* and *model selection*.


> Figuring out how we should behave
>> Do we hedge against safer moves or go to the optimal evaluation?
>> This depends on the game and we can learn it.


> A lot of the difficulty here is in how, exactly, we _train_ our
> system to play well, but here we can just say that the training method
> will fill in our constants.

# Chess and Go Programming

+ Evaluation Features

> The method used to solve Connect-Four was *conspiracy-number search*:

```
(# nodes that need to change for white to provably win,
    # nodes that need to change for black to provably win)
```

> and avoid nodes with large conspiracy numbers. As it happens, you
> can construct an optimal solution this way.

> Chess: Material Balance, Piece Mobility, Pawn Structures
> (isolated, passed, doubled), Weak Squares, Board Control,
> Connectivity, King Safety

> In actual chess programs, the boards are represented as matrices
> of bits (i.e. `bitboard`): How do we extract the features we want
> from this representation?
>> Example: White queen threatening black king?
>> (QueenThreat[WhiteQueenLoc]) & BlackKing

+ Pruning Methods

> Alpha-Beta Pruning: Search up to a certain depth, then remove
> subtrees below (in the case of max) or above (in the case of min)
> certain thresholds. These are alpha and beta -- a lower bound for
> the maximizing player and an upper bound for the minimizing player.
> This does an amazingly good job of removing irrelevant branches.

> Lazy Evaluation: Divide the evaluation function up into subtasks
> and condition their evaluation on the alpha-beta thresholds.

> Quiescence Search: change the move generation order to try checks,
> captures, then threats. If there is an immediately winning move
> sequence, it is likely to be in one of these categories.

> Delta Pruning: before we make a capture in Quiescence search, we make
> sure that that can improve the evaluation of the parent first.
> Otherwise, we prune off the whole tree.

> Aspiration Windows: choose our alpha and beta bounds relative to
> a position estimate (from the evaluation function)

+ Monte-Carlo Tree Search

> MCTS is an example of _best-first search_ in which we only expand
> the most successful nodes. Whenever we add a node, we run n
> simulations of it to a win or loss condition, and take the win 
> percentage as the valuation of the position.

> How can we apply this to Hex?

> How can we use alpha-beta?

+ Transposition Tables

> Store a global hash function from positions to evaluations and test
> membership every time we evaluate a position. This is just a
> _memoization_ of the most expensive operation in searching.

# Pattern Matching in Robocode

+ Introduction

> Robocode is one of the old programming games that I grew up
> on; there used to be frequent competitions, but it mostly died
> with IBM AlphaWorks. (Demonstration)

> There are essentially three problems in Robocode: how do we
> move (Movement), how do we know where our opponent(s) are
> (Scanning), and how do we track their location(s) (Tracking).

> We'll deal with the one-on-one case because with more, it becomes
> more of a tuning problem and somewhat depends on your opponents.
> Also, most of our effort will be directed toward targeting because
> that's much harder than movement.

+ Simplest Method: Virtual Bullets

> Assume that we're meeting a new opponent and we think that one
> of two strategies will work (it's easy to generalize to more).
> The easiest way to deal with this is to just pick one, then we
> continue tracking the location of our opponent and _see which of
> them would have hit_: This is our feedback mechanism.

> Note that targeting strategies look like the firing angle we
> choose; so all of these _virtual bullets_ will be at the same 
> radius from our starting position and we can speak of radial
> _waves_ of bullets.

> When we think of our opponents as doing this, it makes sense to
> _wave surf_, or move in circles around the opponent so as to
> maximize the error variance of their targeting strategy.

> Metrics we might care about: Probability of success, Error distance,
> Error Variance

+ What are we pattern matching?

> The idea of virtual bullets is suggestive of a more general idea:
> the movement of our opponent is going to be some function of
> our relative locations, velocities, and turn rates over the time
> until the wave hits.

> In real robots, it's common to store the previous _n_ enemy movements
> in memory, then say that the current enemy movement will be some
> linear combination of these. We can then extrapolate forward in time
> from the firing time.

> I hope it's obvious that _this is what a person would do if they
> were playing_.

+ Clustering

> Some robots (such as Shadow, the perennial champion) work by
> clustering on angles on waves as a function of velocity vectors
> and distance. This turns out to be _extremely_ efficient for this
> problem.

> Note: these angular offsets are called _GuessFactors_.

+ Learning Weights

> Generally, when we're in a _learning_ problem, we've already identified
> the features we care about and the shape of the probem (which is where
> the real art is)

> Whenever we do any kind of pattern matching, we also care about some
> _cost function_ (`C :: Error -> Float`) which we are trying to
> minimize. We can say for now that this is the error distance

```
Q-Learning:

Q(s, a) = E[Sum(future payoffs of taking action a from state s)]

        = (1 - p) Q(s, a) + p * (r(s) + g * max{ Q(s', a') })

for reward r, discount (immediate reward) factor g, and learning rate p
```

```
TD-Gammon: (learning alg. from a famous backgammon engine)

dw = Change in weight
   = a (change in evaluation) Sum_k {L^(t-k) d(evaluation)/dw}

for some constant L (feedback), a (learning rate)
```

> With _Neural Networks_, we can feed n parameters into a feedforward
> network of simple learning algorithms (which are sometimes just a
> threshold). (board demonstration)

> With _Genetic Programming_, we assume that the weights are
> independent and we evolve a random population by mixing weights.

> There is a whole field dedicated to learning algorithms, but this
> should give some intuition for what they are.

+ Modeled Movement Algorithms

> In addition to wave surfing, there are several other strategies of
> movement worth noting:

> _Anti-Gravity movement_: the movement is random, but the enemy and
> walls look like electrostatically repulsive objects (potential
> field motion planning).

> _Bullet dodging_: do wave targeting in reverse by keeping track of
> enemy firing angle (which you can determine by watching energy drop).

# Dealing with Hidden State

> Examples: Battleship, Kriegspiel

+ Nature is our Adversary

> Assume the worst possible position (the opponent gets to choose where
> all of the pieces are on the board)

+ Distributions over locations

> Another way: assume some prior distribution over locations for each
> piece we know the opponent has via constraints on the pieces. In
> battleship, different pieces can be arranged in different configurations.

> Are these distributions coupled?

> How comfortable are we in setting these priors?

> Do we want to maximize our expected payoff or should we factor
> in risk some other way?

+ Signaling

> Similar to Poker tells: the idea is that if our adversary had board
> structure X, then they would play in this way. This is the primary
> source of information in Kriegspiel.

> This is a teaser for the poker lecture...