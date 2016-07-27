(** Extension of Sys module. *)

val getenv_or_empty : string -> string
(** [getenv_or_empty key] search [key] into the environment and returns its
    value. If the key doesn't exists, it returns the empty string. *)
