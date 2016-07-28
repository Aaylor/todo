(** Contains error functions. *)

val abort : string -> 'a
(** [abort msg] write [msg] to [stderr] and exit with code 1. *)
