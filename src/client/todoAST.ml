
type todo = {
  id: int;
  title: string;
  creation_date: float;
  due_date: float option;
  priority: int;
  description: string;
}

let empty =
  { id = -1; title = ""; creation_date = 0.; due_date = None;
    priority = 0; description = "" }

let deserialize filename : todo =
  TodoIO.with_input filename Marshal.from_channel

let serialize (todo : todo) =
  Marshal.to_string todo [ Marshal.No_sharing ]

let pp_datetime = ISO8601.Permissive.pp_datetime

let pp_short_todo fmt todo =
  let ppo fmt t = Format.fprintf fmt "[%a]" pp_datetime t in
  Format.fprintf fmt "[%05d]{%d}%a %s"
    todo.id todo.priority Option.(pp_option ~ppo) todo.due_date todo.title

let pp_todo fmt todo =
  let ppo fmt t = Format.fprintf fmt "Due date the %a@\n" pp_datetime t in
  Format.fprintf fmt
    "[%05d] {%d} %s@\n\
     Created the %a@\n\
     %a\
     ---@\n\
     %s@\n"
    todo.id todo.priority todo.title
    ISO8601.Permissive.pp_datetime todo.creation_date
    Option.(pp_option ~ppo) todo.due_date
    todo.description
