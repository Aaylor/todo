
val add : title:string option -> due_date:string option ->
  priority:int option -> description:string -> unit

val done_ : int list -> unit

type list_kind =
  | Todo
  | Done

val list : list_kind -> unit

val show : int -> unit
