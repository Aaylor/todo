(** Extensions of String module. *)


include module type of String with type t := string

val split_first : char -> string -> string * string
(** [split_first sep str] split [str] into two parts according to the [sep]
    character. If the [sep] character doesn't exists then the second part
    is returned as an empty string. *)
