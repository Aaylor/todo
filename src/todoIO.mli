
val mkdir : string -> unit

val with_input : string -> (in_channel -> 'a) -> 'a

val with_output : string -> (out_channel -> 'a) -> 'a
