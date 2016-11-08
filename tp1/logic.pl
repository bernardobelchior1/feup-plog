create_board(Board):-
  Board = [
  [null, null, null, null, system0, system3, greenNebula, system2, null, null, null],
  [null, null, null, null, blueNebula, system2, system1, blackHole, system1, system1, system1],
  [null, null, null, system2, system3, system0, system2, system2, wormhole, system3, null],
  [null, null, null, system3, wormhole, system1, redNebula, system1, blueNebula, system1, null],
  [null, null, system0, system2, system3, system0, system0, system1, system2, null, null],
  [null, null, space, redNebula, system3, greenNebula, system0, system1, blackHole, system1, null],
  [null, system3, blackHole, greenNebula, system3, system2, system1, system1, null, null, null],
  [null, space, system1, system3, redNebula, wormhole, system0, system1, system1, null, null],
  [space, space, space, system1, blueNebula, system0, system2, null, null, null, null]].

create_players(Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer):-
  Ships = [
  [[0,1], [1,1], [1,0]],
  [[2,7], [3,7], [2,8]]
  ],
  TradeStations = [
  [],
  []
  ],
  Colonies = [
  [],
  []
  ],
  NumPlayers = 2,
  NumShipsPerPlayer = 3.

initialize(Board, Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer):-
  create_board(Board),
  create_players(Ships, TradeStations, Colonies, NumPlayers, NumShipsPerPlayer).

get_piece_position(PieceList, PlayerNo, PieceNo, PiecePosition):-
  list_get_xy(PieceList, PlayerNo, PieceNo, PiecePosition).

next_player(NumPlayers, CurrentPlayer, NextPlayer):-
  CurrentPlayer >= NumPlayers,
  NextPlayer = 0;
  NextPlayer is CurrentPlayer + 1.

%Not
negate(0, Result):-
  Result is 1.
negate(A, Result):-
  Result is 0.

%Checks if a position is equal.
equal_position([X1,Y1], [X2, Y2]):-
  X1 == X2, Y1 == Y2.

%Gets the player and piece in the specified position
get_player_piece_in_position([PlayerPieces | OtherPlayersPieces], Position, PlayerNo, PieceNo):-
  get_piece_number_in_position(PlayerPieces, Position, PieceNo),
  PlayerNo = 0;
  get_player_piece_in_position(OtherPlayersPieces, Position, NextPlayerNo, PieceNo),
  PlayerNo is NextPlayerNo + 1.

%Gets the piece in the specified position
get_piece_number_in_position([FirstPiecePosition | OtherPieces], Position, PieceNo):-
  equal_position(Position, FirstPiecePosition),
  PieceNo = 0;
  get_piece_number_in_position(OtherPieces, Position, NextPieceNo),
  PieceNo is NextPieceNo + 1.

%checks if a direction is valid, X and Y are the distances in X and Y that will be traveled
valid_direction(X,Y) :- (X \= 0; Y\=0), ((X \= 0, Y = 0); (X = 0, Y \= 0); (X = -Y)).

move_ship(Ships, PlayerNo, ShipNo, Direction, NumTiles, NewShips):-
  get_piece_position(Ships, PlayerNo, ShipNo, ShipPosition),
  update_position(ShipPosition, Direction, NumTiles, NewShipPosition),
  list_get_nth(Ships, PlayerNo, PlayerShips),
  list_replace_nth(PlayerShips, ShipNo, NewShipPosition, NewPlayerShips),
  list_replace_nth(Ships, PlayerNo, NewPlayerShips, NewShips).

/*Direction
* Northwest - x   y--
* Northeast - x++ y--
* East -      x++ y
* Southeast - x   y++
* Southwest - x-- y++
* West -      x-- y
*/
update_position([X,Y], northwest, NumTiles, NewPosition):-
  NewY is Y - NumTiles,
  NewPosition = [X, NewY].
update_position([X,Y], northeast, NumTiles, NewPosition):-
  NewX is X + NumTiles,
  NewY is Y - NumTiles,
  NewPosition = [NewX, NewY].
update_position([X,Y], east, NumTiles, NewPosition):-
  NewX is X + NumTiles,
  NewPosition = [NewX, Y].
update_position([X,Y], southeast, NumTiles, NewPosition):-
  NewY is Y + NumTiles,
  NewPosition = [X, NewY].
update_position([X,Y], southwest, NumTiles, NewPosition):-
  NewX is X - NumTiles,
  NewY is Y + NumTiles,
  NewPosition = [NewX, NewY].
update_position([X,Y], west, NumTiles, NewPosition):-
  NewX is X - NumTiles,
  NewPosition = [NewX, Y].
