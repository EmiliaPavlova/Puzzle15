% Emilia Pavlova
% INFM319 Strawberry Prolog Project

?-
  init,
  window(title("Puzzle 15"), size(420, 450), paint_indirectly).

init :-
  array(grid, 16, 0),
  init_grid,
  randomize_puzzle.

win_func(paint) :-
  font(20, 20, "bold"),
  pen(3, rgb(192,192,192)),
  for(X, 0, 3),
    for(Y, 0, 3),
      brush(rgb(255, 255, 255)),
      round_rect(X*100, Y*100, X*100+100, Y*100+100, 10, 10),
      Index is X + Y * 4,
      Number is grid(Index),
      ((Number \= 0) ->
        W is text_out_size(Number),
        XPos is X*100 + (100 - W) / 2,
        text_out(grid(Index), pos(XPos, Y*100+40))
      ),

      ((Number = 0) ->  
        brush(rgb(220, 220, 220)),
        round_rect(X*100, Y*100, X*100+100, Y*100+100, 10, 10)
      ),
  fail.

win_func(mouse_click(W, H)) :-
  X := W // 100,
  Y := H // 100,
  Index is X + Y * 4,
  can_move(Index, Empty, X, Y),
  swap(Index, Empty),
  update_window(_),
  check_win.

init_grid :-
  for(I, 0, 14),
    grid(I) := I+1,
  fail.
init_grid.

shuffle :- 
  X := random(4),
  Y := random(4),
  Index is X + Y * 4,
  can_move(Index, Empty, X, Y),
  swap(Index, Empty).

can_move(Index, Empty, X, Y) :-
  grid(Index - 1) =:= 0,
  X > 0,
  Empty := Index - 1.

can_move(Index, Empty, X, Y) :-
  grid(Index + 1) =:= 0,
  X < 3,
  Empty := Index + 1.

can_move(Index, Empty, X, Y) :-
  grid(Index - 4) =:= 0,
  Y > 0,
  Empty := Index - 4.

can_move(Index, Empty, X, Y) :-
  grid(Index + 4) =:= 0,
  Y < 3,
  Empty := Index + 4.

randomize_puzzle :-
  for(_, 0, 1000),
  shuffle,
  fail.
randomize_puzzle.

swap(A, B) :-
  ValueA := grid(A),
  ValueB := grid(B),
  grid(A) := ValueB,
  grid(B) := ValueA.

check_not_win :- 
  grid(15) =\= 0;
  for(I, 0, 14), 
    grid(I) =\= I + 1.

check_win :-
  not(check_not_win),
  message("Congratulations", "You won the game!", n), nl,
  halt.
