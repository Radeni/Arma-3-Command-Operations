params ["_vector1","_vector2"];

_newVector = [(_vector1 select 0) * (_vector2 select 0),(_vector1 select 1) * (_vector2 select 1),(_vector1 select 2) * (_vector2 select 2)];

_newVector;