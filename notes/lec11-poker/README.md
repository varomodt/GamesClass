MIT ES.S20 Lecture 11: Poker and Gambling
-------

# Lecture Outline #

1. Rules of Poker

2. Computing Odds

4. Decisions and Regret

5. Opponent Modeling

6. Sampling and Variance

# Rules of Poker #

 + The Main Problem: Texas Hold'em

Each player is dealt two cards and the game consists of four betting rounds (called
_preflop_, _flop_, _turn_, and _river_), during which players have the opportunity
to bet counterclockwise from the dealer. Any player who does not match the highest
bet must fold the round. 

Each player is initially dealt two secret cards, which can be used in conjunction with
public cards (the _board_) to form a hand. After the flop, three cards are placed on
the board, then one after the turn and river. Hands are ranked as such:

  High Card < One Pair  < Two Pairs  < Three of a Kind < Straight
            < Flush     < Full House < Four of a Kind

At the end of the final betting round, the highest-raked hand of all remaining players
will receive all betted money.

 + Simplified Model: Kuhn Poker

For the abstract analyses, I will use _Kuhn Poker_, a vastly simplified two-player game
in which there are only three cards (J, Q, K), two actions (bet 1 or pass), and the 
highest card wins. This

 + Other simplified models

Other possible models include one-card poker (Kuhn with a larger deck); Goofspiel
(bidding on point cards using hand cards); and Liar's Dice (bluff on dice in play).

 + Functional Methodology

Because a lot of the terminology in inferential statistics can get a bit
abstruse and unclear, I will refer to most of the constructs in this derivation
as functions in a computer program (e.g. a distribution would be of type
Sample -> Probability with a normalization constraint).

There is a lot of advantage in the clarity of this approach, not least because
it's much closer to the mathematical form than a linguistic explanation. See
_Structure and Interpretation of Classical Mechanics_ for an example of how
powerful it can be.

I will use a limited (read: simple) subset of Haskell, but it should be
familiar to anyone who has used modern programming languages. The only thing to
note is that it does not require parentheses around function applications, i.e.

    f(x, y) => f x y

Lisp is strictly more difficult, at least for me.

# High-Level Model #

 + Raw probability of winning

We're given our two cards, and a board of 0-5 cards shared by the players. We
get to choose the best hand we can make out of them

    bestHand :: (SecretCards, BoardCards) -> Hand

so that Hands can be compared using the usual operators (<, ==, etc.). We can
define the _spectrum_ of a set of board cards to be a distribution over the best
hands that could be made from it, assuming that the rest of the 5 cards on the
board and the cards in an opponent's hand are dealt in a uniformly random way.

    spectrum :: BoardCards -> (Hand -> Probability)

Our probability of winning with our current cards against one opponent can then be quantified

    probWin secret board = 
        sum (filter (\x -> bestHand secret >= x)
                spectrum board)

And the probability of winning against n opponents is multiplicative.

    probWinAll nOpponents secret board =
        1.0 - (probWin secret board) ** nOpponents

Clearly in poker, these computations are complicated, so our first task is to be able
to estimate probWin. In poker bots, it is usually interpolated over tables. Note that the
dimensionality of hand values is such that they can be efficiently hashed to 32-bit integers.

 + Revising Spectra

We also need to react to our opponents' bets. If we assume some basic opponent rationality,
we can say that our opponent will bet in a certain way if s/he has certain types of cards. So,
there should be some subset of hands in the spectrum that are inconsistent with our
opponent's betting history.

Therefore, we can add a weight adjustment based on priors of what our opponent would bet given
certain types of hands into the spectrum multiplicatively:

    spectrum :: BoardCards -> Prior -> (Hand -> Probability)

The prior is also a function of the pot, player behavior, etc., the influence of which will be
subject to a learning algorithm.

 + Decision-Making

Our decision model will be such that on our probWinAll assessment of the situation, we will define
thresholds F and B such that we just choose

        pWin < F  => Fold
    F < pWin < B  => Call/Check
        pWin > B  => Bet/Raise 

Clearly, the threshold B should be some function of the amount of the bet, which turn it is, and
how much money we have. Practically, the folding threshold is determined by the odds implied by
how much each player has contributed to the pot:

    impliedOdds = remainingBets / (finalPot - futureBets)

    foldThresh  = impliedOdds / (1.0 + impliedOdds)

So, it's basically a ratio measuring what percentage you stand to lose by folding.

 + Opponent Modeling

One of the key steps in the process above is inferring a prior on our opponents' hand from the
betting information, given the state of the game. The traditional approaches look very ad-hoc
to me, so I would recommend an approach based on Bayesian Networks (basically, learn a prior on
the hand evaluation as before):

    Opponent Capital -> Opponent Bets <- Opponent Hand

We can learn weights on the edges.

# Sampling and Regret Minimization #

 + Monte-Carlo Tree Search representation of poker

Let's construct a tree representation of a poker game out of two types of nodes: _action nodes_,
in which we make a decision; and _chance nodes_, in which a random event happens. We can use
this method to serialize random events such as adding cards to the board. We will want to
maintain a _value_ of each action node, the average reward of all simulated games after this
action; and we will maintain a _visit count_, the number of simulations run after a given
action.

The MCTS process, just like in the case of Go, proceeds in four steps, with the added complexity
that we have to maintain _imperfect information_ and _random events_:

1. _Selection_: select the next node to expand. 

2. _Expansion_:

3. _Simulation_:

4. _Backpropagation_: we propagate the results of the simulation up to all of the ancestors
   of the simulated game.

# Regret Minimization #

# Linear Programming #

# Variance Propagation #

