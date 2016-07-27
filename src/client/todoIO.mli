(** IO functions. *)

val mkdir : string -> unit
(** [mkdir dir] creates the directory at [dir] if the file doesn't already
    exists. *)

val with_input : string -> (in_channel -> 'a) -> 'a
(** [with_input filename f] opens [filename] and apply the function [f]
    with the correct channel to read. *)

val with_output : string -> (out_channel -> 'a) -> 'a
(** [with_output filename f] does the same thing as [with_input] but for
    writing. *)

