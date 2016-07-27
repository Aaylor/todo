(** Utility functions on the option type. *)

open Format

val may : default:'a -> 'a option -> 'a
(** [may ~default o] returns the value of [o] if it exists, [default]
    otherwise. *)

val may_apply : f:('a -> 'b) -> 'a option -> 'b option
(** [may_apply ~f o] apply the function [f] to [o] if the value
    exists. *)

val none_apply : f:(unit -> 'a) -> 'a option -> 'a
(** [none_apply ~f o] returns the value of [o] if it exists, otherwise it
    applies the function [f]. *)

val pp_option : ppo:(formatter -> 'a -> unit) -> formatter -> 'a option -> unit
(** [pp_option ~ppo fmt o] pretty prints the value of [o] using [ppo] if it
    exists, otherwise it does nothing. *)
