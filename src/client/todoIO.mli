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

val ask : ?prompt:string -> string -> string
(** [ask_with_prompt ?prompt question] ask a question to user and read the
    anwser from stdin. *)

val ask_until : ?prompt:string -> ?err:string -> string -> (string -> bool)
  -> string
(** [ask_until ?prompt ?err question predicat] ask a question to user and
    read answer from stdin. If the answer does not satisfiate [predicat], then
    [err] is displayed and the question is asked again. *)

val read_until : ?prompt:string -> header:string -> (string -> bool) -> string
(** [read_until ?prompt ?header p] read all line from [stdin] until one
    satisfies the predicate [p]. *)
