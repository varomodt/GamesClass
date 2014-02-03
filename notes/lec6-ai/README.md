MIT ES.S20 Lecture 6: Modern AI Techniques
-------

# Lecture Outline

1. System Design

2. Chess and Go Programming

3. Pattern Matching in Robocode

4. Searching on Mario

5. Weighting, Learning, and Optimization

6. Genetic Programming and Extremal Optimization

8. Demonstration: Robocode

# System Design

+ The Tree, the Trie, and their applications

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

+ The Canonical Problems of ML

> Choosing the order of the decisions (`moves :: state -> [state -> state]`)
>> This is the problem of *planning*
> 
> Distinguishing the nodes (`move :: state -> state`)
>> This is largely the domain of *classification* and *feature recognition*.
>> Once we know the distinguishing features or regions of a problem, we can
>> construct heuristics and functions to optimize them. In games with
>> incomplete information, we can also use similar techniques to find out
>> things about the unknown game state.
> 
> Choosing the nodes to expand
>> This is 
> 
> Figuring out how to compare our options
>> This is _regression analysis_
> 
> Figuring out how we should behave
>> 

> A lot of the difficulty here is in how, exactly, we _train_ our
> system to play well, but here we can just say that the training method
> will fill in our constants.

> Most of what introduces speed (and complexity) in these problems
> is the _structure_ of the game we're thinking about.

# Chess and Go Programming

+ Evaluation Features

+ Pruning Methods

> Alpha-Beta Pruning

> Lazy Evaluation

> Delta Pruning

> Quiescence Search

```
int Quiesce( int alpha, int beta ) {
    int stand_pat = Evaluate();
    if( stand_pat >= beta )
        return beta;
    if( alpha < stand_pat )
        alpha = stand_pat;
 
    until( every_capture_has_been_examined )  {
        MakeCapture();
        score = -Quiesce( -beta, -alpha );
        TakeBackMove();
 
        if( score >= beta )
            return beta;
        if( score > alpha )
           alpha = score;
    }
    return alpha;
}
```

+ Monte-Carlo Tree Search

+ Quiescence Search

# Pattern Matching in Robocode

# Searching on Mario

# Weighting, Learning, and Optimization

# Genetic Programming and Extremal Optimization


